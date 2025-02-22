package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import static com.dat3m.dartagnan.configuration.OptionNames.RECURSION_BOUND;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Verify.verify;

@Options
public class Inlining implements ProgramProcessor {

    @Option(name = RECURSION_BOUND,
            description = "Inlines each function call up to this many times.",
            secure = true)
    private int bound = 1;

    private Inlining() {}

    public static Inlining fromConfig(Configuration config) throws InvalidConfigurationException {
        Inlining process = new Inlining();
        config.inject(process);
        return process;
    }

    @Override
    public void run(Program program) {
        final Map<Function, Snapshot> snapshots = new HashMap<>();
        for (final Function function : program.getFunctions()) {
            snapshots.put(function, new Snapshot(
                    function.getName(),
                    function.getParameterRegisters(),
                    function.getEvents(),
                    List.copyOf(function.getRegisters()),
                    function.getFunctionType().isVarArgs()));
        }
        for (final Function function : program.getFunctions()) {
            inlineAllCalls(function, snapshots);
        }
        for (final Thread thread : program.getThreads()) {
            inlineAllCalls(thread, snapshots);
        }
    }

    private record Snapshot(String name, List<Register> parameters, List<Event> events, List<Register> registers, boolean isVarArgs) {}

    private boolean canInline(FunctionCall call) {
        return call.isDirectCall() && call.getCalledFunction().hasBody();
    }

    private void inlineAllCalls(Function function, Map<Function, Snapshot> snapshots) {
        int scopeCounter = 0;
        final Map<Event, List<Function>> exitToCallMap = new HashMap<>();
        // Iteratively replace the first call.
        Event event = function.getEntry();
        while (event != null) {
            exitToCallMap.remove(event);
            if (!(event instanceof FunctionCall call) || !canInline(call)) {
                event = event.getSuccessor();
                continue;
            }
            // Check whether recursion bound was reached.
            final Function callTarget = call.getCalledFunction();
            exitToCallMap.computeIfAbsent(call.getSuccessor(), k -> new ArrayList<>()).add(callTarget);
            final long depth = exitToCallMap.values().stream().filter(c -> c.contains(callTarget)).count();
            if (depth > bound) {
                final Event boundEvent = EventFactory.newTerminator(function, Tag.BOUND, Tag.NONTERMINATION, Tag.NOOPT);
                event = IRHelper.replaceWithMetadata(call, boundEvent);
            } else {
                if (callTarget instanceof Thread) {
                    throw new MalformedProgramException(
                            String.format("Cannot call thread %s directly.", callTarget));
                }
                event = inlineBody(call, snapshots.get(callTarget), ++scopeCounter);
            }
        }
    }

    // Returns the first event of the inlined code, from where to continue from
    private static Event inlineBody(FunctionCall call, Snapshot callTarget, int scope) {
        // ================================ Add marker events ================================
        final Event callMarker = EventFactory.newFunctionCallMarker(callTarget.name);
        final Event returnMarker = EventFactory.newFunctionReturnMarker(callTarget.name);
        callMarker.copyAllMetadataFrom(call);
        returnMarker.copyAllMetadataFrom(call);
        call.insertBefore(callMarker);
        call.insertAfter(returnMarker);
        //  --- SVCOMP-specific code ---
        final boolean isSvcompAtomic = callTarget.name.startsWith("__VERIFIER_atomic");
        if (isSvcompAtomic) {
            final BeginAtomic beginAtomic = EventFactory.Svcomp.newBeginAtomic();
            final EndAtomic endAtomic = EventFactory.Svcomp.newEndAtomic(beginAtomic);
            call.insertBefore(beginAtomic);
            call.insertAfter(endAtomic);
        }
        // =================================================================================

        // ================================ Main logic =====================================
        // --------- Compute register replacements & parameter assignments  ---------
        final Map<Register, Register> registerMap = IRHelper.copyOverRegisters(callTarget.registers, call.getFunction(),
                reg -> scope + ":" + reg.getName(), true);

        final List<Expression> arguments = call.getArguments();
        //TODO add support for __VA_INIT
        verify(callTarget.isVarArgs ? arguments.size() >= callTarget.parameters.size() :
                arguments.size() == callTarget.parameters.size(), "Parameter mismatch at %s", call);
        final ArrayList<Event> parameterAssignments = new ArrayList<>();
        for (int j = 0; j < callTarget.parameters.size(); j++) {
            final Register register = registerMap.get(callTarget.parameters.get(j));
            parameterAssignments.add(newLocal(register, arguments.get(j)));
        }

        // --------- Inline call ---------
        final Consumer<Event> copyUpdater = IRHelper.makeRegisterReplacer(registerMap)
                .andThen(copy -> {
                    if (copy instanceof Label label) {
                        label.setName(scope + ":" + label.getName());
                    }
                    // TODO: Add support for control barriers
                });
        final List<Event> inlinedBody = IRHelper.copyEvents(callTarget.events, copyUpdater, new HashMap<>());
        final Label returnLabel = newLabel("EXIT_OF_CALL_" + callTarget.name + "_" + scope);
        call.insertAfter(eventSequence(
                parameterAssignments,
                inlinedBody,
                returnLabel
        ));

        // --------- Post process inlined body ---------
        // Replace Return events by (assignment + jump)
        final Register resultReg = call instanceof ValueFunctionCall c ? c.getResultRegister() : null;
        inlinedBody.stream().filter(Return.class::isInstance).map(Return.class::cast).forEach(returnEvent -> {
            final Expression expression = returnEvent.getValue().orElse(null);
            checkReturnType(resultReg, expression);
            final List<Event> replacement = eventSequence(
                    expression != null ? newLocal(resultReg, expression) : null,
                    newGoto(returnLabel)
            );
            IRHelper.replaceWithMetadata(returnEvent, replacement);
        });

        final Event successor = call.getSuccessor();
        call.tryDelete();
        return successor;
    }

    private static void checkReturnType(Register result, Expression expression) {
        if (result == null && expression != null) {
            throw new MalformedProgramException(
                    String.format("Return %s in function returning void.", expression));
        }
        if (result != null && expression == null) {
            throw new MalformedProgramException(
                    String.format("Missing return expression in function returning %s", result.getType()));
        }
        if (result != null && !result.getType().equals(expression.getType())) {
            throw new MalformedProgramException(
                    String.format("Return expression %s of type %s in function returning %s", expression, expression.getType(), result.getType()));
        }
    }
}
