package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.core.threading.ThreadReturn;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadCreate;
import com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.program.processing.transformers.MemoryTransformer;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
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
import static com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin.Status.*;

/*
 * LLVM:
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

/*
 * SPIR-V:
 * This pass creates new threads from the entry function of the program.
 * The thread number is determined by the thread grid.
 */

@Options
public class ThreadCreation implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(ThreadCreation.class);

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed.",
            secure = true,
            toUppercase = true)
    private boolean forceStart = true;

    private final Compilation compiler;

    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final IntegerType archType = types.getArchType();

    private ThreadCreation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        compiler = Compilation.fromConfig(config);
    }

    public static ThreadCreation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ThreadCreation(config);
    }

    @Override
    public void run(Program program) {
        if (program.getFormat().equals(Program.SourceLanguage.LLVM)) {
            createLLVMThreads(program);
        } else if (program.getFormat().equals(Program.SourceLanguage.SPV)) {
            createSPVThreads(program);
        }
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    private void createLLVMThreads(Program program) {
        markInterruptCreations(program);
        final List<ThreadData> threadData = createThreads(program);
        resolvePthreadSelf(program);
        resolveDynamicThreadJoin(program, threadData);
        IdReassignment.newInstance().run(program);
        resolveTidExpressions(program);

        logger.info("Number of threads (including main): {}", program.getThreads().size());
    }

    private void markInterruptCreations(Program program) {
        for (Function func : program.getFunctions()) {
            boolean nextIsInterrupt = false;
            for (Event e : func.getEvents()) {
                if (e instanceof GenericVisibleEvent vis && vis.hasTag(Tag.INTERRUPT_HANDLER)) {
                    nextIsInterrupt = true;
                }

                if (e instanceof DynamicThreadCreate create && nextIsInterrupt) {
                    create.setThreadType(Thread.Type.INTERRUPT_HANDLER);
                    nextIsInterrupt = false;
                }
            }
        }
    }

    private List<ThreadData> createThreads(Program program) {
        final Optional<Function> main = program.getFunctionByName(program.getEntryPoint());
        if (main.isEmpty()) {
            throw new MalformedProgramException("Program contains no entry point function. Missing main method?");
        }

        // NOTE: We start from id = 0 which overlaps with existing function ids.
        // However, we reassign ids after thread creation so that functions get higher ids.
        int nextTid = 0;

        // We collect metadata about each spawned thread. This is later used to resolve thread joining.
        final List<ThreadData> allThreads = new ArrayList<>();
        final ThreadData entryPoint = createLLVMThreadFromFunction(main.get(), nextTid++, null, Thread.Type.STANDARD);
        allThreads.add(entryPoint);

        final Queue<ThreadData> workingQueue = new ArrayDeque<>(allThreads);
        while (!workingQueue.isEmpty()) {
            final Thread thread = workingQueue.remove().thread();
            for (DynamicThreadCreate create : thread.getEvents(DynamicThreadCreate.class)) {
                Verify.verify(create.isDirectCall());
                final Register tidRegister = create.getResultRegister();
                final Function targetFunction = create.getDirectCallTarget();
                final List<Expression> arguments = create.getArguments();

                final ThreadCreate createEvent = newThreadCreate(arguments);
                final ThreadData spawnedThread = createLLVMThreadFromFunction(targetFunction, nextTid, createEvent, create.getThreadType());
                assert spawnedThread.isDynamic();
                workingQueue.add(spawnedThread);
                allThreads.add(spawnedThread);

                final List<Event> replacement = eventSequence(
                        newReleaseStore(spawnedThread.comAddress(), expressions.makeTrue()),
                        createEvent,
                        newLocal(tidRegister, new TIdExpr(archType, spawnedThread.thread()))
                );
                IRHelper.replaceWithMetadata(create, replacement);

                nextTid++;
            }
        }
        return allThreads;
    }

    /*
        This method replaces in all DynamicThreadJoin events by a switch over all joinable threads.
        Each switch case contains a static ThreadJoin event.
    */
    private void resolveDynamicThreadJoin(Program program, List<ThreadData> threadData) {
        int joinCounter = 0;

        for (DynamicThreadJoin join : program.getThreadEvents(DynamicThreadJoin.class)) {
            final Thread caller = join.getThread();
            final Expression tidExpr = join.getTid();

            final Register joinRegister = join.getResultRegister();
            final IntegerType statusType = (IntegerType) ((AggregateType)joinRegister.getType()).getFields().get(0).type();
            final Type retValType = ((AggregateType)joinRegister.getType()).getFields().get(1).type();

            final Expression successValue = expressions.makeValue(SUCCESS.ordinal(), statusType);
            final Expression invalidTidValue = expressions.makeValue(INVALID_TID.ordinal(), statusType);
            final Expression invalidRetType = expressions.makeValue(INVALID_RETURN_TYPE.ordinal(), statusType);

            final Register statusRegister = caller.newRegister("__joinStatus#" + joinCounter, statusType);
            final Register retValRegister = caller.newRegister("__joinRetVal#" + joinCounter, retValType);
            final Register syncRegister = caller.newRegister("__joinSync#" + joinCounter, types.getBooleanType());

            // ----- Construct a switch case for each possible tid -----
            final Label joinEnd = EventFactory.newLabel("__joinEnd#" + joinCounter);
            final Map<Expression, List<Event>> tid2joinCases = new LinkedHashMap<>();
            for (ThreadData data : threadData) {
                if (!data.isJoinable() || data.thread() == caller) {
                    // NOTE: We treat self-joins as an invalid tid id error (~ in alignment with pthread_join semantics)
                    // We could alternatively make this a non-termination case
                    continue;
                }
                Verify.verify(retValRegister.getType().equals(data.thread.getFunctionType().getReturnType()));

                final int tid = data.thread().getId();
                if (tidExpr instanceof IntLiteral iConst && iConst.getValueAsInt() != tid) {
                    // Little optimization if we join with a constant address
                    continue;
                }

                final Label joinCase = EventFactory.newLabel("__joinWithT" + tid + "#" + joinCounter);
                final List<Event> caseBody;
                if (!data.thread().getFunctionType().getReturnType().equals(retValType)) {
                    // Wrong return type
                    caseBody = eventSequence(
                            joinCase,
                            newLocal(statusRegister, invalidRetType),
                            EventFactory.newGoto(joinEnd)
                    );
                } else {
                    // Successful join
                    caseBody = eventSequence(
                            joinCase,
                            newThreadJoin(retValRegister, data.thread()),
                            newAcquireLoad(syncRegister, data.comAddress),
                            newAssume(expressions.makeNot(syncRegister)),
                            newLocal(statusRegister, successValue),
                            EventFactory.newGoto(joinEnd)
                    );
                }
                tid2joinCases.put(new TIdExpr((IntegerType) tidExpr.getType(), data.thread()), caseBody);
            }

            // ----- Construct the actual switch (a simple jump table) -----
            final List<Event> switchJumpTable = new ArrayList<>();
            for (Expression tid : tid2joinCases.keySet()) {
                switchJumpTable.add(EventFactory.newJump(
                        expressions.makeEQ(tidExpr, tid), (Label)tid2joinCases.get(tid).get(0))
                );
            }
            // In the case where no tid matches, we return an error status.
            switchJumpTable.add(EventFactory.newLocal(statusRegister, invalidTidValue));
            switchJumpTable.add(EventFactory.newGoto(joinEnd));

            // ----- Generate actual replacement for the DynamicJoinEvent -----
            final List<Event> replacement = eventSequence(
                    switchJumpTable,
                    tid2joinCases.values(),
                    joinEnd,
                    newLocal(joinRegister, expressions.makeConstruct(joinRegister.getType(), List.of(statusRegister, retValRegister)))
            );
            IRHelper.replaceWithMetadata(join, replacement);
            joinCounter++;
        }
    }

    private void resolvePthreadSelf(Program program) {
        for (FunctionCall call : program.getThreadEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            if (call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.P_THREAD_SELF) {
                final Register resultRegister = getResultRegister(call);
                assert resultRegister.getType() instanceof IntegerType;
                assert call.getArguments().isEmpty();
                final Expression tidExpr = new TIdExpr((IntegerType) resultRegister.getType(), call.getThread());
                final Local tidAssignment = newLocal(resultRegister, tidExpr);
                IRHelper.replaceWithMetadata(call, tidAssignment);
            }
        }
    }

    private ThreadData createLLVMThreadFromFunction(Function function, int tid, ThreadCreate creator, Thread.Type type) {
        // ------------------- Create new thread -------------------
        final ThreadStart start = EventFactory.newThreadStart(creator);
        start.setMayFailSpuriously(!forceStart);
        final Thread thread = new Thread(function.getName(), function.getFunctionType(),
                Lists.transform(function.getParameterRegisters(), Register::getName), tid, start, type);
        thread.copyUniqueIdsFrom(function);
        function.getProgram().addThread(thread);

        // ------------------- Copy function into thread -------------------
        final Map<Register, Register> registerReplacement = IRHelper.copyOverRegisters(function.getRegisters(), thread,
                Register::getName, false);
        final List<Event> body = IRHelper.copyEvents(function.getEvents(), IRHelper.makeRegisterReplacer(registerReplacement), new HashMap<>());
        thread.getEntry().insertAfter(body);

        // ------------------- Create thread-local variables -------------------
        replaceGlobalsByThreadLocals(function.getProgram().getMemory(), thread);

        // ------------------- Add end & return label -------------------
        final Register returnRegister = function.hasReturnValue() ?
                thread.newRegister("__retval", function.getFunctionType().getReturnType()) : null;
        final Label threadReturnLabel = EventFactory.newLabel("RETURN_OF_T" + tid);
        final Label threadEnd = EventFactory.newLabel("END_OF_T" + tid);

        // ------------------- Replace AbortIf, (Thread)Return, and pthread_exit -------------------
        for (Event e : thread.getEvents()) {
            if (e instanceof AbortIf abort) {
                final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
                jumpToEnd.addTags(abort.getTags());
                IRHelper.replaceWithMetadata(abort, jumpToEnd);
            } else if (e instanceof Return || e instanceof ThreadReturn) {
                // NOTE: We also replace ThreadReturn but generate a single new one (normalization) afterward.
                final Expression retVal = (e instanceof Return ret) ? ret.getValue().orElse(null)
                        : ((ThreadReturn)e).getValue().orElse(null);
                final List<Event> replacement = eventSequence(
                        returnRegister != null ? EventFactory.newLocal(returnRegister, retVal) : null,
                        EventFactory.newGoto(threadReturnLabel)
                );
                IRHelper.replaceWithMetadata(e, replacement);
            }
        }

        final Event threadReturn = EventFactory.newThreadReturn(returnRegister);
        thread.append(List.of(
                threadReturnLabel,
                threadReturn,
                threadEnd
        ));

        // ------------------- Add Sync, End, and Argument events if this thread was spawned -------------------
        if (creator != null) {
            // Arguments
            final List<Register> params = thread.getParameterRegisters();
            for (int i = 0; i < params.size(); i++) {
                thread.getEntry().insertAfter(newThreadArgument(params.get(i), creator, i));
            }

            // We use accesses to a common memory object to synchronize creator and thread.
            final MemoryObject comAddress = function.getProgram().getMemory().allocate(1);
            comAddress.setName("__com_" + function.getName() + "#" + tid);
            comAddress.setInitialValue(0, expressions.makeFalse());

            // Sync
            final Register startSignal = thread.newRegister("__startT" + tid, types.getBooleanType());
            thread.getEntry().insertAfter(eventSequence(
                    newAcquireLoad(startSignal, comAddress),
                    newAssume(startSignal)
            ));

            // End
            threadReturnLabel.insertAfter(newReleaseStore(comAddress, expressions.makeFalse()));

            creator.setSpawnedThread(thread);
            return new ThreadData(thread, comAddress);
        }

        return new ThreadData(thread, null);
    }

    private void replaceGlobalsByThreadLocals(Memory memory, Thread thread) {
        final ExprTransformer transformer = new ExprTransformer() {
            final Map<Expression, Expression> global2ThreadLocal = new HashMap<>();
            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                if (memObj.isThreadLocal() && !global2ThreadLocal.containsKey(memObj)) {
                    Preconditions.checkState(memObj.hasKnownSize());
                    final MemoryObject threadLocalCopy = memory.allocate(memObj.getKnownSize());
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
    }

    private void resolveTidExpressions(Program program) {
        final ExprTransformer transformer = new ExprTransformer() {
            final ExpressionFactory expressions = ExpressionFactory.getInstance();
            @Override
            public Expression visitLeafExpression(LeafExpression expr) {
                if (expr instanceof TIdExpr tid) {
                    return expressions.makeValue(tid.thread.getId(), tid.getType());
                }
                return super.visitLeafExpression(expr);
            }
        };
        for (RegReader reader : program.getThreadEvents(RegReader.class)) {
            reader.transformExpressions(transformer);
        }
    }

    private Register getResultRegister(FunctionCall call) {
        assert call instanceof ValueFunctionCall;
        return ((ValueFunctionCall) call).getResultRegister();
    }

    private List<Event> newReleaseStore(Expression address, Expression storeValue) {
        final Event releaseStore = compiler.getTarget() == Arch.LKMM ?
                EventFactory.Linux.newLKMMStore(address, storeValue, Tag.Linux.MO_RELEASE) :
                EventFactory.Atomic.newStore(address, storeValue, Tag.C11.MO_RELEASE);
        List<Event> compilation = compiler.getCompilationResult(releaseStore);
        compilation.stream().filter(e -> e instanceof Store).forEach(e -> e.addTags(Tag.THREAD_CREATE));
        return compilation;
    }

    private List<Event> newAcquireLoad(Register resultRegister, Expression address) {
        final Event acquireLoad = compiler.getTarget() == Arch.LKMM ?
                EventFactory.Linux.newLKMMLoad(resultRegister, address, Tag.Linux.MO_ACQUIRE) :
                EventFactory.Atomic.newLoad(resultRegister, address, Tag.C11.MO_ACQUIRE);
        List<Event> compilation = compiler.getCompilationResult(acquireLoad);
        compilation.stream().filter(e -> e instanceof Load).forEach(e -> e.addTags(Tag.THREAD_START));
        return compilation;
    }


    // =============================================================================================
    // ========================================== SPIR-V ===========================================
    // =============================================================================================
    private void createSPVThreads(Program program) {
        ThreadGrid grid = program.getGrid();
        List<ExprTransformer> transformers = program.getTransformers();
        program.getFunctionByName(program.getEntryPoint()).ifPresent(entryFunction -> {
            for (int tid = 0; tid < grid.dvSize(); tid++) {
                final Thread thread = createSPVThreadFromFunction(entryFunction, tid, grid, transformers);
                program.addThread(thread);
            }
            // Remove unused memory objects of the entry function
            for (ExprTransformer transformer : transformers) {
                if (transformer instanceof MemoryTransformer memoryTransformer) {
                    Memory memory = entryFunction.getProgram().getMemory();
                    for (MemoryObject memoryObject : memoryTransformer.getThreadLocalMemoryObjects()) {
                        memory.deleteMemoryObject(memoryObject);
                    }
                }
            }
        });
    }

    private Thread createSPVThreadFromFunction(Function function, int tid, ThreadGrid grid, List<ExprTransformer> transformers) {
        String name = function.getName();
        FunctionType type = function.getFunctionType();
        List<String> args = Lists.transform(function.getParameterRegisters(), Register::getName);
        ThreadStart start = EventFactory.newThreadStart(null);
        ScopeHierarchy scope = grid.getScoreHierarchy(tid);
        Thread thread = new Thread(name, type, args, tid, start, scope, Set.of());
        thread.copyUniqueIdsFrom(function);
        Label returnLabel = EventFactory.newLabel("RETURN_OF_T" + thread.getId());
        Label endLabel = EventFactory.newLabel("END_OF_T" + thread.getId());
        copyThreadEvents(function, thread, transformers, endLabel);
        for (Return event : thread.getEvents(Return.class)) {
            event.replaceBy(EventFactory.newGoto(returnLabel));
        }
        thread.append(returnLabel);
        thread.append(endLabel);
        return thread;
    }

    private void copyThreadEvents(Function function, Thread thread, List<ExprTransformer> transformers, Label threadEnd) {
        List<Event> body = new ArrayList<>();
        Map<Event, Event> eventCopyMap = new HashMap<>();
        function.getEvents().forEach(e -> body.add(eventCopyMap.computeIfAbsent(e, Event::getCopy)));
        for (ExprTransformer transformer : transformers) {
            if (transformer instanceof MemoryTransformer memoryTransformer) {
                memoryTransformer.setThread(thread);
                for (int i = 0; i < body.size(); i++) {
                    Event copy = body.get(i);
                    if (copy instanceof EventUser user) {
                        user.updateReferences(eventCopyMap);
                    }
                    if (copy instanceof RegReader reader) {
                        reader.transformExpressions(transformer);
                    }
                    if (copy instanceof RegWriter regWriter) {
                        regWriter.setResultRegister(memoryTransformer.getRegisterMapping(regWriter.getResultRegister()));
                    }
                    if (copy instanceof AbortIf abort) {
                        final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
                        jumpToEnd.addTags(abort.getTags());
                        jumpToEnd.copyAllMetadataFrom(abort);
                        body.set(i, jumpToEnd);
                    }
                }
            }
        }
        thread.getEntry().insertAfter(body);
    }

    // ==============================================================================================================
    // Helper classes

    private record ThreadData(Thread thread, MemoryObject comAddress) {
        public boolean isDynamic() { return comAddress != null; }
        // We assume all dynamically created threads are joinable.
        // This is not true for pthread_join in general.
        public boolean isJoinable() { return isDynamic(); }
    }

    // We use this class to refer to thread ids before we have (re)assigned proper ids for all threads.
    // After assigning proper ids, we replace all occurrences of TidExpr with a constant tid.
    public static class TIdExpr extends LeafExpressionBase<IntegerType> {
        private final Thread thread;

        public TIdExpr(IntegerType type, Thread thread) {
            super(type);
            this.thread = thread;
        }

        @Override
        public ExpressionKind getKind() {
            return () -> "Tid";
        }

        @Override
        public String toString() {
            return String.format("tid(%s#%d)", thread.getName(), thread.getId());
        }

        @Override
        public <T> T accept(ExpressionVisitor<T> visitor) {
            return visitor.visitLeafExpression(this);
        }
    }


}
