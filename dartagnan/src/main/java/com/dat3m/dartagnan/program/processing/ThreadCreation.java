package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.List;
import java.util.Queue;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.program.event.EventFactory.Pthread.newCreate;
import static com.dat3m.dartagnan.program.event.EventFactory.Pthread.newEnd;
import static com.dat3m.dartagnan.program.event.EventFactory.Pthread.newJoin;
import static com.dat3m.dartagnan.program.event.EventFactory.newLabel;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.dat3m.dartagnan.program.event.EventFactory.newSkip;

/*
 * Replaces all occurrences of calls to pthread_create.
 * Each reachable call is assigned an individual thread object.
 * The function that such a thread executes, gets copied and this copy becomes reachable code, itself.
 */
public class ThreadCreation implements ProgramProcessor {

    private ThreadCreation() {}

    public static ThreadCreation fromConfig(Configuration ignored) throws InvalidConfigurationException {
        return new ThreadCreation();
    }

    @Override
    public void run(Program program) {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        FunctionType threadFunctionType = getThreadFunctionType(types);
        FunctionType threadHandlerType = getThreadHandlerType(types);
        Type archType = types.getArchType();
        int threadCounter = Stream.of(program.getThreads(), program.getFunctions())
                .flatMap(List::stream)
                .mapToInt(Function::getId)
                .max().orElse(0);
        Queue<Thread> queue = new ArrayDeque<>(program.getThreads());
        while (!queue.isEmpty()) {
            Thread thread = queue.remove();
            var threadIdMap = new HashMap<Expression, Expression>();
            for (Event event : List.copyOf(thread.getEvents())) {
                if (!(event instanceof DirectFunctionCall call)) {
                    continue;
                }
                List<Expression> arguments = call.getArguments();
                switch (call.getCallTarget().getName()) {
                    case "pthread_create" -> {
                        assert arguments.size() == 4;
                        Expression pidResultAddress = arguments.get(0);
                        //Expression attributes = arguments.get(1);
                        Expression targetExpression = arguments.get(2);
                        Expression argument = arguments.get(3);

                        assert targetExpression instanceof Function;
                        Function targetFunction = (Function) targetExpression;
                        assert targetFunction.getFunctionType().equals(threadHandlerType);
                        String name = targetFunction.getName();

                        int id = ++threadCounter;
                        Thread childThread = new Thread(name, threadFunctionType, List.of(), id, newSkip());
                        MemoryObject communicationAddress = program.getMemory().allocate(1, true);
                        threadIdMap.put(pidResultAddress, communicationAddress);
                        Register parameterRegister = childThread.newRegister("param_of_T" + id, archType);
                        //TODO this refers to a register of the parent thread.
                        childThread.append(newLocal(parameterRegister, argument));
                        Register resultRegister = childThread.newRegister("result_of_T" + id, archType);
                        List<Expression> targetArguments = List.of(parameterRegister);
                        Event entry = childThread.getEntry();
                        Inlining.inlineBodyAfterCall(entry, resultRegister, targetArguments, targetFunction, -1);
                        childThread.append(newEnd(resultRegister));
                        Event threadExitLabel = newLabel("END_OF_T" + id);
                        childThread.append(threadExitLabel);
                        childThread.updateExit(threadExitLabel);

                        Register result = getResultRegister(call);
                        assert result.getType() instanceof IntegerType;
                        call.insertAfter(newLocal(result, expressions.makeZero((IntegerType) result.getType())));
                        call.replaceBy(newCreate(communicationAddress, name));
                    }
                    case "pthread_join", "__pthread_join" -> {
                        assert arguments.size() == 1;
                        Expression tid = arguments.get(0);
                        Expression threadToJoinWith = threadIdMap.getOrDefault(tid, tid);
                        if (!(threadToJoinWith instanceof MemoryObject communicationAddress)) {
                            throw new UnsupportedOperationException(
                                    "Cannot handle pthread_join with dynamic thread parameter.");
                        }
                        Register result = getResultRegister(call);
                        call.replaceBy(newJoin(result, communicationAddress));
                    }
                    case "get_my_tid" -> {
                        assert arguments.size() == 0;
                        Register result = getResultRegister(call);
                        assert result.getType() instanceof IntegerType;
                        call.replaceBy(newLocal(result, expressions.makeValue(
                                BigInteger.valueOf(thread.getId()),
                                (IntegerType) result.getType())));
                    }
                }
            }
        }
    }

    private Register getResultRegister(DirectFunctionCall call) {
        assert call instanceof DirectValueFunctionCall;
        return ((DirectValueFunctionCall) call).getResultRegister();
    }

    private FunctionType getThreadFunctionType(TypeFactory types) {
        return types.getFunctionType(types.getVoidType(), List.of());
    }

    private FunctionType getThreadHandlerType(TypeFactory types) {
        Type archType = types.getArchType();
        return types.getFunctionType(archType, List.of(archType));
    }
}
