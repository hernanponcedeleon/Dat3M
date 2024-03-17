package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
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

import java.util.*;

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

        final Optional<Function> main = program.getFunctionByName("main");
        if (main.isEmpty()) {
            throw new MalformedProgramException("Program contains no main function");
        }

        // NOTE: We start from id = 0 which overlaps with existing function ids.
        // However, we reassign ids after thread creation so that functions get higher ids.
        // TODO: Do we even need ids for functions?
        int nextTid = 0;

        final Queue<Thread> workingQueue = new ArrayDeque<>();
        workingQueue.add(createThreadFromFunction(main.get(), nextTid++, null, null));

        while (!workingQueue.isEmpty()) {
            final Thread thread = workingQueue.remove();
            program.addThread(thread);

            // We collect the communication addresses we use for each thread id.
            // These are used later to lower pthread_join.
            final Map<IntLiteral, Expression> tid2ComAddrMap = new LinkedHashMap<>();
            for (FunctionCall call : thread.getEvents(FunctionCall.class)) {
                if (!call.isDirectCall()) {
                    continue;
                }
                final List<Expression> arguments = call.getArguments();
                switch (call.getCalledFunction().getIntrinsicInfo()) {
                    case P_THREAD_CREATE -> {
                        assert arguments.size() == 4;
                        final Expression pidResultAddress = arguments.get(0);
                        //final Expression attributes = arguments.get(1);
                        final Function targetFunction = (Function)arguments.get(2);
                        final Expression argument = arguments.get(3);

                        final Register resultRegister = getResultRegister(call);
                        assert resultRegister.getType() instanceof IntegerType;

                        final ThreadCreate createEvent = newThreadCreate(List.of(argument));
                        final IntLiteral tidExpr = expressions.makeValue(nextTid, archType);
                        final MemoryObject comAddress = program.getMemory().allocate(1);
                        comAddress.setName("__com" + nextTid + "__" + targetFunction.getName());
                        comAddress.setInitialValue(0, expressions.makeZero(archType));

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

                        nextTid++;
                    }
                    case P_THREAD_SELF -> {
                        final Register resultRegister = getResultRegister(call);
                        assert resultRegister.getType() instanceof IntegerType;
                        assert arguments.isEmpty();
                        final Expression tidExpr = expressions.makeValue(thread.getId(),
                                (IntegerType) resultRegister.getType());
                        final Local tidAssignment = newLocal(resultRegister, tidExpr);
                        tidAssignment.copyAllMetadataFrom(call);
                        call.replaceBy(tidAssignment);
                    }
                }
            }

            // FIXME: This only allows joining with child threads that were created by this thread.
            handlePthreadJoins(thread, tid2ComAddrMap);
        }

        IdReassignment.newInstance().run(program);
        logger.info("Number of threads (including main): " + program.getThreads().size());
    }

    /*
        This method replaces in <thread> all pthread_join calls by a switch over all possible tids.
        Each candidate thread gets a switch-case which tries to synchronize with that thread.
     */
    private void handlePthreadJoins(Thread thread, Map<IntLiteral, Expression> tid2ComAddrMap) {
        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        int joinCounter = 0;

        for (FunctionCall call : thread.getEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            if (call.getCalledFunction().getIntrinsicInfo() != Intrinsics.Info.P_THREAD_JOIN) {
                continue;
            }

            final List<Expression> arguments = call.getArguments();
            assert arguments.size() == 2;
            final Expression tidExpr = arguments.get(0);
            // TODO: support return values for threads
            // final Expression returnAddr = arguments.get(1);

            final Register resultRegister = getResultRegister(call);
            assert resultRegister.getType() instanceof IntegerType;

            // This register will hold the value "false" IFF the join succeeds.
            final Register joinDummyReg = thread.getOrNewRegister("__joinFail#" + joinCounter, types.getBooleanType());
            final Label joinEnd = EventFactory.newLabel("__joinEnd#" + joinCounter);

            // ----- Construct a switch case for each possible tid -----
            final Map<Expression, List<Event>> tid2joinCases = new LinkedHashMap<>();
            for (IntLiteral tidCandidate : tid2ComAddrMap.keySet()) {
                final int tid = tidCandidate.getValueAsInt();
                final Expression comAddrOfThreadToJoinWith = tid2ComAddrMap.get(tidCandidate);

                if (tidExpr instanceof IntLiteral iConst && iConst.getValueAsInt() != tid) {
                    // Little optimization if we join with a constant address
                    continue;
                }

                final Label joinCase = EventFactory.newLabel("__joinWithT" + tid + "#" + joinCounter);
                final List<Event> caseBody = eventSequence(
                        joinCase,
                        newAcquireLoad(joinDummyReg, comAddrOfThreadToJoinWith),
                        EventFactory.newGoto(joinEnd)
                );
                tid2joinCases.put(tidCandidate, caseBody);
            }

            // ----- Construct the actual switch (a simple jump table) -----
            final List<Event> switchJumpTable = new ArrayList<>();
            for (Expression tid : tid2joinCases.keySet()) {
                switchJumpTable.add(EventFactory.newJump(
                        expressions.makeEQ(tidExpr, tid), (Label)tid2joinCases.get(tid).get(0))
                );
            }
            // Add default case for when no tid matches. We make the join just fail here as if it
            // was waiting for a never-terminating thread.
            // FIXME: This does not align with the correct pthread_join semantics.
            switchJumpTable.add(EventFactory.newLocal(joinDummyReg, expressions.makeTrue()));
            switchJumpTable.add(EventFactory.newGoto(joinEnd));

            // ----- Generate actual replacement for the pthread_join call -----
            final List<Event> replacement = new ArrayList<>();
            replacement.add(EventFactory.newFunctionCallMarker(call.getCalledFunction().getName()));
            replacement.addAll(switchJumpTable);
            tid2joinCases.values().forEach(replacement::addAll);
            replacement.addAll(Arrays.asList(
                    joinEnd,
                    newJump(joinDummyReg, (Label)thread.getExit()),
                    // Note: In our modelling, pthread_join always succeeds if it returns
                    newLocal(resultRegister, expressions.makeZero((IntegerType) resultRegister.getType())),
                    EventFactory.newFunctionReturnMarker(call.getCalledFunction().getName())
            ));

            replacement.forEach(e -> e.copyAllMetadataFrom(call));
            call.replaceBy(replacement);

            joinCounter++;
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
            public Expression visitRegister(Register reg) {
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

        // ------------------- Replace AbortIf, Return, and pthread_exit -------------------
        final Register returnRegister = function.hasReturnValue() ?
                thread.newRegister("__retval", function.getFunctionType().getReturnType()) : null;
        for (Event e : thread.getEvents()) {
            if (e instanceof AbortIf abort) {
                final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
                jumpToEnd.addTags(abort.getTags());
                jumpToEnd.copyAllMetadataFrom(abort);
                abort.replaceBy(jumpToEnd);
            } else if (e instanceof Return || (e instanceof FunctionCall call
                    && call.isDirectCall() && call.getCalledFunction().getName().equals("pthread_exit"))) {
                final Expression retVal = (e instanceof Return ret) ? ret.getValue().orElse(null)
                        : ((FunctionCall)e).getArguments().get(0);
                final List<Event> replacement = eventSequence(
                        returnRegister != null ? EventFactory.newLocal(returnRegister, retVal) : null,
                        EventFactory.newGoto(threadReturnLabel)
                );
                replacement.forEach(ev -> ev.copyAllMetadataFrom(e));
                e.replaceBy(replacement);
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
            public Expression visitMemoryObject(MemoryObject memObj) {
                if (memObj.isThreadLocal() && !global2ThreadLocal.containsKey(memObj)) {
                    final MemoryObject threadLocalCopy = memory.allocate(memObj.size());
                    assert memObj.hasName();
                    final String varName = String.format("%s@T%s", memObj.getName(), thread.getId());
                    threadLocalCopy.setName(varName);
                    for (int field : memObj.getInitializedFields()) {
                        threadLocalCopy.setInitialValue(field, memObj.getInitialValue(field));
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

    private Register getResultRegister(FunctionCall call) {
        assert call instanceof ValueFunctionCall;
        return ((ValueFunctionCall) call).getResultRegister();
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
