package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.program.event.EventFactory.Pthread.newCreate;
import static com.dat3m.dartagnan.program.event.EventFactory.Pthread.newJoin;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;

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

    private Thread createThreadFromFunction(Function function, int tid, Event creator, Expression comAddr) {
        //TODO: Handle parameters

        // Create new thread
        final Thread thread = new Thread(function.getName(), function.getFunctionType(),
                Lists.transform(function.getParameterRegisters(), Register::getName), tid, EventFactory.newSkip());

        // Copy register from target function into new thread
        final Map<Register, Register> registerReplacement = new HashMap<>();
        for (Register reg : function.getRegisters()) {
            registerReplacement.put(reg, thread.getOrNewRegister(reg.getName(), reg.getType()));
        }
        final ExpressionVisitor<Expression> regSubstituter = new ExprTransformer() {
            @Override
            public Expression visit(Register reg) {
                return Preconditions.checkNotNull(registerReplacement.get(reg));
            }
        };

        // Copy, update, and append the function body to the thread
        final List<Event> body = new ArrayList<>();
        final Map<Event, Event> copyMap = new HashMap<>();
        function.getEvents().forEach(e -> body.add(copyMap.computeIfAbsent(e, Event::getCopy)));
        for (Event copy : body) {
            if (copy instanceof EventUser user) {
                user.updateReferences(copyMap);
            }
            if (copy instanceof RegReader reader) {
                reader.transformExpressions(regSubstituter);
            }
            if (copy instanceof LlvmCmpXchg xchg) {
                xchg.setStructRegister(0, registerReplacement.get(xchg.getStructRegister(0)));
                xchg.setStructRegister(1, registerReplacement.get(xchg.getStructRegister(1)));
            } else if (copy instanceof RegWriter regWriter) {
                regWriter.setResultRegister(registerReplacement.get(regWriter.getResultRegister()));
            }
        }
        thread.getEntry().insertAfter(body);

        // Add end & return label
        final Label threadReturnLabel = EventFactory.newLabel("RETURN_OF_T" + tid);
        final Label threadEnd = EventFactory.newLabel("END_OF_T" + tid);
        thread.append(threadReturnLabel);
        thread.append(threadEnd);

        // Replace AbortIf and Return
        final Register returnRegister = function.getFunctionType().getReturnType() != null ?
                thread.newRegister("__retval", function.getFunctionType().getReturnType()) : null;
        for (Event e : thread.getEvents()) {
            if (e instanceof AbortIf abort) {
                abort.replaceBy(EventFactory.newJump(abort.getCondition(), threadEnd));
            } else if (e instanceof Return ret) {
                ret.insertAfter(EventFactory.newGoto(threadReturnLabel));
                if (ret.hasValue()) {
                    ret.replaceBy(EventFactory.newLocal(returnRegister, ret.getValue().get()));
                } else {
                    ret.forceDelete();
                }
            }
        }

        // Add Start & End events if this thread was spawned
        if (creator != null) {
            thread.getEntry().insertAfter(EventFactory.Pthread.newStart(comAddr, creator));
            threadReturnLabel.insertAfter(EventFactory.Pthread.newEnd(comAddr));
        }

        return thread;
    }

    @Override
    public void run(Program program) {
        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final IntegerType archType = types.getArchType();

        // TODO:  test code
        program.getThreads().clear();

        int threadCounter = Stream.concat(program.getThreads().stream(), program.getFunctions().stream())
                .mapToInt(Function::getId)
                .max().orElse(0);

        final Function main = program.getFunctions().stream().filter(f -> f.getName().equals("main")).findFirst().get();
        final Queue<Thread> workingQueue = new ArrayDeque<>();
        workingQueue.add(createThreadFromFunction(main, threadCounter, null, null));

        while (!workingQueue.isEmpty()) {
            final Thread thread = workingQueue.remove();
            program.addThread(thread);

            final Map<Expression, Expression> expr2TidMap = new HashMap<>();
            final Map<Expression, Expression> tid2ComAddrMap = new HashMap<>();

            for (Event event : thread.getEvents()) {
                if (event instanceof Load load && expr2TidMap.containsKey(load.getAddress())) {
                    final Expression tidExpr = expr2TidMap.get(load.getAddress());
                    load.replaceBy(newLocal(load.getResultRegister(), tidExpr));
                    expr2TidMap.put(load.getResultRegister(), tidExpr);
                }

                if (!(event instanceof DirectFunctionCall call)) {
                    continue;
                }
                final List<Expression> arguments = call.getArguments();
                switch (call.getCallTarget().getName()) {
                    case "pthread_create" -> {
                        assert arguments.size() == 4;
                        final Expression pidResultAddress = arguments.get(0);
                        //Expression attributes = arguments.get(1);
                        final Function targetFunction = (Function)arguments.get(2);
                        final Expression argument = arguments.get(3);

                        final String name = targetFunction.getName();
                        final int nextTid = ++threadCounter;

                        final MemoryObject comAddress = program.getMemory().allocate(1, true);
                        comAddress.setCVar("__com_" + name + "_" + nextTid);
                        final Event createEvent = newCreate(comAddress, name);
                        call.replaceBy(createEvent);

                        workingQueue.add(createThreadFromFunction(targetFunction, nextTid, createEvent, comAddress));

                        // Helper code to do constant propagation of generated tid's
                        final Expression tidExpr = expressions.makeValue(BigInteger.valueOf(thread.getId()), archType);
                        expr2TidMap.put(pidResultAddress, tidExpr);
                        tid2ComAddrMap.put(tidExpr, comAddress);

                    }
                    case "pthread_join", "__pthread_join" -> {
                        assert arguments.size() == 2;
                        final Expression tid = arguments.get(0);
                        // Expression returnAddr = arguments.get(1);
                        final Expression comAddrOfThreadToJoinWith = tid2ComAddrMap.get(expr2TidMap.get(tid));
                        if (comAddrOfThreadToJoinWith == null) {
                            throw new UnsupportedOperationException(
                                    "Cannot handle pthread_join with dynamic thread parameter.");
                        }
                        call.replaceBy(newJoin(getResultRegister(call), comAddrOfThreadToJoinWith));
                    }
                    case "get_my_tid" -> {
                        assert arguments.size() == 0;
                        final Register result = getResultRegister(call);
                        assert result.getType() instanceof IntegerType;
                        call.replaceBy(newLocal(result, expressions.makeValue(
                                BigInteger.valueOf(thread.getId()),
                                (IntegerType) result.getType())));
                    }
                }
            }
        }

        EventIdReassignment.newInstance().run(program);
    }

    private Register getResultRegister(DirectFunctionCall call) {
        assert call instanceof DirectValueFunctionCall;
        return ((DirectValueFunctionCall) call).getResultRegister();
    }


}
