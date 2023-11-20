package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableList;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Manages a collection of all functions that the verifier can define itself,
 * if the input program does not already provide a definition.
 * Also defines the semantics of most intrinsics,
 * except some thread-library primitives, which are instead defined in {@link ThreadCreation}.
 */
public class Intrinsics {

    private static final Logger logger = LogManager.getLogger(Intrinsics.class);

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    // TODO: This id should be part of Program
    private int constantId;

    private Intrinsics() {
    }

    public static Intrinsics newInstance() {
        return new Intrinsics();
    }

    public ProgramProcessor markIntrinsicsPass() {
        return this::markIntrinsics;
    }

    /*
        This pass runs early in the processing chain and resolves intrinsics whose semantics
        can be captured by a context-insensitive sequence of other events.

        TODO: We could insert the definitions here directly into the function declarations of the intrinsics.
     */
    public FunctionProcessor earlyInliningPass() {
        return this::inlineEarly;
    }

    /*
        This pass runs late in the processing chain, in particular after regular inlining, unrolling, SCCP, and thread creation.
        Thus, the following conditions should be met:
        - The intrinsics are live (reachable) and have constant input if possible.
        - All code duplications ran: The replacement of the intrinsic will not get copied again.
          This allows this pass to set up global state per replaced intrinsic without getting invalidated later.
     */
    public ProgramProcessor lateInliningPass() {
        return this::inlineLate;
    }

    // --------------------------------------------------------------------------------------------------------
    // Marking

    public enum Info {
        // --------------------------- pthread threading ---------------------------
        P_THREAD_CREATE("pthread_create", true, false, true, false, null),
        P_THREAD_EXIT("pthread_exit", false, false, false, false, null),
        P_THREAD_JOIN(List.of("pthread_join", "__pthread_join", "\"\\01_pthread_join\""), false, true, false, false, null),
        P_THREAD_BARRIER_WAIT("pthread_barrier_wait", false, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), false, false, true, false, null),
        // --------------------------- pthread condition variable ---------------------------
        P_THREAD_COND_INIT("pthread_cond_init", true, true, true, true, Intrinsics::inlinePthreadCondInit),
        P_THREAD_COND_DESTROY("pthread_cond_destroy", true, false, true, true, Intrinsics::inlinePthreadCondDestroy),
        P_THREAD_COND_SIGNAL("pthread_cond_signal", true, false, true, true, Intrinsics::inlinePthreadCondSignal),
        P_THREAD_COND_BROADCAST("pthread_cond_broadcast", true, false, true, true, Intrinsics::inlinePthreadCondBroadcast),
        P_THREAD_COND_WAIT("pthread_cond_wait", false, true, false, true, Intrinsics::inlinePthreadCondWait),
        P_THREAD_COND_TIMEDWAIT("pthread_cond_timedwait", false, false, true, true, Intrinsics::inlinePthreadCondTimedwait),
        P_THREAD_CONDATTR_INIT("pthread_condattr_init", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_CONDATTR_DESTROY("pthread_condattr_destroy", true, false, true, true, Intrinsics::inlineAsZero),
        // --------------------------- pthread key ---------------------------
        P_THREAD_KEY_CREATE("pthread_key_create", false, false, true, false, Intrinsics::inlinePthreadKeyCreate),
        P_THREAD_KEY_DELETE("pthread_key_delete", false, false, true, false, Intrinsics::inlinePthreadKeyDelete),
        P_THREAD_GET_SPECIFIC("pthread_getspecific", false, true, true, false, Intrinsics::inlinePthreadGetSpecific),
        P_THREAD_SET_SPECIFIC("pthread_setspecific", true, false, true, false, Intrinsics::inlinePthreadSetSpecific),
        // --------------------------- pthread mutex ---------------------------
        P_THREAD_MUTEX_INIT("pthread_mutex_init", true, false, true, true, Intrinsics::inlinePthreadMutexInit),
        P_THREAD_MUTEX_DESTROY("pthread_mutex_destroy", true, false, true, true, Intrinsics::inlinePthreadMutexDestroy),
        P_THREAD_MUTEX_LOCK("pthread_mutex_lock", true, true, false, true, Intrinsics::inlinePthreadMutexLock),
        P_THREAD_MUTEX_TRYLOCK("pthread_mutex_trylock", true, true, true, true, Intrinsics::inlinePthreadMutexTryLock),
        P_THREAD_MUTEX_UNLOCK("pthread_mutex_unlock", true, false, true, true, Intrinsics::inlinePthreadMutexUnlock),
        P_THREAD_MUTEXATTR_INIT("pthread_mutexattr_init", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_MUTEXATTR_DESTROY("pthread_mutexattr_destroy", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_MUTEXATTR_SET(List.of(
                "pthread_mutexattr_setprioceiling",
                "pthread_mutexattr_setprotocol",
                "pthread_mutexattr_settype",
                "pthread_mutexattr_setpolicy_np"),
                true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_MUTEXATTR_GET(List.of(
                "pthread_mutexattr_getprioceiling",
                "pthread_mutexattr_getprotocol",
                "pthread_mutexattr_gettype",
                "pthread_mutexattr_getpolicy_np"),
                false, true, true, true, Intrinsics::inlineAsZero),
        // --------------------------- pthread read/write lock ---------------------------
        P_THREAD_RWLOCK_INIT("pthread_rwlock_init", true, false, true, true, Intrinsics::inlinePthreadRwlockInit),
        P_THREAD_RWLOCK_DESTROY("pthread_rwlock_destroy", true, true, true, true, Intrinsics::inlinePthreadRwlockDestroy),
        P_THREAD_RWLOCK_WRLOCK("pthread_rwlock_wrlock", true, true, false, true, Intrinsics::inlinePthreadRwlockWrlock),
        P_THREAD_RWLOCK_TRYWRLOCK("pthread_rwlock_trywrlock", true, true, true, true, Intrinsics::inlinePthreadRwlockTryWrlock),
        P_THREAD_RWLOCK_RDLOCK("pthread_rwlock_rdlock", true, true, false, true, Intrinsics::inlinePthreadRwlockRdlock),
        P_THREAD_RWLOCK_TRYRDLOCK("pthread_rwlock_tryrdlock", true, true, true, true, Intrinsics::inlinePthreadRwlockTryRdlock),
        P_THREAD_RWLOCK_UNLOCK("pthread_rwlock_unlock", true, false, true, true, Intrinsics::inlinePthreadRwlockUnlock),
        P_THREAD_RWLOCKATTR_INIT("pthread_rwlockattr_init", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_RWLOCKATTR_DESTROY("pthread_rwlockattr_destroy", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_RWLOCKATTR_SET("pthread_rwlockattr_setpshared", true, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_RWLOCKATTR_GET("pthread_rwlockattr_getpshared", true, false, true, true, Intrinsics::inlineAsZero),
        // --------------------------- SVCOMP ---------------------------
        VERIFIER_ATOMIC_BEGIN("__VERIFIER_atomic_begin", false, false, true, true, Intrinsics::inlineAtomicBegin),
        VERIFIER_ATOMIC_END("__VERIFIER_atomic_end", false, false, true, true, Intrinsics::inlineAtomicEnd),
        // --------------------------- __VERIFIER ---------------------------
        VERIFIER_LOOP_BEGIN("__VERIFIER_loop_begin", false, false, true, true, Intrinsics::inlineLoopBegin),
        VERIFIER_LOOP_BOUND("__VERIFIER_loop_bound", false, false, true, true, Intrinsics::inlineLoopBound),
        VERIFIER_SPIN_START("__VERIFIER_spin_start", false, false, true, true, Intrinsics::inlineSpinStart),
        VERIFIER_SPIN_END("__VERIFIER_spin_end", false, false, true, true, Intrinsics::inlineSpinEnd),
        VERIFIER_ASSUME("__VERIFIER_assume", false, false, true, true, Intrinsics::inlineAssume),
        VERIFIER_ASSERT("__VERIFIER_assert", false, false, false, false, Intrinsics::inlineAssert),
        VERIFIER_NONDET(List.of("__VERIFIER_nondet_bool",
                "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar"),
                false, false, true, false, Intrinsics::inlineNonDet),
        // --------------------------- LLVM ---------------------------
        LLVM(List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin",
                "llvm.ssub.sat", "llvm.usub.sat", "llvm.sadd.sat", "llvm.uadd.sat", // TODO: saturated shifts
                "llvm.ctlz", "llvm.ctpop"),
                false, false, true, true, Intrinsics::handleLLVMIntrinsic),
        LLVM_ASSUME("llvm.assume", false, false, true, true, Intrinsics::inlineLLVMAssume),
        LLVM_META(List.of("llvm.stacksave", "llvm.stackrestore", "llvm.lifetime"), false, false, true, true, Intrinsics::inlineAsZero),
        LLVM_OBJECTSIZE("llvm.objectsize", false, false, true, false, null),
        LLVM_EXPECT("llvm.expect", false, false, true, true, Intrinsics::inlineLLVMExpect),
        LLVM_MEMCPY("llvm.memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        LLVM_MEMSET("llvm.memset", true, false, true, false, Intrinsics::inlineMemSet),
        // --------------------------- LKMM ---------------------------
        LKMM_LOAD("__LKMM_LOAD", false, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_STORE("__LKMM_STORE", true, false, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_XCHG("__LKMM_XCHG", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_CMPXCHG("__LKMM_CMPXCHG", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_FETCH_OP("__LKMM_ATOMIC_FETCH_OP", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_OP("__LKMM_ATOMIC_OP", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_OP_RETURN("__LKMM_ATOMIC_OP_RETURN", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_SPIN_LOCK("__LKMM_SPIN_LOCK", true, true, false, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_SPIN_UNLOCK("__LKMM_SPIN_UNLOCK", true, false, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_FENCE("__LKMM_FENCE", false, false, false, true, Intrinsics::handleLKMMIntrinsic),
        // --------------------------- Misc ---------------------------
        STD_MEMCPY("memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        STD_MEMSET(List.of("memset", "__memset_chk"), true, false, true, false, Intrinsics::inlineMemSet),
        STD_MEMCMP("memcmp", false, true, true, false, Intrinsics::inlineMemCmp),
        // STD_STRCPY("strcpy", true, true, true, true, (i, c) -> i.inlineStrcpy(c, false, false)),
        // STD_STPCPY("stpcpy", true, true, true, true, (i, c) -> i.inlineStrcpy(c, true, false)),
        // STD_STRNCPY("strncpy", true, true, true, true, (i, c) -> i.inlineStrcpy(c, false, true)),
        // STD_STPNCPY("stpncpy", true, true, true, true, (i, c) -> i.inlineStrcpy(c, true, true)),
        STD_MALLOC("malloc", false, false, true, true, Intrinsics::inlineMalloc),
        STD_CALLOC("calloc", false, false, true, true, Intrinsics::inlineCalloc),
        STD_FREE("free", true, false, true, true, Intrinsics::inlineAsZero),//TODO support free
        STD_ASSERT(List.of("__assert_fail", "__assert_rtn"), false, false, false, true, Intrinsics::inlineAssert),
        STD_EXIT("exit", false, false, false, true, Intrinsics::inlineExit),
        STD_ABORT("abort", false, false, false, true, Intrinsics::inlineExit),
        STD_IO(List.of("puts", "putchar", "printf"), false, false, true, true, Intrinsics::inlineAsZero),
        STD_SLEEP("sleep", false, false, true, true, Intrinsics::inlineAsZero),
        ;

        private final List<String> variants;
        private final boolean writesMemory;
        private final boolean readsMemory;
        private final boolean alwaysReturns;
        private final boolean isEarly;
        private final Replacer replacer;

        Info(List<String> variants, boolean writesMemory, boolean readsMemory, boolean alwaysReturns, boolean isEarly,
                Replacer replacer) {
            this.variants = variants;
            this.writesMemory = writesMemory;
            this.readsMemory = readsMemory;
            this.alwaysReturns = alwaysReturns;
            this.isEarly = isEarly;
            this.replacer = replacer;
        }

        Info(String name, boolean writesMemory, boolean readsMemory, boolean alwaysReturns, boolean isEarly,
                Replacer replacer) {
            this(List.of(name), writesMemory, readsMemory, alwaysReturns, isEarly, replacer);
        }

        public List<String> variants() {
            return variants;
        }

        public boolean writesMemory() {
            return writesMemory;
        }

        public boolean readsMemory() {
            return readsMemory;
        }

        public boolean alwaysReturns() {
            return alwaysReturns;
        }

        public boolean isEarly() {
            return isEarly;
        }

        private boolean matches(String funcName) {
            boolean isPrefix = switch(this) {
                case LLVM, LLVM_ASSUME, LLVM_META, LLVM_MEMCPY, LLVM_MEMSET, LLVM_EXPECT, LLVM_OBJECTSIZE -> true;
                default -> false;
            };
            BiPredicate<String, String> matchingFunction = isPrefix ? String::startsWith : String::equals;
            return variants.stream().anyMatch(v -> matchingFunction.test(funcName, v));
        }
    }

    @FunctionalInterface
    private interface Replacer {
        List<Event> replace(Intrinsics self, FunctionCall call);
    }

    private void markIntrinsics(Program program) {
        declareNondetBool(program);

        final var missingSymbols = new TreeSet<String>();
        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                Arrays.stream(Info.values())
                        .filter(info -> info.matches(funcName))
                        .findFirst()
                        .ifPresentOrElse(func::setIntrinsicInfo, () -> missingSymbols.add(funcName));
            }
        }
        if (!missingSymbols.isEmpty()) {
            throw new UnsupportedOperationException(
                    missingSymbols.stream().collect(Collectors.joining(", ", "Unknown intrinsics ", "")));
        }
    }

    private void declareNondetBool(Program program) {
        final TypeFactory types = TypeFactory.getInstance();
        // used by VisitorLKMM
        if (program.getFunctionByName("__VERIFIER_nondet_bool").isEmpty()) {
            final FunctionType type = types.getFunctionType(types.getBooleanType(), List.of());
            //TODO this id will not be unique
            program.addFunction(new Function("__VERIFIER_nondet_bool", type, List.of(), 0, null));
        }
    }

    private void replace(FunctionCall call, Replacer replacer) {
        if (replacer == null) {
            throw new MalformedProgramException(
                    String.format("Intrinsic \"%s\" without replacer", call.getCalledFunction().getName()));
        }
        final List<Event> replacement = replacer.replace(this, call);
        if (replacement.isEmpty()) {
            call.tryDelete();
        } else if (replacement.get(0) != call) {
            if (!call.getUsers().isEmpty() && call.getUsers().stream().allMatch(ExecutionStatus.class::isInstance)) {
                final Map<Event, Event> updateMapping = Map.of(call, replacement.get(0));
                ImmutableList.copyOf(call.getUsers()).forEach(user -> user.updateReferences(updateMapping));
            }
            call.replaceBy(replacement);
            replacement.forEach(e -> e.copyAllMetadataFrom(call));

            // NOTE: We deliberately do not use the call markers, because (1) we want to distinguish between
            // intrinsics and normal calls, and (2) we do not want to have intrinsics in the call stack.
            // We may want to change this behaviour though.
            replacement.get(0).getPredecessor().insertAfter(EventFactory.newStringAnnotation(
                    String.format("=== Calling intrinsic %s ===", call.getCalledFunction().getName())
            ));
            replacement.get(replacement.size() - 1).insertAfter(EventFactory.newStringAnnotation(
                    String.format("=== Returning from intrinsic %s ===", call.getCalledFunction().getName())
            ));
        }
    }

    // --------------------------------------------------------------------------------------------------------
    // Simple early intrinsics

    private void inlineEarly(Function function) {
        for (final FunctionCall call : function.getEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            final Intrinsics.Info info = call.getCalledFunction().getIntrinsicInfo();
            if (info != null && info.isEarly()) {
                replace(call, info.replacer);
            }
        }
    }

    private List<Event> inlineAsZero(FunctionCall call) {
        if (call instanceof ValueFunctionCall valueCall) {
            final Register reg = valueCall.getResultRegister();
            final Expression zero = expressions.makeGeneralZero(reg.getType());
            logger.debug("Replaced (unsupported) call to \"{}\" by zero.", call.getCalledFunction().getName());
            return List.of(EventFactory.newLocal(reg, zero));
        } else {
            return List.of();
        }
    }

    private List<Event> inlineExit(FunctionCall ignored) {
        return List.of(EventFactory.newAbortIf(ExpressionFactory.getInstance().makeTrue()));
    }

    private List<Event> inlineLoopBegin(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newLoopBegin());
    }

    private List<Event> inlineLoopBound(FunctionCall call) {
        final Expression boundExpression = call.getArguments().get(0);
        return List.of(EventFactory.Svcomp.newLoopBound(boundExpression));
    }

    private List<Event> inlineSpinStart(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newSpinStart());
    }

    private List<Event> inlineSpinEnd(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newSpinEnd());
    }

    private List<Event> inlineAssume(FunctionCall call) {
        final Expression assumption = call.getArguments().get(0);
        return List.of(EventFactory.newAssume(assumption));
    }

    private List<Event> inlineAtomicBegin(FunctionCall ignored) {
        return List.of(currentAtomicBegin = EventFactory.Svcomp.newBeginAtomic());
    }

    private List<Event> inlineAtomicEnd(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newEndAtomic(checkNotNull(currentAtomicBegin)));
    }

    private List<Event> inlinePthreadCondInit(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression address = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        final Expression initializedState = expressions.makeZero(types.getArchType());
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.newStore(address, initializedState));
    }

    private List<Event> inlinePthreadCondDestroy(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression address = call.getArguments().get(0);
        final Expression finalizedState = expressions.makeZero(types.getArchType());
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.newStore(address, finalizedState));
    }

    private List<Event> inlinePthreadCondSignal(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression address = call.getArguments().get(0);
        final Expression one = expressions.makeOne(types.getArchType());
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                // Relaxed, since this operation is to be guarded by a mutex.
                EventFactory.Atomic.newStore(address, one, Tag.C11.MO_RELAXED));
    }

    private List<Event> inlinePthreadCondBroadcast(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression address = call.getArguments().get(0);
        final var threadCount = new INonDet(constantId++, types.getArchType(), true);
        threadCount.setMin(BigInteger.ZERO);
        call.getFunction().getProgram().addConstant(threadCount);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                // Relaxed, since this operation is to be guarded by a mutex.
                EventFactory.Atomic.newStore(address, threadCount, Tag.C11.MO_RELAXED));
    }

    private List<Event> inlinePthreadCondWait(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression address = call.getArguments().get(0);
        final Expression lock = call.getArguments().get(1);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Expression zero = expressions.makeZero(types.getArchType());
        final Expression minusOne = expressions.makeValue(BigInteger.ONE.negate(), types.getArchType());
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                // Allow other threads to access the condition variable.
                EventFactory.Pthread.newUnlock(lock.toString(), lock),
                // Wait for signal or broadcast.
                EventFactory.Atomic.newFADD(dummy, address, minusOne, Tag.C11.MO_RELAXED),
                EventFactory.newAbortIf(expressions.makeGT(dummy, zero, true)),
                // Wait for all waiters to be notified of a broadcast.  If signal, wait for itself.
                // Subsequent waits cannot be notified by the same broadcast event.
                EventFactory.Atomic.newLoad(dummy, address, Tag.C11.MO_RELAXED),
                EventFactory.newAbortIf(expressions.makeEQ(dummy, zero)),
                // Re-lock.
                EventFactory.Pthread.newLock(lock.toString(), lock));
    }

    private List<Event> inlinePthreadCondTimedwait(FunctionCall call) {
        final Register result = checkValueAndArguments(3, call);
        final Expression address = call.getArguments().get(0);
        final Expression lock = call.getArguments().get(1);
        //final Expression timespec = call.getArguments().get(2);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Label label = EventFactory.newLabel("__VERIFIER_pthread_cond_timedwait_end");
        final var error = new INonDet(constantId++, (IntegerType) result.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final Expression zero = expressions.makeGeneralZero(result.getType());
        final Expression minusOne = expressions.makeValue(BigInteger.ONE.negate(), types.getArchType());
        return List.of(
                // Allow other threads to access the condition variable.
                EventFactory.Pthread.newUnlock(lock.toString(), lock),
                // Decide success
                //TODO proper error code: ETIMEDOUT
                EventFactory.newLocal(result, error),
                EventFactory.newJump(expressions.makeNEQ(error, zero), label),
                // Wait for signal or broadcast.
                EventFactory.Atomic.newFADD(dummy, address, minusOne, Tag.C11.MO_RELAXED),
                EventFactory.newAbortIf(expressions.makeGT(dummy, zero, true)),
                // Wait for all waiters to be notified of a broadcast.  If signal, wait for itself.
                // Subsequent waits cannot be notified by the same broadcast event.
                EventFactory.Atomic.newLoad(dummy, address, Tag.C11.MO_RELAXED),
                EventFactory.newAbortIf(expressions.makeEQ(dummy, zero)),
                // Join branches
                label,
                // Re-lock.
                EventFactory.Pthread.newLock(lock.toString(), lock));
    }

    private List<Event> inlinePthreadKeyCreate(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression key = call.getArguments().get(0);
        final Expression destructor = call.getArguments().get(1);
        final Program program = call.getFunction().getProgram();
        final int threadCount = program.getThreads().size();
        final int pointerBytes = types.getMemorySizeInBytes(types.getPointerType());
        final MemoryObject object = program.getMemory().allocate((threadCount + 1) * pointerBytes, false);
        final BigInteger destructorOffsetValue = BigInteger.valueOf((long) threadCount * pointerBytes);
        final Expression destructorOffset = expressions.makeValue(destructorOffsetValue, types.getArchType());
        //TODO call destructor at each thread's normal exit
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.newStore(key, object),
                EventFactory.newStore(expressions.makeADD(object, destructorOffset), destructor));
    }

    private List<Event> inlinePthreadKeyDelete(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        //final Expression key = call.getArguments().get(0);
        //final int threadID = call.getThread().getId();
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())));
    }

    private List<Event> inlinePthreadGetSpecific(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression key = call.getArguments().get(0);
        final int threadID = call.getThread().getId();
        final Expression offset = expressions.makeValue(BigInteger.valueOf(threadID), types.getArchType());
        return List.of(
                EventFactory.newLoad(result, expressions.makeADD(key, offset)));
    }

    private List<Event> inlinePthreadSetSpecific(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression key = call.getArguments().get(0);
        final Expression value = call.getArguments().get(1);
        final int threadID = call.getThread().getId();
        final Expression offset = expressions.makeValue(BigInteger.valueOf(threadID), types.getArchType());
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.newStore(expressions.makeADD(key, offset), value));
    }

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression attributes = call.getArguments().get(1);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.Pthread.newInitLock(lockName, lockAddress, attributes),
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())));
    }

    private List<Event> inlinePthreadMutexDestroy(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())));
    }

    private List<Event> inlinePthreadMutexLock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.Pthread.newLock(lockName, lockAddress),
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())));
    }

    private List<Event> inlinePthreadMutexTryLock(FunctionCall call) {
        final Register register = checkValueAndArguments(1, call);
        checkArgument(register.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final var error = new INonDet(constantId++, (IntegerType) register.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final Label label = EventFactory.newLabel("__VERIFIER_trylock_join");
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.newLocal(register, error),
                EventFactory.newJump(expressions.makeBooleanCast(error), label),
                EventFactory.Pthread.newLock(lockName, lockAddress),
                label);
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.Pthread.newUnlock(lockName, lockAddress));
    }

    private List<Event> inlinePthreadRwlockInit(FunctionCall call) {
        final Register result = checkValueAndArguments(2, call);
        final Expression lock = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.newStore(lock, expressions.makeZero(types.getArchType()))
        );
    }

    private List<Event> inlinePthreadRwlockDestroy(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        return List.of(EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())));
    }

    private List<Event> inlinePthreadRwlockWrlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression lock = call.getArguments().get(0);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Expression zero = expressions.makeZero(types.getArchType());
        final Expression one = expressions.makeOne(types.getArchType());
        final var replacement = new INonDet(constantId++, types.getArchType(), true);
        call.getFunction().getProgram().addConstant(replacement);
        final Expression locked = expressions.makeNEQ(dummy, zero);
        final Expression properReplacement = expressions.makeConditional(locked, dummy, one);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                // Try to lock
                EventFactory.Atomic.newExchange(dummy, lock, replacement, Tag.C11.MO_ACQUIRE),
                // Store one (write-locked) only if successful, else leave unchanged
                EventFactory.newAssume(expressions.makeEQ(replacement, properReplacement)),
                // Deadlock if violation occurs in another thread
                EventFactory.newAbortIf(locked));
    }

    private List<Event> inlinePthreadRwlockTryWrlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Expression lock = call.getArguments().get(0);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final var error = new INonDet(constantId++, (IntegerType) result.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final Expression zero = expressions.makeZero(types.getArchType());
        final Expression one = expressions.makeOne(types.getArchType());
        //TODO this implementation can fail spontaneously
        final Label label = EventFactory.newLabel("__VERIFIER_pthread_rwlock_trywrlock_end");
        return List.of(
                EventFactory.newLocal(result, error),
                // Decide whether this operation succeeds
                EventFactory.newJump(expressions.makeNEQ(error, expressions.makeGeneralZero(result.getType())), label),
                // Lock
                EventFactory.Atomic.newExchange(dummy, lock, one, Tag.C11.MO_ACQUIRE),
                // Guaranteed success in this branch
                EventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                // Join paths
                label);
    }

    private List<Event> inlinePthreadRwlockRdlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Expression lock = call.getArguments().get(0);
        final var increment = new INonDet(constantId++, types.getArchType(), true);
        call.getFunction().getProgram().addConstant(increment);
        final Expression zero = expressions.makeZero(types.getArchType());
        final Expression one = expressions.makeOne(types.getArchType());
        final Expression two = expressions.makeValue(BigInteger.TWO, types.getArchType());
        final Expression firstReader = expressions.makeEQ(dummy, zero);
        final Expression properIncrement = expressions.makeConditional(firstReader, two, one);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                // Increment shared counter only if not locked by writer.
                EventFactory.Atomic.newFADD(dummy, lock, increment, Tag.C11.MO_ACQUIRE),
                // Deadlock if a violation occurred in another thread.  In this case, lock value was not changed
                EventFactory.newAbortIf(expressions.makeEQ(increment, zero)),
                // On success, lock cannot have been write-locked.
                EventFactory.newAssume(expressions.makeNEQ(dummy, one)),
                // On success, incremented by two, if first reader, else one.
                EventFactory.newAssume(expressions.makeEQ(increment, properIncrement)));
    }

    private List<Event> inlinePthreadRwlockTryRdlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Expression lock = call.getArguments().get(0);
        final var error = new INonDet(constantId++, (IntegerType) result.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final var increment = new INonDet(constantId++, types.getArchType(), true);
        call.getFunction().getProgram().addConstant(increment);
        final Expression zero = expressions.makeZero(types.getArchType());
        final Expression one = expressions.makeOne(types.getArchType());
        final Expression two = expressions.makeValue(BigInteger.TWO, types.getArchType());
        final Expression writeLocked = expressions.makeEQ(dummy, one);
        final Expression firstReader = expressions.makeEQ(dummy, zero);
        final Expression properIncrement = expressions.makeConditional(writeLocked, zero,
                expressions.makeConditional(firstReader, two, one));
        final Expression success = expressions.makeGeneralZero(result.getType());
        return List.of(
                EventFactory.newLocal(result, error),
                // increment shared counter only if not locked by writer.
                EventFactory.Atomic.newFADD(dummy, lock, increment, Tag.C11.MO_ACQUIRE),
                EventFactory.newAssume(expressions.makeNEQ(writeLocked, expressions.makeEQ(error, success))),
                EventFactory.newAssume(expressions.makeEQ(increment, properIncrement)));
    }

    private List<Event> inlinePthreadRwlockUnlock(FunctionCall call) {
        final Register result = checkValueAndArguments(1, call);
        final Register dummy = call.getFunction().newRegister(types.getArchType());
        final Expression lock = call.getArguments().get(0);
        final var decrement = new INonDet(constantId++, types.getArchType(), true);
        call.getFunction().getProgram().addConstant(decrement);
        final Expression minusTwo = expressions.makeValue(BigInteger.valueOf(-2), types.getArchType());
        final Expression minusOne = expressions.makeValue(BigInteger.valueOf(-1), types.getArchType());
        final Expression two = expressions.makeValue(BigInteger.TWO, types.getArchType());
        final Expression lastReader = expressions.makeEQ(dummy, two);
        final Expression properDecrement = expressions.makeConditional(lastReader, minusTwo, minusOne);
        return List.of(
                EventFactory.newLocal(result, expressions.makeGeneralZero(result.getType())),
                EventFactory.Atomic.newFADD(dummy, lock, decrement, Tag.C11.MO_RELEASE),
                EventFactory.newAssume(expressions.makeEQ(decrement, properDecrement)));
    }

    private List<Event> inlineMalloc(FunctionCall call) {
        if (call.getArguments().size() != 1) {
            throw new UnsupportedOperationException(String.format("Unsupported signature for %s.", call));
        }
        final ValueFunctionCall valueCall = (ValueFunctionCall) call;
        return List.of(EventFactory.newAlloc(
                valueCall.getResultRegister(),
                TypeFactory.getInstance().getByteType(),
                valueCall.getArguments().get(0),
                true
        ));
    }

    private List<Event> inlineCalloc(FunctionCall call) {
        checkArgument(call.getArguments().size() == 2, "Unsupported signature for %s", call);
        checkArgument(call instanceof ValueFunctionCall, "No support for discarded result of %s", call);
        final ValueFunctionCall valueCall = (ValueFunctionCall) call;
        return List.of(EventFactory.newAlloc(
                valueCall.getResultRegister(),
                TypeFactory.getInstance().getByteType(),
                expressions.makeMUL(valueCall.getArguments().get(0), valueCall.getArguments().get(1)),
                true
        ));
    }

    private List<Event> inlineAssert(FunctionCall call) {
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        final Expression condition = expressions.makeFalse();
        final Event assertion = EventFactory.newAssert(condition, "user assertion");
        final Event abort = EventFactory.newAbortIf(expressions.makeTrue());
        abort.addTags(Tag.EARLYTERMINATION);
        return List.of(assertion, abort);
    }

    // --------------------------------------------------------------------------------------------------------
    // LLVM intrinsics

    private List<Event> handleLLVMIntrinsic(FunctionCall call) {
        assert call instanceof ValueFunctionCall && call.isDirectCall();
        final ValueFunctionCall valueCall = (ValueFunctionCall) call;
        final String name = call.getCalledFunction().getName();

        if (name.startsWith("llvm.ctlz")) {
            return inlineLLVMCtlz(valueCall);
        } else if (name.startsWith("llvm.ctpop")) {
            return inlineLLVMCtpop(valueCall);
        } else if (name.contains("add.sat")) {
            return inlineLLVMSaturatedAdd(valueCall);
        } else if (name.contains("sub.sat")) {
            return inlineLLVMSaturatedSub(valueCall);
        } else if (name.startsWith("llvm.smax") || name.startsWith("llvm.smin")
                || name.startsWith("llvm.umax") || name.startsWith("llvm.umin")) {
            return inlineLLVMMinMax(valueCall);
        } else {
            final String error = String.format(
                    "Call %s to LLVM intrinsic %s cannot be handled.", call, call.getCalledFunction());
            throw new UnsupportedOperationException(error);
        }
    }

    private List<Event> inlineLLVMExpect(FunctionCall call) {
        assert call instanceof ValueFunctionCall;
        final Register retReg = ((ValueFunctionCall) call).getResultRegister();
        final Expression value = call.getArguments().get(0);
        return List.of(EventFactory.newLocal(retReg, value));
    }

    private List<Event> inlineLLVMAssume(FunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-assume-intrinsic
        return List.of(EventFactory.newAssume(call.getArguments().get(0)));
    }

    private List<Event> inlineLLVMCtlz(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-ctlz-intrinsic
        checkArgument(call.getArguments().size() == 2,
                "Expected 2 parameters for \"llvm.ctlz\", got %s.", call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final Type type = resultReg.getType();
        checkArgument(resultReg.getType() instanceof IntegerType,
                "Non-integer %s type for \"llvm.ctlz\".", type);
        checkArgument(input.getType().equals(type),
                "Return type %s of \"llvm.ctlz\" must match argument type %s.", type, input.getType());
        final Expression resultExpression = expressions.makeCTLZ(input, (IntegerType) type);
        final Event assignment = EventFactory.newLocal(resultReg, resultExpression);
        return List.of(assignment);
    }

    private List<Event> inlineLLVMCtpop(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-ctpop-intrinsic
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final IntegerType type = (IntegerType) resultReg.getType();
        final Expression increment = expressions.makeADD(resultReg, expressions.makeOne(type));

        final List<Event> replacement = new ArrayList<>();
        replacement.add(EventFactory.newLocal(resultReg, expressions.makeZero(type)));
        //TODO: There might be more efficient ways to count bits set, though it is not clear
        // if they are also more friendly for the SMT backend.
        for (int i = type.getBitWidth() - 1; i >= 0; i--) {
            final Expression testMask = expressions.makeValue(BigInteger.ONE.shiftLeft(i), type);
            //TODO: dedicated test-bit expressions might yield better results, and they are supported by the SMT backend
            // in the form of extract operations.
            final Expression testBit = expressions.makeEQ(expressions.makeAND(input, testMask), testMask);

            replacement.add(
                    EventFactory.newLocal(resultReg, expressions.makeConditional(testBit, increment, resultReg))
            );
        }

        return replacement;
    }

    private List<Event> inlineLLVMMinMax(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
        final List<Expression> arguments = call.getArguments();
        final Expression left = arguments.get(0);
        final Expression right = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean signed = name.startsWith("llvm.smax.") || name.startsWith("llvm.smin.");
        final boolean isMax = name.startsWith("llvm.smax.") || name.startsWith("llvm.umax.");
        final Expression isLess = expressions.makeLT(left, right, signed);
        final Expression result = expressions.makeConditional(isLess, isMax ? right : left, isMax ? left : right);
        return List.of(EventFactory.newLocal(call.getResultRegister(), result));
    }

    private List<Event> inlineLLVMSaturatedSub(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#saturation-arithmetic-intrinsics
        /*
            signedSatSub(x, y):
                ret = (x < 0) ? MIN : MAX;
                if ((x < 0) == (y < (x-ret))
                    ret = x - y;
                return ret;

            unsignedSatSub(x, y)
                return x > y ? x - y : 0;
         */
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean isSigned = name.startsWith("llvm.s");
        final IntegerType type = (IntegerType) x.getType();

        assert x.getType() == y.getType();

        if (isSigned) {
            final Expression min = expressions.makeValue(type.getMinimumValue(true), type);
            final Expression max = expressions.makeValue(type.getMaximumValue(true), type);

            final Expression leftIsNegative = expressions.makeLT(x, expressions.makeZero(type), true);
            final Expression noOverflow = expressions.makeEQ(
                    leftIsNegative,
                    expressions.makeLT(y, expressions.makeSUB(x, resultReg), true)
            );

            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeConditional(leftIsNegative, min, max)),
                    EventFactory.newLocal(resultReg, expressions.makeConditional(noOverflow, expressions.makeSUB(x, y), resultReg))
            );
        } else {
            final Expression noUnderflow = expressions.makeGT(x, y, false);
            final Expression zero = expressions.makeZero(type);
            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeConditional(noUnderflow, expressions.makeSUB(x, y), zero))
            );
        }
    }

    private List<Event> inlineLLVMSaturatedAdd(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#saturation-arithmetic-intrinsics
        /*
            (un)signedSatAdd(x, y):
                ret = (x < 0) ? MIN : MAX; // MIN/MAX depends on signedness
                if ((x < 0) == (y > (ret-x))
                    ret = x + y;
                return ret;
         */
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean isSigned = name.startsWith("llvm.s");
        final IntegerType type = (IntegerType) x.getType();

        assert x.getType() == y.getType();

        final Expression min = expressions.makeValue(type.getMinimumValue(isSigned), type);
        final Expression max = expressions.makeValue(type.getMaximumValue(isSigned), type);

        final Expression leftIsNegative = isSigned ?
                expressions.makeLT(x, expressions.makeZero(type), true) :
                expressions.makeFalse();
        final Expression noOverflow = expressions.makeEQ(
                leftIsNegative,
                expressions.makeGT(y, expressions.makeSUB(resultReg, x), isSigned)
        );

        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeConditional(leftIsNegative, min, max)),
                EventFactory.newLocal(resultReg, expressions.makeConditional(noOverflow, expressions.makeADD(x, y), resultReg))
        );
    }

    // --------------------------------------------------------------------------------------------------------
    // LKMM intrinsics

    private List<Event> handleLKMMIntrinsic(FunctionCall call) {
        final Register reg = (call instanceof ValueFunctionCall valueCall) ? valueCall.getResultRegister() : null;
        final List<Expression> args = call.getArguments();

        final Expression p0 = args.get(0);
        final Expression p1 = args.size() > 1 ? args.get(1) : null;
        final Expression p2 = args.size() > 2 ? args.get(2) : null;
        final Expression p3 = args.size() > 3 ? args.get(3) : null;

        final String mo;
        final IOpBin op;
        final List<Event> result = new ArrayList<>();
        switch (call.getCalledFunction().getName()) {
            case "__LKMM_LOAD" -> {
                checkArgument(p1 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p1).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMLoad(reg, p0, mo));
            }
            case "__LKMM_STORE" -> {
                checkArgument(p2 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMStore(p0, p1, mo.equals(Tag.Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo));
                if (mo.equals(Tag.Linux.MO_MB)) {
                    result.add(EventFactory.Linux.newMemoryBarrier());
                }
            }
            case "__LKMM_XCHG" -> {
                checkArgument(p2 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWExchange(p0, reg, p1, mo));
            }
            case "__LKMM_CMPXCHG" -> {
                checkArgument(p3 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWCompareExchange(p0, reg, p1, p2, mo));
            }
            case "__LKMM_ATOMIC_FETCH_OP" -> {
                checkArgument(p2 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                checkArgument(p3 instanceof IConst, "No support for variable operator.");
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWFetchOp(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP_RETURN" -> {
                checkArgument(p2 instanceof IConst, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                checkArgument(p3 instanceof IConst, "No support for variable operator.");
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOpReturn(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP" -> {
                checkArgument(p2 instanceof IConst, "No support for variable operator.");
                op = IOpBin.intToOp(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOp(p0, p1, op));
            }
            case "__LKMM_FENCE" -> {
                String fence = Tag.Linux.intToMo(((IConst) p0).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMFence(fence));
            }
            case "__LKMM_SPIN_LOCK" -> {
                result.add(EventFactory.Linux.newLock(p0));
            }
            case "__LKMM_SPIN_UNLOCK" -> {
                result.add(EventFactory.Linux.newUnlock(p0));
            }
            default -> {
                assert false;
            }
        }
        return result;
    }

    // --------------------------------------------------------------------------------------------------------
    // Simple late intrinsics

    private void inlineLate(Program program) {
        constantId = 0;
        program.getThreads().forEach(this::inlineLate);
    }

    private void inlineLate(Function function) {
        for (final FunctionCall call : function.getEvents(FunctionCall.class)) {
            if (!call.isDirectCall()) {
                continue;
            }
            final Intrinsics.Info info = call.getCalledFunction().getIntrinsicInfo();
            if (info != null && !info.isEarly()) {
                replace(call, info.replacer);
            } else {
                final String error = String.format("Undefined function %s", call.getCalledFunction().getName());
                throw new UnsupportedOperationException(error);
            }
        }
    }

    private List<Event> inlineNonDet(FunctionCall call) {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        assert call.isDirectCall() && call instanceof ValueFunctionCall;
        Register register = ((ValueFunctionCall) call).getResultRegister();
        String name = call.getCalledFunction().getName();
        final String separator = "nondet_";
        int index = name.indexOf(separator);
        assert index > -1;
        String suffix = name.substring(index + separator.length());

        // Nondeterministic booleans
        if (suffix.equals("bool")) {
            BooleanType booleanType = types.getBooleanType();
            var nondeterministicExpression = new BNonDet(booleanType);
            Expression cast = expressions.makeCast(nondeterministicExpression, register.getType());
            return List.of(EventFactory.newLocal(register, cast));
        }

        // Nondeterministic integers
        boolean signed = switch (suffix) {
            case "int", "short", "long", "char" -> true;
            default -> false;
        };
        final BigInteger min = switch (suffix) {
            case "long" -> BigInteger.valueOf(Long.MIN_VALUE);
            case "int" -> BigInteger.valueOf(Integer.MIN_VALUE);
            case "short" -> BigInteger.valueOf(Short.MIN_VALUE);
            case "char" -> BigInteger.valueOf(Byte.MIN_VALUE);
            default -> BigInteger.ZERO;
        };
        final BigInteger max = switch (suffix) {
            case "int" -> BigInteger.valueOf(Integer.MAX_VALUE);
            case "uint", "unsigned_int" -> UnsignedInteger.MAX_VALUE.bigIntegerValue();
            case "short" -> BigInteger.valueOf(Short.MAX_VALUE);
            case "ushort", "unsigned_short" -> BigInteger.valueOf(65535);
            case "long" -> BigInteger.valueOf(Long.MAX_VALUE);
            case "ulong" -> UnsignedLong.MAX_VALUE.bigIntegerValue();
            case "char" -> BigInteger.valueOf(Byte.MAX_VALUE);
            case "uchar" -> BigInteger.valueOf(255);
            default -> throw new UnsupportedOperationException(String.format("%s is not supported", call));
        };
        if (!(register.getType() instanceof IntegerType type)) {
            throw new MalformedProgramException(String.format("Non-integer result register %s.", register));
        }
        var expression = new INonDet(constantId++, type, signed);
        expression.setMin(min);
        expression.setMax(max);
        call.getFunction().getProgram().addConstant(expression);
        return List.of(EventFactory.newLocal(register, expression));
    }

    //FIXME: The following support for memcpy, memcmp, and memset is unsound
    // For proper support, we need at least alias information and most likely also proper support for mixed-sized accesses

    // Handles both std.memcpy and llvm.memcpy
    private List<Event> inlineMemCpy(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression dest = call.getArguments().get(0);
        final Expression src = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memcpy has an extra argument

        if (!(countExpr instanceof IValue countValue)) {
            final String error = "Cannot handle memcpy with dynamic count argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = countValue.getValueAsInt();

        final List<Event> replacement = new ArrayList<>(2 * count + 1);
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(BigInteger.valueOf(i), types.getArchType());
            final Expression srcAddr = expressions.makeADD(src, offset);
            final Expression destAddr = expressions.makeADD(dest, offset);
            // FIXME: We have no other choice but to load ptr-sized chunks for now
            final Register reg = caller.getOrNewRegister("__memcpy_" + i, types.getArchType());

            replacement.addAll(List.of(
                    EventFactory.newLoad(reg, srcAddr),
                    EventFactory.newStore(destAddr, reg)
            ));
        }
        if (call instanceof ValueFunctionCall valueCall) {
            // std.memcpy returns the destination address, llvm.memcpy has no return value
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    private List<Event> inlineMemCmp(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression src1 = call.getArguments().get(0);
        final Expression src2 = call.getArguments().get(1);
        final Expression numExpr = call.getArguments().get(2);
        final Register returnReg = ((ValueFunctionCall)call).getResultRegister();

        if (!(numExpr instanceof IValue numValue)) {
            final String error = "Cannot handle memcmp with dynamic num argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = numValue.getValueAsInt();

        final List<Event> replacement = new ArrayList<>(4 * count + 1);
        final Label endCmp = EventFactory.newLabel("__memcmp_end");
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(BigInteger.valueOf(i), types.getArchType());
            final Expression src1Addr = expressions.makeADD(src1, offset);
            final Expression src2Addr = expressions.makeADD(src2, offset);
            //FIXME: This method should properly load byte chunks and compare them (unsigned).
            // This requires proper mixed-size support though
            final Register regSrc1 = caller.getOrNewRegister("__memcmp_src1_" + i, returnReg.getType());
            final Register regSrc2 = caller.getOrNewRegister("__memcmp_src2_" + i, returnReg.getType());

            replacement.addAll(List.of(
                    EventFactory.newLoad(regSrc1, src1Addr),
                    EventFactory.newLoad(regSrc2, src2Addr),
                    EventFactory.newLocal(returnReg, expressions.makeSUB(src1, src2)),
                    EventFactory.newJump(expressions.makeNEQ(src1, src2), endCmp)
            ));
        }
        replacement.add(endCmp);

        return replacement;
    }

    // Handles, std.memset, llvm.memset and __memset_chk (checked memset)
    private List<Event> inlineMemSet(FunctionCall call) {
        final Expression dest = call.getArguments().get(0);
        final Expression fillExpr = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memset has an extra argument
        // final Expression boundExpr = call.getArguments.get(3) // __memset_chk has an extra argument

        //FIXME: Handle memset_chk correctly. For now, we ignore the bound check parameter because that one is
        // usually provided by llvm.objectsize which we cannot resolve for now. Since we usually assume UB-freedom,
        // the check can be ignored for the most part.
        if (call.getCalledFunction().getName().equals("__memset_chk")) {
            logger.warn("Treating call to \"__memset_chk\" as call to \"memset\": skipping bound checks.");
        }

        if (!(countExpr instanceof IValue countValue)) {
            final String error = "Cannot handle memset with dynamic count argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        if (!(fillExpr instanceof IValue fillValue && fillValue.isZero())) {
            //FIXME: We can soundly handle only 0 (and possibly -1) because the concatenation of
            // byte-sized 0's results in 0's of larger types. This makes the value robust against mixed-sized accesses.
            final String error = "Cannot handle memset with non-zero fill argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = countValue.getValueAsInt();
        final int fill = fillValue.getValueAsInt();
        assert fill == 0;

        final Expression zero = expressions.makeValue(BigInteger.valueOf(fill), types.getByteType());
        final List<Event> replacement = new ArrayList<>( count + 1);
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(BigInteger.valueOf(i), types.getArchType());
            final Expression destAddr = expressions.makeADD(dest, offset);

            replacement.add(EventFactory.newStore(destAddr, zero));
        }
        if (call instanceof ValueFunctionCall valueCall) {
            // std.memset returns the destination address, llvm.memset has no return value
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    private List<Event> inlineStrcpy(FunctionCall call, boolean returnEnd, boolean numberProvided) {
        final Register result = checkValueAndArguments(numberProvided ? 3 : 2, call);
        final Register offset = call.getFunction().newRegister(types.getArchType());
        final Register dummy = call.getFunction().newRegister(types.getByteType());
        final Expression destination = call.getArguments().get(0);
        final Expression source = call.getArguments().get(1);
        final Expression number = numberProvided ? call.getArguments().get(2) : null;
        final Expression numberCheck = numberProvided ? expressions.makeEQ(offset, number) : expressions.makeFalse();
        // This implementation is a simple byte-by-byte copy loop.
        final Label loop = EventFactory.newLabel("__VERIFIER_strcpy_loop");
        final Label end = EventFactory.newLabel("__VERIFIER_strcpy_end");
        return List.of(
                EventFactory.newLocal(offset, expressions.makeZero(types.getArchType())),
                loop,
                // If bound is reached, break
                EventFactory.newJump(numberCheck, end),
                // Copy one byte
                EventFactory.newLoad(dummy, expressions.makeADD(source, offset)),
                EventFactory.newStore(expressions.makeADD(destination, offset), dummy),
                // Break on '\0'
                EventFactory.newJump(expressions.makeEQ(dummy, expressions.makeZero(types.getByteType())), end),
                // Increase offset
                EventFactory.newLocal(offset, expressions.makeADD(offset, expressions.makeOne(types.getArchType()))),
                // Continue
                EventFactory.newGoto(loop),
                end,
                EventFactory.newLocal(result, returnEnd ? expressions.makeADD(destination, offset) : destination));
    }

    private Register checkValueAndArguments(int expectedArgumentCount, FunctionCall call) {
        checkArgument(call.getArguments().size() == expectedArgumentCount && call instanceof ValueFunctionCall,
                "Wrong function type at %s", call);
        return ((ValueFunctionCall) call).getResultRegister();
    }
}
