package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.op.IOpUn;
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
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

/*
 * This pass handles (reachable) pthread-related function calls.
 * - each pthread_create call spawns a new Thread object.
 * - pthread_join calls are lowered to appropriate synchronization primitives.
 * - get_my_tid calls are replaced by constant tid values.
 * Initially, a single thread from the "main" function is spawned.
 * Then the pass works iteratively by picking a (newly created) thread and handling all its pthread calls.
 *
 * TODO:
 *  (1) Make sure that non-deterministic expressions are recreated properly (avoid wrong sharing)
 *  (2) Make this pass able to run after compilation.
 *  (3) Make sure that metadata is copied correctly.
 */
@Options
public class ThreadCreation implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(ThreadCreation.class);

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed.",
            secure = true,
            toUppercase = true)
    private boolean forceStart = false;

    private final Compilation compiler;

    private ThreadCreation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        compiler = Compilation.fromConfig(config);
    }

    public static ThreadCreation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ThreadCreation(config);
    }

    @Override
    public void run(Program program) {
        if (program.getFormat().equals(Program.SourceLanguage.LITMUS)) {
            return;
        }

        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final IntegerType archType = types.getArchType();

        final Optional<Function> main = program.getFunctions().stream().filter(f -> f.getName().equals("main")).findFirst();
        if (main.isEmpty()) {
            throw new MalformedProgramException("Program contains no main function");
        }

        final int maxId = Stream.concat(program.getThreads().stream(), program.getFunctions().stream())
                .mapToInt(Function::getId)
                .max().orElse(0);
        int nextTid = maxId + 1;

        final Queue<Thread> workingQueue = new ArrayDeque<>();
        workingQueue.add(createThreadFromFunction(main.get(), nextTid++, null, null));

        while (!workingQueue.isEmpty()) {
            final Thread thread = workingQueue.remove();
            program.addThread(thread);

            final Map<Expression, Expression> tid2ComAddrMap = new HashMap<>();
            for (DirectFunctionCall call : thread.getEvents(DirectFunctionCall.class)) {
                final List<Expression> arguments = call.getArguments();
                switch (call.getCallTarget().getName()) {
                    case "pthread_create" -> {
                        assert arguments.size() == 4;
                        final Expression pidResultAddress = arguments.get(0);
                        //final Expression attributes = arguments.get(1);
                        final Function targetFunction = (Function)arguments.get(2);
                        final Expression argument = arguments.get(3);

                        final Register resultRegister = getResultRegister(call);
                        assert resultRegister.getType() instanceof IntegerType;

                        final ThreadCreate createEvent = newThreadCreate(List.of(argument));
                        final Expression tidExpr = expressions.makeValue(BigInteger.valueOf(nextTid), archType);
                        final MemoryObject comAddress = program.getMemory().allocate(1, true);
                        comAddress.setCVar("__com" + nextTid + "__" + targetFunction.getName());

                        final List<Event> replacement = eventSequence(
                                createEvent,
                                newReleaseStore(comAddress, expressions.makeTrue()),
                                newStore(pidResultAddress, tidExpr),
                                // TODO: Allow to return failure value (!= 0)
                                newLocal(resultRegister, expressions.makeZero((IntegerType) resultRegister.getType()))
                        );
                        replacement.forEach(e -> e.copyAllMetadataFrom(call));
                        call.replaceBy(replacement);

                        final Thread spawnedThread = createThreadFromFunction(targetFunction, nextTid, createEvent, comAddress);
                        createEvent.setSpawnedThread(spawnedThread);
                        workingQueue.add(spawnedThread);

                        tid2ComAddrMap.put(tidExpr, comAddress);
                        propagateThreadIds(tidExpr, pidResultAddress, createEvent);

                        nextTid++;
                    }
                    case "pthread_join", "__pthread_join" -> {
                        assert arguments.size() == 2;
                        final Expression tidExpr = arguments.get(0);
                        // TODO: support return values for threads
                        // final Expression returnAddr = arguments.get(1);

                        final Register resultRegister = getResultRegister(call);
                        assert resultRegister.getType() instanceof IntegerType;
                        final Expression comAddrOfThreadToJoinWith = tid2ComAddrMap.get(tidExpr);
                        if (comAddrOfThreadToJoinWith == null) {
                            throw new UnsupportedOperationException(
                                    "Cannot handle pthread_join with dynamic thread parameter.");
                        }
                        final int tid = tidExpr.reduce().getValueAsInt();
                        final Register joinDummyReg = thread.getOrNewRegister("__joinT" + tid, types.getBooleanType());
                        final List<Event> replacement = eventSequence(
                                newAcquireLoad(joinDummyReg, comAddrOfThreadToJoinWith),
                                newJump(joinDummyReg, (Label)thread.getExit()),
                                // Note: In our modelling, pthread_join always succeeds if it returns
                                newLocal(resultRegister, expressions.makeZero((IntegerType) resultRegister.getType()))
                        );
                        replacement.forEach(e -> e.copyAllMetadataFrom(call));
                        call.replaceBy(replacement);
                    }
                    case "get_my_tid" -> {
                        final Register resultRegister = getResultRegister(call);
                        assert resultRegister.getType() instanceof IntegerType;
                        assert arguments.size() == 0;
                        final Expression tidExpr = expressions.makeValue(BigInteger.valueOf(thread.getId()),
                                (IntegerType) resultRegister.getType());
                        final Local tidAssignment = newLocal(resultRegister, tidExpr);
                        tidAssignment.copyAllMetadataFrom(call);
                        call.replaceBy(tidAssignment);
                    }
                }
            }
        }

        IdReassignment.newInstance().run(program);
        logger.info("Number of threads (including main): " + program.getThreads().size());
    }


    // Helper code to do constant propagation of generated tid's to pthread_join calls
    //TODO: Ideally, this kind of propagation shouldn't be done here.
    // Also, it is currently unsound if the code is not in SSA, for example, after unrolling.
    private static void propagateThreadIds(Expression tidExpr, Expression tidResultAddress, ThreadCreate createEvent) {
        Set<Expression> tidValues = new HashSet<>();
        Set<Expression> tidPtrs = new HashSet<>();
        tidPtrs.add(tidResultAddress);

        // Backpropagation of pointers:
        // "p1 <- pExpr; pthread_create(pExpr, ...)"   =>   p1 also points to an address holding a tid
        for (Event pred : createEvent.getPredecessors()) {
            if (pred instanceof Local local && tidPtrs.contains(local.getResultRegister())) {
                tidPtrs.add(local.getExpr());
            }
        }
        // Forward propagation
        // (1) p1 <- pExpr       =>     p1 points to tid if pExpr does
        // (2) r1 <- expr        =>     r1 holds tid if expr does
        // (3) r  <- load(pExpr) =>     r holds tid if pExpr points to tid
        for (Event succ : createEvent.getSuccessors()) {
            if (succ instanceof Load load && tidPtrs.contains(load.getAddress())) {
                // Do tid propagation over loads
                tidValues.add(load.getResultRegister());
            }
            if (succ instanceof Local local) {
                Expression rhs = local.getExpr();
                while (rhs instanceof IExprUn unExpr && unExpr.getOp() == IOpUn.CAST_UNSIGNED) {
                    // Try to skip cast expressions
                    rhs = unExpr.getInner();
                }
                if (tidPtrs.contains(rhs)) {
                    tidPtrs.add(local.getResultRegister());
                } else if (tidValues.contains(rhs)) {
                    tidValues.add(local.getResultRegister());
                }
            }

            // Here we actually change pthread_join's first argument to directly hold the target tid
            if (succ instanceof DirectFunctionCall call && call.getCallTarget().getName().contains("pthread_join")) {
                if (tidValues.contains(call.getArguments().get(0))) {
                    // TODO: Direct access to call's argument list is fishy.
                    //  Calls should have a setArgument function instead.
                    call.getArguments().set(0, tidExpr);
                }
            }
        }
    }

    private Thread createThreadFromFunction(Function function, int tid, ThreadCreate creator, Expression comAddr) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final TypeFactory types = TypeFactory.getInstance();

        // ------------------- Create new thread -------------------
        final ThreadStart start = EventFactory.newThreadStart(creator);
        start.setMayFailSpuriously(!forceStart);
        final Thread thread = new Thread(function.getName(), function.getFunctionType(),
                Lists.transform(function.getParameterRegisters(), Register::getName), tid, start);
        thread.copyDummyCountFrom(function);

        // ------------------- Copy registers from target function into new thread -------------------
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

        // ------------------- Copy, update, and append the function body to the thread -------------------
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

        // ------------------- Add end & return label -------------------
        final Label threadReturnLabel = EventFactory.newLabel("RETURN_OF_T" + tid);
        final Label threadEnd = EventFactory.newLabel("END_OF_T" + tid);
        thread.append(threadReturnLabel);
        thread.append(threadEnd);

        // ------------------- Replace AbortIf and Return -------------------
        final Register returnRegister = function.hasReturnValue() ?
                thread.newRegister("__retval", function.getFunctionType().getReturnType()) : null;
        for (Event e : thread.getEvents()) {
            if (e instanceof AbortIf abort) {
                final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
                jumpToEnd.addTags(abort.getTags());
                abort.replaceBy(jumpToEnd);
            } else if (e instanceof Return ret) {
                ret.insertAfter(EventFactory.newGoto(threadReturnLabel));
                if (returnRegister != null) {
                    ret.insertAfter(EventFactory.newLocal(returnRegister, ret.getValue().get()));
                }
                if (!ret.tryDelete()) {
                    throw new MalformedProgramException("Unable to delete " + ret);
                }
            }
        }

        // ------------------- Add Sync, End, and Argument events if this thread was spawned -------------------
        if (creator != null) {
            // Arguments
            final List<Register> params = thread.getParameterRegisters();
            for (int i = 0; i < params.size(); i++) {
                thread.getEntry().insertAfter(newThreadArgument(params.get(i), creator, i));
            }

            // Sync
            final Register startSignal = thread.newRegister("__startT" + tid, types.getBooleanType());
            thread.getEntry().insertAfter(eventSequence(
                    newAcquireLoad(startSignal, comAddr),
                    newAssume(startSignal)
            ));

            // End
            threadReturnLabel.insertAfter(newReleaseStore(comAddr, expressions.makeFalse()));
        }

        // ------------------- Create thread-local variables -------------------
        final Memory memory = function.getProgram().getMemory();
        final Map<Expression, Expression> global2ThreadLocal = new HashMap<>();
        final ExprTransformer transformer = new ExprTransformer() {
            @Override
            public Expression visit(MemoryObject memObj) {
                if (memObj.isThreadLocal() && !global2ThreadLocal.containsKey(memObj)) {
                    final MemoryObject threadLocalCopy = memory.allocate(memObj.size(), true);
                    final String varName = String.format("%s@T%s", memObj.getCVar(), thread.getId());
                    threadLocalCopy.setCVar(varName);
                    for (int i = 0; i < memObj.size(); i++) {
                        threadLocalCopy.setInitialValue(i, memObj.getInitialValue(i));
                    }
                    global2ThreadLocal.put(memObj, threadLocalCopy);
                }
                return global2ThreadLocal.getOrDefault(memObj, memObj);
            }
        };

        thread.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(transformer));
        // TODO: After creating all thread-local copies, we might want to delete the original variable?

        return thread;
    }

    private Register getResultRegister(DirectFunctionCall call) {
        assert call instanceof DirectValueFunctionCall;
        return ((DirectValueFunctionCall) call).getResultRegister();
    }

    private List<Event> newReleaseStore(Expression address, Expression storeValue) {
        final Event releaseStore = compiler.getTarget() == Arch.LKMM ?
                EventFactory.Linux.newLKMMStore(address, storeValue, Tag.Linux.MO_RELEASE) :
                EventFactory.Atomic.newStore(address, storeValue, Tag.C11.MO_RELEASE);
        return compiler.getCompilationResult(releaseStore);
    }

    private List<Event> newAcquireLoad(Register resultRegister, Expression address) {
        final Event acquireLoad = compiler.getTarget() == Arch.LKMM ?
                EventFactory.Linux.newLKMMLoad(resultRegister, address, Tag.Linux.MO_ACQUIRE) :
                EventFactory.Atomic.newLoad(resultRegister, address, Tag.C11.MO_ACQUIRE);
        return compiler.getCompilationResult(acquireLoad);
    }


}
