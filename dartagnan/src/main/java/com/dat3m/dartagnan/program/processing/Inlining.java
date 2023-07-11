package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.RECURSION_BOUND;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.google.common.base.Preconditions.checkNotNull;

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
        for (Function function : program.getFunctions()) {
            inlineAllCalls(function);
        }
    }

    private void inlineAllCalls(Function function) {
        int scopeCounter = 0;
        Map<Event, List<DirectFunctionCall>> exitToCallMap = new HashMap<>();
        // Iteratively replace the first call.
        Event event = function.getEntry();
        while (event != null) {
            exitToCallMap.remove(event);
            // Work with successor because when calls get removed, the loop variable would be invalidated.
            if (!(event.getSuccessor() instanceof DirectFunctionCall call) || !call.getCallTarget().hasBody()) {
                event = event.getSuccessor();
                continue;
            }
            // Check whether recursion bound was reached.
            // FIXME: The recursion check does not work
            exitToCallMap.computeIfAbsent(call.getSuccessor(), k -> new ArrayList<>()).add(call);
            long depth = exitToCallMap.values().stream().filter(c -> c.contains(call)).count();
            if (depth > bound) {
                AbortIf boundEvent = newAbortIf(ExpressionFactory.getInstance().makeTrue());
                boundEvent.copyAllMetadataFrom(call);
                boundEvent.addTags(Tag.BOUND, Tag.EARLYTERMINATION, Tag.NOOPT);
                call.replaceBy(boundEvent);
            } else {
                Function callTarget = call.getCallTarget();
                if (callTarget instanceof Thread) {
                    throw new MalformedProgramException(
                            String.format("Cannot call thread %s directly.",
                                    call.getCallTarget()));
                }
                call.getPredecessor().insertAfter(EventFactory.newFunctionCall(callTarget.getName()));
                call.insertAfter(EventFactory.newFunctionReturn(callTarget.getName()));
                // Calls with result will write the return value to this register.
                Register result = call instanceof DirectValueFunctionCall c ? c.getResultRegister() : null;
                inlineBodyAfterCall(call, result, call.getArguments(), callTarget, ++scopeCounter);
                event = call.getSuccessor();
                call.forceDelete();
            }
        }
    }

    static void inlineBodyAfterCall(Event entry, Register result, List<Expression> arguments, Function callTarget, int scope) {
        // All occurrences of return events will jump here instead.
        Label exitLabel = newLabel("EXIT_OF_CALL_" + callTarget.getName() + "_" + scope);
        var inlinedBody = new ArrayList<Event>();
        var replacementMap = new HashMap<Event, Event>();
        var registerMap = new HashMap<Register, Register>();
        assert arguments.size() == callTarget.getFunctionType().getParameterTypes().size();
        // All registers have to be replaced
        for (Register register : List.copyOf(callTarget.getRegisters())) {
            String newName = scope + ":" + register.getName();
            registerMap.put(register, entry.getFunction().newRegister(newName, register.getType()));
        }
        var parameterAssignments = new ArrayList<Event>();
        for (int j = 0; j < arguments.size(); j++) {
            Register register = registerMap.get(callTarget.getParameterRegisters().get(j));
            parameterAssignments.add(newLocal(register, arguments.get(j)));
        }
        for (Event functionEvent : callTarget.getEvents()) {
            if (functionEvent instanceof Return returnEvent) {
                Optional<Expression> expression = returnEvent.getValue();
                checkReturnType(result, expression.orElse(null));
                expression.ifPresent(iExpr -> inlinedBody.add(newLocal(result, iExpr)));
                inlinedBody.add(newGoto(exitLabel));
            } else {
                Event copy = functionEvent.getCopy();
                inlinedBody.add(copy);
                replacementMap.put(functionEvent, copy);
            }
        }

        for (Event event : inlinedBody) {
            if (event instanceof EventUser user) {
                user.updateReferences(replacementMap);
            }
            if (event instanceof Label label) {
                label.setName(scope + ":" + label.getName());
            }
        }

        // Substitute registers in the copied body
        var substitution = new ExprTransformer() {
            @Override
            public Expression visit(Register register) {
                return checkNotNull(registerMap.get(register));
            }
        };
        for (Event event : inlinedBody) {
            if (event instanceof RegReader reader) {
                reader.transformExpressions(substitution);
            }
            if (event instanceof RegWriter writer && !(writer instanceof LlvmCmpXchg)) {
                Register oldRegister = writer.getResultRegister();
                Register newRegister = registerMap.get(oldRegister);
                assert newRegister != null || writer.getResultRegister() == oldRegister;
                if (newRegister != null) {
                    writer.setResultRegister(newRegister);
                }
            }
            if (event instanceof LlvmCmpXchg cmpXchg) {
                Register oldResultRegister = cmpXchg.getStructRegister(0);
                Register newResultRegister = registerMap.get(oldResultRegister);
                assert newResultRegister != null;
                cmpXchg.setStructRegister(0, newResultRegister);
                Register oldExpectationRegister = cmpXchg.getStructRegister(1);
                Register newExpectationRegister = registerMap.get(oldExpectationRegister);
                assert newExpectationRegister != null;
                cmpXchg.setStructRegister(1, newExpectationRegister);
            }
        }

        // Replace call with replacement
        // this places parameterAssignments before inlinedBody
        entry.insertAfter(exitLabel);
        entry.insertAfter(inlinedBody);
        entry.insertAfter(parameterAssignments);
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
