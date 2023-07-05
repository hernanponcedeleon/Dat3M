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
            replaceAllCalls(function);
        }
    }

    private void replaceAllCalls(Function thread) {
        int scopeCounter = 0;
        Map<Event, List<DirectFunctionCall>> exitToCallMap = new HashMap<>();
        // Iteratively replace the first call.
        Event event = thread.getEntry();
        assert event instanceof Label;
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
                replaceCall(call, callTarget, ++scopeCounter);
            }
        }
    }

    private void replaceCall(DirectFunctionCall call, Function callTarget, int count) {
        // All occurrences of return events will jump here instead.
        Label exitLabel = newLabel("EXIT_OF_CALL_" + callTarget.getName());
        // Calls with result will write the return value to this register.
        Register result = call instanceof DirectValueFunctionCall c ? c.getResultRegister() : null;
        var replacement = new ArrayList<Event>();
        var replacementMap = new HashMap<Event, Event>();
        var registerMap = new HashMap<Register, Register>();
        List<Expression> arguments = call.getArguments();
        assert arguments.size() == callTarget.getFunctionType().getParameterTypes().size();
        // All registers have to be replaced
        for (Register register : List.copyOf(callTarget.getRegisters())) {
            String newName = count + ":" + register.getName();
            registerMap.put(register, call.getFunction().newRegister(newName, register.getType()));
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
            if (event instanceof Label label) {
                label.setName(count + ":" + label.getName());
            }
        }
        var substitution = new ExprTransformer() {
            @Override
            public Expression visit(Register register) {
                return registerMap.getOrDefault(register, register);
            }
        };
        assert replacement.stream().allMatch(e -> e.getFunction() == null || e.getFunction() == callTarget);
        for (Event event : replacement) {
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
        }
        // Replace call with replacement
        Event predecessor = call.getPredecessor();
        for (Event current : parameterAssignments) {
            predecessor.insertAfter(current);
            predecessor = current;
        }
        for (Event current : replacement) {
            predecessor.insertAfter(current);
            predecessor = current;
        }
        predecessor.insertAfter(call.getSuccessor());
        call.forceDelete();
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
