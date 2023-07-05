package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.RECURSION_BOUND;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

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
        for (Thread thread : program.getThreads()) {
            replaceAllCalls(thread);
        }
    }

    private void replaceAllCalls(Function thread) {
        Map<Function, Integer> counterMap = new HashMap<>();
        Map<Event, List<DirectFunctionCall>> exitToCallMap = new HashMap<>();
        // Iteratively replace the first call.
        Event event = thread.getEntry();
        assert event instanceof Skip;
        while (event != null) {
            exitToCallMap.remove(event);
            // Work with successor because when calls get removed, the loop variable would be invalidated.
            if (!(event.getSuccessor() instanceof DirectFunctionCall call) || call.getCallTarget().isIntrinsic()) {
                event = event.getSuccessor();
                continue;
            }
            // Check whether recursion bound was reached.
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
                // make sure that functions are identified by name
                int count = counterMap.compute(callTarget, (k, v) -> v == null ? 0 : v + 1);
                replaceCall(call, callTarget, count);
            }
        }
    }

    private void replaceCall(DirectFunctionCall call, Function function, int count) {
        // All occurrences of return events will jump here instead.
        Label exitLabel = newLabel("EXIT_OF_CALL_" + function.getName() + "_" + count);
        // Calls with result will write the return value to this register.
        Register result = call instanceof DirectValueFunctionCall c ? c.getResultRegister() : null;
        var replacement = new ArrayList<Event>();
        var replacementMap = new HashMap<Event, Event>();
        var registerMap = new HashMap<Register, Register>();
        List<Expression> arguments = call.getArguments();
        assert arguments.size() == function.getFunctionType().getParameterTypes().size();
        // All registers have to be replaced
        for (Register register : function.getRegisters()) {
            String newName = register.getName() + "_" + function.getName() + "_" + count;
            registerMap.put(register, call.getThread().newRegister(newName, register.getType()));
        }
        for (int j = 0; j < arguments.size(); j++) {
            Register register = function.getParameterRegisters().get(j);
            replacement.add(newLocal(register, arguments.get(j)));
        }
        for (Event functionEvent : function.getEvents()) {
            if (functionEvent instanceof Return returnEvent) {
                Optional<Expression> expression = returnEvent.getValue();
                checkReturnType(result, expression.orElse(null));
                expression.ifPresent(iExpr -> replacement.add(newLocal(result, iExpr)));
                replacement.add(newGoto(exitLabel));
            } else {
                Event copy = functionEvent.getCopy();
                replacement.add(copy);
                replacementMap.put(functionEvent, copy);
            }
        }
        replacement.add(exitLabel);
        for (Event event : replacement) {
            if (event instanceof EventUser user) {
                user.updateReferences(replacementMap);
            }
        }
        var substitution = new ExprTransformer() {
            @Override
            public Expression visit(Register register) {
                return registerMap.getOrDefault(register, register);
            }
        };
        for (Event event : replacement) {
            if (event instanceof RegReader reader) {
                reader.transformExpressions(substitution);
            }
        }
        // Replace call with replacement
        Event predecessor = call.getPredecessor();
        for (Event current : replacement) {
            predecessor.setSuccessor(current);
            predecessor = current;
        }
        predecessor.setSuccessor(call.getSuccessor());
    }

    private void checkReturnType(Register result, Expression expression) {
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
                    String.format("Return %s in function returning %s", expression, result.getType()));
        }
    }
}
