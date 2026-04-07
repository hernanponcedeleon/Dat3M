package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.configuration.OptionNames.REMOVE_ASSERTION_OF_TYPE;
import static com.dat3m.dartagnan.configuration.OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin.Status.INVALID_TID;
import static com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin.Status.SUCCESS;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Manages a collection of all functions that the verifier can define itself,
 * if the input program does not already provide a definition.
 * Also defines the semantics of most intrinsics,
 * except some thread-library primitives, which are instead defined in {@link ThreadCreation}.
 * TODO due to name mangling schemes, some library calls we treat as intrinsics may have
 */
@Options
public class Intrinsics {

    private static final Logger logger = LoggerFactory.getLogger(Intrinsics.class);

    @Option(name = REMOVE_ASSERTION_OF_TYPE,
            description = "Remove assertions of type [user, overflow, invalidderef, unknown_function].",
            toUppercase=true,
            secure = true)
    private EnumSet<AssertionType> notToInline = EnumSet.noneOf(AssertionType.class);

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed (default true).",
            secure = true,
            toUppercase = true)
    private boolean pthreadCreateAlwaysSucceeds = true;

    private enum AssertionType { USER, OVERFLOW, INVALIDDEREF, UNKNOWN_FUNCTION }

    private final boolean detectMixedSizeAccesses;

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    private Intrinsics(boolean msa) {
        detectMixedSizeAccesses = msa;
    }

    public static Intrinsics newInstance() {
        return new Intrinsics(false);
    }
    
    public static Intrinsics fromConfig(Configuration config, boolean detectMixedSizeAccesses)
            throws InvalidConfigurationException {
        Intrinsics instance = new Intrinsics(detectMixedSizeAccesses);
        config.inject(instance);
        return instance;
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
        P_THREAD_CREATE("pthread_create", true, false, true, true, Intrinsics::inlinePthreadCreate),
        P_THREAD_EXIT("pthread_exit", false, false, true, true, Intrinsics::inlinePthreadExit),
        P_THREAD_JOIN(List.of("pthread_join", "_pthread_join", "__pthread_join"), true, true, false, true, Intrinsics::inlinePthreadJoin),
        P_THREAD_DETACH("pthread_detach", true, true, true, true, Intrinsics::inlinePthreadDetach),
        P_THREAD_BARRIER_WAIT("pthread_barrier_wait", false, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), false, false, true, false, Intrinsics::inlinePthreadSelf),
        P_THREAD_EQUAL("pthread_equal", false, false, true, false, Intrinsics::inlinePthreadEqual),
        P_THREAD_ATTR_INIT("pthread_attr_init", true, true, true, true, Intrinsics::inlinePthreadAttr),
        P_THREAD_ATTR_DESTROY("pthread_attr_destroy", true, true, true, true, Intrinsics::inlinePthreadAttr),
        P_THREAD_ATTR_GET(P_THREAD_ATTR.stream().map(a -> "pthread_attr_get" + a).toList(),
                true, true, true, true, Intrinsics::inlinePthreadAttr),
        P_THREAD_ATTR_SET(P_THREAD_ATTR.stream().map(a -> "pthread_attr_set" + a).toList(),
                true, true, true, true, Intrinsics::inlinePthreadAttr),
        // --------------------------- pthread condition variable ---------------------------
        P_THREAD_COND_INIT(List.of("pthread_cond_init", "_pthread_cond_init"),
                true, true, true, true, Intrinsics::inlinePthreadCondInit),
        P_THREAD_COND_DESTROY("pthread_cond_destroy", true, false, true, true, Intrinsics::inlinePthreadCondDestroy),
        P_THREAD_COND_SIGNAL("pthread_cond_signal", true, false, true, true, Intrinsics::inlinePthreadCondSignal),
        P_THREAD_COND_BROADCAST("pthread_cond_broadcast", true, false, true, true, Intrinsics::inlinePthreadCondBroadcast),
        P_THREAD_COND_WAIT(List.of("pthread_cond_wait", "_pthread_cond_wait"),
                false, true, false, true, Intrinsics::inlinePthreadCondWait),
        P_THREAD_COND_TIMEDWAIT(List.of("pthread_cond_timedwait", "_pthread_cond_timedwait"),
                false, false, true, true, Intrinsics::inlinePthreadCondTimedwait),
        P_THREAD_CONDATTR_INIT("pthread_condattr_init", true, true, true, true, Intrinsics::inlinePthreadCondAttr),
        P_THREAD_CONDATTR_DESTROY("pthread_condattr_destroy", true, true, true, true, Intrinsics::inlinePthreadCondAttr),
        // --------------------------- pthread key ---------------------------
        P_THREAD_KEY_CREATE("pthread_key_create", false, false, true, true, Intrinsics::inlinePthreadKeyCreate),
        P_THREAD_KEY_DELETE("pthread_key_delete", false, false, true, true, Intrinsics::inlinePthreadKeyDelete),
        P_THREAD_GET_SPECIFIC("pthread_getspecific", false, true, true, true, Intrinsics::inlinePthreadGetSpecific),
        P_THREAD_SET_SPECIFIC("pthread_setspecific", true, false, true, true, Intrinsics::inlinePthreadSetSpecific),
        // --------------------------- pthread mutex ---------------------------
        P_THREAD_MUTEX_INIT("pthread_mutex_init", true, true, true, true, Intrinsics::inlinePthreadMutexInit),
        P_THREAD_MUTEX_DESTROY("pthread_mutex_destroy", true, true, true, true, Intrinsics::inlinePthreadMutexDestroy),
        P_THREAD_MUTEX_LOCK("pthread_mutex_lock", true, true, false, true, Intrinsics::inlinePthreadMutexLock),
        P_THREAD_MUTEX_TRYLOCK("pthread_mutex_trylock", true, true, true, true, Intrinsics::inlinePthreadMutexTryLock),
        P_THREAD_MUTEX_UNLOCK("pthread_mutex_unlock", true, true, true, true, Intrinsics::inlinePthreadMutexUnlock),
        P_THREAD_MUTEXATTR_INIT("pthread_mutexattr_init", true, true, true, true, Intrinsics::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_DESTROY(List.of("pthread_mutexattr_destroy", "_pthread_mutexattr_destroy"),
                true, true, true, true, Intrinsics::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_SET(P_THREAD_MUTEXATTR.stream().map(a -> "pthread_mutexattr_get" + a).toList(),
                true, true, true, true, Intrinsics::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_GET(P_THREAD_MUTEXATTR.stream().map(a -> "pthread_mutexattr_set" + a).toList(),
                true, true, true, true, Intrinsics::inlinePthreadMutexAttr),
        // --------------------------- pthread read/write lock ---------------------------
        P_THREAD_RWLOCK_INIT(List.of("pthread_rwlock_init", "_pthread_rwlock_init"),
                true, false, true, true, Intrinsics::inlinePthreadRwlockInit),
        P_THREAD_RWLOCK_DESTROY(List.of("pthread_rwlock_destroy", "_pthread_rwlock_destroy"),
                true, true, true, true, Intrinsics::inlinePthreadRwlockDestroy),
        P_THREAD_RWLOCK_WRLOCK(List.of("pthread_rwlock_wrlock", "_pthread_rwlock_wrlock"),
                true, true, false, true, Intrinsics::inlinePthreadRwlockWrlock),
        P_THREAD_RWLOCK_TRYWRLOCK(List.of("pthread_rwlock_trywrlock", "_pthread_rwlock_trywrlock"),
                true, true, true, true, Intrinsics::inlinePthreadRwlockTryWrlock),
        P_THREAD_RWLOCK_RDLOCK(List.of("pthread_rwlock_rdlock", "_pthread_rwlock_rdlock"),
                true, true, false, true, Intrinsics::inlinePthreadRwlockRdlock),
        P_THREAD_RWLOCK_TRYRDLOCK(List.of("pthread_rwlock_tryrdlock", "_pthread_rwlock_tryrdlock"),
                true, true, true, true, Intrinsics::inlinePthreadRwlockTryRdlock),
        P_THREAD_RWLOCK_UNLOCK(List.of("pthread_rwlock_unlock", "_pthread_rwlock_unlock"),
                true, false, true, true, Intrinsics::inlinePthreadRwlockUnlock),
        P_THREAD_RWLOCKATTR_INIT("pthread_rwlockattr_init", true, false, true, true, Intrinsics::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_DESTROY("pthread_rwlockattr_destroy", true, false, true, true, Intrinsics::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_SET("pthread_rwlockattr_setpshared", true, false, true, true, Intrinsics::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_GET("pthread_rwlockattr_getpshared", true, false, true, true, Intrinsics::inlinePthreadRwlockAttr),
        // --------------------------- SVCOMP ---------------------------
        VERIFIER_ATOMIC_BEGIN("__VERIFIER_atomic_begin", false, false, true, true, Intrinsics::inlineAtomicBegin),
        VERIFIER_ATOMIC_END("__VERIFIER_atomic_end", false, false, true, true, Intrinsics::inlineAtomicEnd),
        // --------------------------- __VERIFIER ---------------------------
        VERIFIER_LOOP_BEGIN("__VERIFIER_loop_begin", false, false, true, true, Intrinsics::inlineAsZero),
        VERIFIER_SPIN_START("__VERIFIER_spin_start", false, false, true, true, Intrinsics::inlineAsZero),
        VERIFIER_SPIN_END("__VERIFIER_spin_end", false, false, true, true, Intrinsics::inlineAsZero),
        VERIFIER_LOOP_BOUND("__VERIFIER_loop_bound", false, false, true, true, Intrinsics::inlineLoopBound),
        VERIFIER_ASSUME("__VERIFIER_assume", false, false, true, true, Intrinsics::inlineAssume),
        VERIFIER_ASSERT("__VERIFIER_assert", false, false, true, true, Intrinsics::inlineUserAssert),
        VERIFIER_NONDET(List.of("__VERIFIER_nondet_bool",
                "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                "__VERIFIER_nondet_longlong", "__VERIFIER_nondet_ulonglong",
                "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar",
                "__VERIFIER_nondet_float", "__VERIFIER_nondet_double"),
                false, false, true, true, Intrinsics::inlineNonDet),
        // --------------------------- LLVM ---------------------------
        LLVM(List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin", "llvm.fmax", "llvm.fmin","llvm.maxnum.", "llvm.minnum.",
                "llvm.ssub.sat", "llvm.usub.sat", "llvm.sadd.sat", "llvm.uadd.sat", // TODO: saturated shifts
                "llvm.sadd.with.overflow", "llvm.ssub.with.overflow", "llvm.smul.with.overflow",
                "llvm.ctlz", "llvm.cttz", "llvm.ctpop",
                "llvm.fabs"),
                false, false, true, true, Intrinsics::handleLLVMIntrinsic),
        LLVM_ASSUME("llvm.assume", false, false, true, true, Intrinsics::inlineLLVMAssume),
        LLVM_META(List.of("llvm.stacksave", "llvm.stackrestore", "llvm.lifetime"), false, false, true, true, Intrinsics::inlineAsZero),
        LLVM_OBJECTSIZE("llvm.objectsize", false, false, true, false, null),
        LLVM_EXPECT("llvm.expect", false, false, true, true, Intrinsics::inlineLLVMExpect),
        LLVM_MEMCPY("llvm.memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        LLVM_MEMSET("llvm.memset", true, false, true, false, Intrinsics::inlineMemSet),
        LLVM_THREADLOCAL("llvm.threadlocal.address.p0", false, false, true, true, Intrinsics::inlineLLVMThreadLocal),
        // --------------------------- LKMM ---------------------------
        LKMM_LOAD("__LKMM_load", false, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_STORE("__LKMM_store", true, false, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_XCHG("__LKMM_xchg", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_CMPXCHG("__LKMM_cmpxchg", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_FETCH_OP("__LKMM_atomic_fetch_op", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_OP("__LKMM_atomic_op", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_ATOMIC_OP_RETURN("__LKMM_atomic_op_return", true, true, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_SPIN_LOCK("__LKMM_SPIN_LOCK", true, true, false, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_SPIN_UNLOCK("__LKMM_SPIN_UNLOCK", true, false, true, true, Intrinsics::handleLKMMIntrinsic),
        LKMM_FENCE("__LKMM_fence", false, false, false, true, Intrinsics::handleLKMMIntrinsic),
        // --------------------------- Misc ---------------------------
        STD_MEMCPY("memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        STD_MEMCPYS("memcpy_s", true, true, true, false, Intrinsics::inlineMemCpyS),
        STD_MEMSET(List.of("memset", "__memset_chk"), true, false, true, false, Intrinsics::inlineMemSet),
        STD_MEMCMP("memcmp", false, true, true, false, Intrinsics::inlineMemCmp),
        STD_MALLOC("malloc", false, false, true, true, Intrinsics::inlineMalloc),
        STD_CALLOC("calloc", false, false, true, true, Intrinsics::inlineCalloc),
        STD_ALIGNED_ALLOC("aligned_alloc", false, false, true, true, Intrinsics::inlineAlignedAlloc),
        STD_FREE("free", true, false, true, true, Intrinsics::inlineFree),
        STD_ASSERT(List.of("__assert_fail", "__assert_rtn"), false, false, false, true, Intrinsics::inlineUserAssert),
        STD_EXIT("exit", false, false, false, true, Intrinsics::inlineExit),
        STD_ABORT("abort", false, false, false, true, Intrinsics::inlineExit),
        STD_IO(List.of("puts", "putchar", "printf", "fflush"), false, false, true, true, Intrinsics::inlineAsZero),
        STD_IO_NONDET(List.of("fprintf"), false, false, true, true, Intrinsics::inlineCallAsNonDet),
        STD_SLEEP("sleep", false, false, true, true, Intrinsics::inlineAsZero),
        STD_FFS(List.of("ffs", "ffsl", "ffsll"), false, false, true, true, Intrinsics::inlineFfs),
        // --------------------------- UBSAN ---------------------------
        UBSAN_OVERFLOW(List.of("__ubsan_handle_add_overflow", "__ubsan_handle_sub_overflow", 
                "__ubsan_handle_divrem_overflow", "__ubsan_handle_mul_overflow", "__ubsan_handle_negate_overflow", "__ubsan_handle_shift_out_of_bounds"),
                false, false, false, true, Intrinsics::inlineIntegerOverflow),
        UBSAN_TYPE_MISSMATCH(List.of("__ubsan_handle_type_mismatch_v1"), 
                false, false, false, true, Intrinsics::inlineInvalidDereference),
        // ------------------------- Unknown function ---------------------------
        MISSING(List.of(), false, false, false, true, Intrinsics::inlineUnknownFunction),
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
        final var missingSymbols = new TreeSet<String>();
        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                Arrays.stream(Info.values())
                        .filter(info -> info.matches(funcName))
                        .findFirst()
                        .ifPresentOrElse(func::setIntrinsicInfo, () -> {
                            missingSymbols.add(funcName);
                            func.setIntrinsicInfo(Info.MISSING);});
            }
        }
        if (!missingSymbols.isEmpty()) {
            logger.warn("{}. Detecting calls to unknown functions requires --property=program_spec.",
                    missingSymbols.stream().collect(Collectors.joining(", ", "Unknown intrinsics ", "")));
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
            // NOTE: We deliberately do not use the call markers, because (1) we want to distinguish between
            // intrinsics and normal calls, and (2) we do not want to have intrinsics in the call stack.
            // We may want to change this behaviour though.
            call.insertBefore(EventFactory.newStringAnnotation(
                    String.format("=== Calling intrinsic %s ===", call.getCalledFunction().getName())
            ));
            call.insertAfter(EventFactory.newStringAnnotation(
                    String.format("=== Returning from intrinsic %s ===", call.getCalledFunction().getName())
            ));
            IRHelper.replaceWithMetadata(call, replacement);
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
        final Event exit = EventFactory.newAbortIf(expressions.makeTrue());
        exit.addTags(Tag.EXCEPTIONAL_TERMINATION);
        return List.of(exit);
    }

    private List<Event> inlineLoopBound(FunctionCall call) {
        final Expression boundExpression = call.getArguments().get(0);
        return List.of(EventFactory.newLoopBound(boundExpression));
    }

    private List<Event> inlineAssume(FunctionCall call) {
        final Expression assumption = call.getArguments().get(0);
        return List.of(EventFactory.newAssume(expressions.makeBooleanCast(assumption)));
    }

    private List<Event> inlineAtomicBegin(FunctionCall ignored) {
        return List.of(currentAtomicBegin = EventFactory.Svcomp.newBeginAtomic());
    }

    private List<Event> inlineAtomicEnd(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newEndAtomic(checkNotNull(currentAtomicBegin)));
    }

    private final static FunctionType PTHREAD_THREAD_TYPE = types.getFunctionType(
            types.getPointerType(), List.of(types.getPointerType())
    );

    private List<Event> inlinePthreadCreate(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 4;
        final Expression pidResultAddress = arguments.get(0);
        final Expression attributes = arguments.get(1);
        final Expression targetFunction = arguments.get(2);
        final Expression argument = arguments.get(3);

        final Register attributesRegister = call.getFunction().newUniqueRegister("__pthread_create_attr", getPthreadAttrType());
        final Register resultRegister = getResultRegister(call);
        assert resultRegister.getType() instanceof IntegerType;

        final Register tidReg = call.getFunction().newUniqueRegister("__tid", types.getArchType());
        final Event createEvent = newDynamicThreadCreate(tidReg, PTHREAD_THREAD_TYPE, targetFunction, List.of(argument));
        final Label skipAttrLabel = newLabel("__pthread_create_skip_attr");
        final Label skipDetachLabel = newLabel("__pthread_create_skip_detach");

        final Register failureRegister = call.getFunction().getOrNewRegister("__pthread_create_fail", types.getBooleanType());
        final Event decideFailure = pthreadCreateAlwaysSucceeds
                ? EventFactory.newLocal(failureRegister, expressions.makeFalse())
                : EventFactory.newNonDetChoice(failureRegister);
        final Label pthreadFailCase = newLabel("__pthread_create_fail");
        final CondJump checkIfFail = newJump(failureRegister, pthreadFailCase);
        final Label endOfPthreadCreate = newLabel("__pthread_create_end");

        return eventSequence(
                decideFailure,
                checkIfFail,
                // ----- SUCCESS -----
                createEvent,
                newJump(expressions.makeEQ(attributes, expressions.makeGeneralZero(attributes.getType())), skipAttrLabel),
                newLoad(attributesRegister, attributes),
                // If 'detach' attribute, detach the spawned thread immediately.
                // No need to check the status here, as detaching should always succeed.
                // resultRegister is reused here and will be overwritten later.
                newJumpUnless(testPthreadCreateDetached(attributesRegister), skipDetachLabel),
                newDynamicThreadDetach(resultRegister, tidReg),
                skipDetachLabel,
                // Finally, return the thread ID and the status.
                skipAttrLabel,
                newStore(pidResultAddress, tidReg),
                // TODO: Allow to return failure value (!= 0)
                newLocal(resultRegister, expressions.makeGeneralZero(resultRegister.getType())),
                newGoto(endOfPthreadCreate),
                // ----- FAIL -----
                pthreadFailCase,
                newLocal(resultRegister, expressions.makeValue(PosixErrorCode.EAGAIN.getValue(),
                        (IntegerType) resultRegister.getType())),
                endOfPthreadCreate
        );
    }

    private List<Event> inlinePthreadJoin(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 2;
        final Expression tidExpr = arguments.get(0);
        final Expression returnAddr = arguments.get(1);
        final boolean hasReturnAddr = !(returnAddr instanceof IntLiteral lit && lit.isZero());

        final Register statusRegister = getResultRegister(call);
        final IntegerType statusType = (IntegerType) statusRegister.getType();

        final Type joinType = types.getAggregateType(List.of(types.getIntegerType(8), PTHREAD_THREAD_TYPE.getReturnType()));
        final Register joinReg = call.getFunction().newUniqueRegister("__joinReg", joinType);

        final Expression status = expressions.makeExtract(joinReg, 0);
        final Expression retVal = expressions.makeExtract(joinReg, 1);

        final Expression statusSuccess = expressions.makeValue(SUCCESS.getErrorCode(), (IntegerType) status.getType());
        final Expression statusInvalidTId = expressions.makeValue(INVALID_TID.getErrorCode(), (IntegerType) status.getType());

        final Label joinEnd = hasReturnAddr ? newLabel("__pthread_join_end") : null;
        final Store storeRetVal = hasReturnAddr ? newStore(returnAddr, retVal) : null;
        final CondJump jump = hasReturnAddr ? newJump(expressions.makeNEQ(status, statusSuccess), joinEnd) : null;

        return eventSequence(
                newDynamicThreadJoin(joinReg, tidExpr),
                // TODO: We use our internal error codes which do not match with pthread's error codes,
                //  except for the success case (error code == 0).
                newLocal(statusRegister, expressions.makeCast(status, statusType)),
                jump,
                storeRetVal,
                joinEnd,
                newAssert(expressions.makeNEQ(status, statusInvalidTId), "Invalid thread id in pthread_join.")
        );
    }

    private List<Event> inlinePthreadDetach(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 1;
        final Expression tidExpr = arguments.get(0);

        final Register statusRegister = getResultRegister(call);
        final IntegerType statusType = (IntegerType) statusRegister.getType();

        final Expression statusInvalidTId = expressions.makeValue(INVALID_TID.getErrorCode(), statusType);

        return eventSequence(
                newDynamicThreadDetach(statusRegister, tidExpr),
                newAssert(expressions.makeNEQ(statusRegister, statusInvalidTId), "Invalid thread id in pthread_detach.")
        );
    }

    private List<Event> inlinePthreadExit(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 1 && arguments.get(0).getType().equals(PTHREAD_THREAD_TYPE.getReturnType());

        return List.of(newThreadReturn(arguments.get(0)));
    }

    private List<Event> inlinePthreadSelf(FunctionCall call) {
        // This intrinsics is mainly defined by ThreadCreation.
        assert call.getArguments().isEmpty();
        final Register resultRegister = getResultRegister(call);
        final Expression tidExpr = call.getThread().getRegister(ThreadCreation.THREAD_SELF_REGISTER_NAME);
        assert tidExpr != null : "Non-POSIX thread %s".formatted(call.getThread());
        return List.of(newLocal(resultRegister, expressions.makeCast(tidExpr, resultRegister.getType())));
    }

    private List<Event> inlinePthreadEqual(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression leftId = call.getArguments().get(0);
        final Expression rightId = call.getArguments().get(1);
        final Expression equation = expressions.makeEQ(leftId, rightId);
        return List.of(
                EventFactory.newLocal(resultRegister, expressions.makeCast(equation, resultRegister.getType()))
        );
    }

    private static final List<String> P_THREAD_ATTR = List.of(
            "stack", // no field itself, but describes simultaneous getters and setters for stackaddr and stacksize
            "stackaddr",
            "stacksize",
            "guardsize",
            "detachstate", // either PTHREAD_CREATE_DETACHED, or defaults to PTHREAD_CREATE_JOINABLE
            "inheritsched", // either PTHREAD_EXPLICIT_SCHED, or defaults to PTHREAD_INHERIT_SCHED
            "schedparam", // struct sched_param
            "schedpolicy", // either SCHED_FIFO, SCHED_RR, or SCHED_OTHER
            "scope" // either PTHREAD_SCOPE_SYSTEM, or PTHREAD_SCOPE_PROCESS
    );

    private List<Event> inlinePthreadAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_attr_".length());
        final int expectedArguments = switch (suffix) {
            case "init", "destroy" -> 1;
            case "getstack", "setstack" -> 3;
            default -> 2;
        };
        final Register errorRegister = getResultRegisterAndCheckArguments(expectedArguments, call);
        final IntegerType errorType = (IntegerType) errorRegister.getType();
        final Expression attrAddress = call.getArguments().get(0);
        final Expression value = expectedArguments < 2 ? null : call.getArguments().get(1);
        final boolean initial = suffix.equals("init");
        if (initial || suffix.equals("destroy")) {
            final Expression flag = expressions.makeValue(initial ? 1 : 0, getPthreadAttrType());
            return List.of(
                    newStore(attrAddress, flag),
                    assignSuccess(errorRegister)
            );
        }
        final boolean getter = suffix.startsWith("get");
        checkArgument((getter || suffix.startsWith("set")) && P_THREAD_ATTR.contains(suffix.substring(3)),
                "Unrecognized intrinsics \"%s\"", call);
        final Register oldValue = call.getFunction().newRegister(getPthreadAttrType());
        final Label end = EventFactory.newLabel("__pthread_return");
        final PthreadAttrImplementation impl = switch (suffix.substring(3)) {
            case "detachstate" -> inlinePthreadAttrDetachState(oldValue, getter ? null : value, end);
            default -> null;
        };
        final Expression zero = expressions.makeZero(types.getIntegerType(1));
        final Expression extractInitialized = expressions.makeIntExtract(oldValue, 0, 0);
        return eventSequence(
                assignPosixError(errorRegister, PosixErrorCode.EINVAL),
                newLoad(oldValue, attrAddress),
                newJump(expressions.makeEQ(extractInitialized, zero), end),
                impl == null ? null : impl.errorChecks,
                impl == null ? null : newStore(getter ? value : attrAddress, impl.out),
                assignSuccess(errorRegister),
                end
        );
    }

    private IntegerType getPthreadAttrType() {
        return types.getIntegerType(2);
    }

    private record PthreadAttrImplementation(Expression out, List<Event> errorChecks) {}

    private PthreadAttrImplementation inlinePthreadAttrDetachState(Expression oldValue, Expression detachstate,
            Label returnEINVAL) {
        // POSIX defines these two named constants of type int.
        // see https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/pthread.h.html
        //TODO values may vary by platform
        final long PTHREAD_CREATE_DETACHED = 1;
        final long PTHREAD_CREATE_JOINABLE = 0;
        final int flagIndex = 1;
        final IntegerType attrType = (IntegerType) oldValue.getType();
        final IntegerType valueType = getNativeIntType();
        final Expression createDetached = expressions.makeValue(PTHREAD_CREATE_DETACHED, valueType);
        final Expression createJoinable = expressions.makeValue(PTHREAD_CREATE_JOINABLE, valueType);
        final List<Event> errorChecks = new ArrayList<>();
        final Expression newValue;
        if (detachstate == null) {
            final Expression zero = expressions.makeZero(types.getIntegerType(1));
            final Expression extractValue = expressions.makeIntExtract(oldValue, flagIndex, flagIndex);
            final Expression testValue = expressions.makeNEQ(extractValue, zero);
            newValue = expressions.makeITE(testValue, createDetached, createJoinable);
        } else {
            final long invertedMaskValue = (1L << attrType.getBitWidth()) - (1 << flagIndex) - 1;
            final Expression mask = expressions.makeValue(1 << flagIndex, attrType);
            final Expression invertedMask = expressions.makeValue(invertedMaskValue, attrType);
            final Expression setFlag = expressions.makeIntOr(oldValue, mask);
            final Expression resetFlag = expressions.makeIntAnd(oldValue, invertedMask);
            final Expression doDetach = expressions.makeEQ(detachstate, createDetached);
            final Expression doNotDetach = expressions.makeEQ(detachstate, createJoinable);
            final Expression validValue = expressions.makeOr(doDetach, doNotDetach);
            errorChecks.add(EventFactory.newJumpUnless(validValue, returnEINVAL));
            newValue = expressions.makeITE(doDetach, setFlag, resetFlag);
        }
        return new PthreadAttrImplementation(newValue, errorChecks);
    }

    private Expression testPthreadCreateDetached(Expression attr) {
        final int flagIndex = 1;
        final Expression zero = expressions.makeZero(types.getIntegerType(1));
        final Expression extractDetach = expressions.makeIntExtract(attr, flagIndex, flagIndex);
        return expressions.makeNEQ(extractDetach, zero);
    }

    private List<Event> inlinePthreadCondInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression condAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        final Expression initializedState = expressions.makeTrue();
        return List.of(
                newStore(condAddress, initializedState),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression condAddress = call.getArguments().get(0);
        final Expression finalizedState = expressions.makeFalse();
        return List.of(
                newStore(condAddress, finalizedState),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondSignal(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_signal
        return inlinePthreadCondBroadcast(call);
    }

    private List<Event> inlinePthreadCondBroadcast(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_broadcast
        // Because of spurious wake-ups, there is no need to do anything here.
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //final Expression condAddress = call.getArguments().get(0);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondWait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_wait
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        //final Expression condAddress = call.getArguments().get(0);
        final Expression lockAddress = call.getArguments().get(1);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_cond_wait", mutexType);
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_cond_wait", oldValueAndSuccessType);
        return eventSequence(
                // Allow other threads to access the condition variable.
                newPthreadUnlock(oldValueRegister, lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondTimedwait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_timedwait
        final Register errorRegister = getResultRegisterAndCheckArguments(3, call);
        final IntegerType errorType = (IntegerType) errorRegister.getType();
        //final Expression condAddress = call.getArguments().get(0);
        final Expression lockAddress = call.getArguments().get(1);
        //final Expression timespec = call.getArguments().get(2);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_cond_timedwait", mutexType);
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_cond_timedwait", oldValueAndSuccessType);
        return eventSequence(
                // Allow other threads to access the condition variable.
                newPthreadUnlock(oldValueRegister, lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignPosixError(errorRegister, PosixErrorCode.ETIMEDOUT)
        );
    }

    private List<Event> inlinePthreadCondAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_condattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        checkUnknownIntrinsic(init || destroy, call);
        return List.of(
                newStore(attrAddress, expressions.makeValue(init)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyCreate(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_create
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression keyAddress = call.getArguments().get(0);
        final Expression destructor = call.getArguments().get(1);
        final Register keyRegister = call.getFunction().newUniqueRegister("__pthread_key_create_key", getNativeIntType());
        return List.of(
                newDynamicThreadLocalCreate(keyRegister, destructor),
                newStore(keyAddress, keyRegister),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyDelete(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_delete
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression key = call.getArguments().get(0);
        return List.of(
                newDynamicThreadLocalDelete(key),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadGetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_getspecific
        final Register result = getResultRegisterAndCheckArguments(1, call);
        final Expression key = call.getArguments().get(0);
        return List.of(
                newDynamicThreadLocalGet(result, key)
        );
    }

    private List<Event> inlinePthreadSetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_setspecific
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression key = call.getArguments().get(0);
        final Expression value = call.getArguments().get(1);
        return List.of(
                newDynamicThreadLocalSet(key, value),
                assignSuccess(errorRegister)
        );
    }

    private static final List<String> P_THREAD_MUTEXATTR = List.of(
            "prioceiling",
            "protocol",
            "type"
    );

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_init
        //TODO use attributes
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        final IntegerType type = getPthreadMutexType();
        final Expression unlocked = expressions.makeZero(type);
        return List.of(
                EventFactory.Llvm.newStore(lockAddress, unlocked, Tag.C11.MO_RELEASE),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //TODO store a value such that later uses of the lock fail
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_lock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(errorRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_mutex_lock", oldValueAndSuccessType);
        final Expression lockAddress = call.getArguments().get(0);
        return eventSequence(
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexTryLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_trylock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(errorRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getPthreadMutexType(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_mutex_try_lock", oldValueAndSuccessType);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression fail = expressions.makeNot(expressions.makeExtract(oldValueAndSuccess, 1));
        return List.of(
                newPthreadTryLock(oldValueAndSuccess, lockAddress),
                EventFactory.newLocal(errorRegister, expressions.makeCast(fail, errorRegister.getType()))
        );
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final IntegerType type = getPthreadMutexType();
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_mutex_unlock", type);
        final Expression lockAddress = call.getArguments().get(0);
        return eventSequence(
                newPthreadUnlock(oldValueRegister, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexAttr(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutexattr_init
        final String functionName = call.getCalledFunction().getName();
        // MacOS systems prepend 'pthread_mutexattr_destroy' with _.
        final int prefixLength = functionName.startsWith("_") ? 1 : 0;
        final String suffix = functionName.substring(prefixLength + "pthread_mutexattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        if (init || destroy) {
            return List.of(
                    newStore(attrAddress, expressions.makeValue(init)),
                    assignSuccess(errorRegister)
            );
        }
        final boolean get = suffix.startsWith("get");
        checkUnknownIntrinsic(get || suffix.startsWith("set"), call);
        checkUnknownIntrinsic(P_THREAD_MUTEXATTR.contains(suffix.substring(3)), call);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> newPthreadUnlock(Register oldValueRegister, Expression address) {
        final Expression unlocked = expressions.makeGeneralZero(oldValueRegister.getType());
        final boolean skipCheck = notToInline.contains(AssertionType.USER);
        final Event load = skipCheck ? null : EventFactory.Llvm.newLoad(oldValueRegister, address, Tag.C11.MO_RELAXED);
        final Expression isLocked = skipCheck ? null : expressions.makeNEQ(oldValueRegister, unlocked);
        final Event check = skipCheck ? null : EventFactory.newAssert(isLocked, "Unlocking an already unlocked mutex");
        final Event store = EventFactory.Llvm.newStore(address, unlocked, Tag.C11.MO_RELEASE);
        return Arrays.asList(load, check, store);
    }

    private Event newPthreadTryLock(Register oldValueAndSuccess, Expression lockAddress) {
        final Expression unlocked = expressions.makeZero(getPthreadMutexType());
        final Expression locked = expressions.makeOne(getPthreadMutexType());
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, unlocked, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> newPthreadLock(Register oldValueSuccessRegister, Expression address) {
        // We implement this as a CAS-spinlock
        final Label spinLoopHead = EventFactory.newLabel("__spinloop_head");
        final Label spinLoopEnd = EventFactory.newLabel("__spinloop_end");
        return List.of(
                newLoopBound(expressions.makeValue(1, types.getArchType())),
                spinLoopHead,
                newPthreadTryLock(oldValueSuccessRegister, address),
                EventFactory.newJump(expressions.makeExtract(oldValueSuccessRegister, 1), spinLoopEnd),
                EventFactory.newGoto(spinLoopHead),
                spinLoopEnd
        );
    }

    private IntegerType getPthreadMutexType() {
        return types.getIntegerType(1);
    }

    private static final List<String> P_THREAD_RWLOCK_ATTR = List.of(
            "pshared"
    );

    private List<Event> inlinePthreadRwlockInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        return List.of(
                newStore(lockAddress, getRwlockUnlockedValue()),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //TODO store a value such that later uses of the lock fail
        //final Expression lock = call.getArguments().get(0);
        //final Expression finalizedValue = expressions.makeZero(types.getArchType());
        return List.of(
                //EventFactory.newStore(lock, finalizedValue)
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockWrlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_wrlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newRegister(oldValueAndSuccessType);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(oldValueAndSuccess, lockAddress),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successResult)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryWrlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_trywrlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newRegister(oldValueAndSuccessType);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(oldValueAndSuccess, lockAddress),
                // Indicate success by returning zero.
                EventFactory.newNonDetChoice(errorRegister),
                EventFactory.newAssume(expressions.makeEQ(successResult, expressions.makeEQ(errorRegister, success)))
        );
    }

    private Event newRwlockTryWrlock(Register oldValueAndSuccess, Expression lockAddress) {
        final Expression unlocked = getRwlockUnlockedValue();
        final Expression locked = getRwlockWriteLockedValue();
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, unlocked, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> inlinePthreadRwlockRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_rdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_rwlock_rdlock", oldValueAndSuccessType);
        final Register expectedRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression oldValueResult = expressions.makeExtract(oldValueAndSuccess, 0);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        final Expression wasWriteLocked = expressions.makeEQ(oldValueResult, getRwlockWriteLockedValue());
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newNonDetChoice(expectedRegister),
                EventFactory.newAssume(expressions.makeNEQ(expectedRegister, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(oldValueAndSuccess, lockAddress, expectedRegister),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successResult, wasWriteLocked)),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successResult)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_tryrdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_rwlock_try_rdlock", oldValueAndSuccessType);
        final Register expectedRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        final Expression actualResult = expressions.makeExtract(oldValueAndSuccess, 0);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        final Expression wasWriteLocked = expressions.makeEQ(actualResult, getRwlockWriteLockedValue());
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newNonDetChoice(expectedRegister),
                EventFactory.newAssume(expressions.makeNEQ(expectedRegister, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(oldValueAndSuccess, lockAddress, expectedRegister),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successResult, wasWriteLocked)),
                // Indicate success with zero.
                EventFactory.newNonDetChoice(errorRegister),
                EventFactory.newAssume(expressions.makeEQ(successResult, expressions.makeEQ(errorRegister, success)))
        );
    }

    private Event newRwlockTryRdlock(Register oldValueAndSuccess, Expression lockAddress, Expression expected) {
        final Expression wasUnlocked = expressions.makeEQ(expected, getRwlockUnlockedValue());
        final Expression lockedOnce = expressions.makeValue(BigInteger.TWO, getRwlockDatatype());
        final Expression lockedMore = expressions.makeAdd(expected, expressions.makeOne(getRwlockDatatype()));
        final Expression locked = expressions.makeITE(wasUnlocked, lockedOnce, lockedMore);
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, expected, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> inlinePthreadRwlockUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register oldValueRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Register decrementRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression one = expressions.makeOne(getRwlockDatatype());
        final Expression two = expressions.makeValue(BigInteger.TWO, getRwlockDatatype());
        final Expression lastReader = expressions.makeEQ(oldValueRegister, two);
        final Expression properDecrement = expressions.makeITE(lastReader, two, one);
        //TODO does not recognize whether the calling thread is allowed to unlock
        return List.of(
                // decreases the lock value by 1, if not the last reader, or else 2.
                EventFactory.newNonDetChoice(decrementRegister),
                EventFactory.Llvm.newRMW(oldValueRegister, lockAddress, decrementRegister, IntBinaryOp.SUB, Tag.C11.MO_RELEASE),
                EventFactory.newAssume(expressions.makeEQ(decrementRegister, properDecrement)),
                assignSuccess(errorRegister)
        );
    }

    private IntegerType getRwlockDatatype() {
        return types.getArchType();
    }

    private IntLiteral getRwlockUnlockedValue() {
        //FIXME this assumes that the lock is initialized with pthread_rwlock_init,
        // but some programs may explicitly initialize it with other platform-dependent values.
        return expressions.makeZero(getRwlockDatatype());
    }

    private IntLiteral getRwlockWriteLockedValue() {
        return expressions.makeOne(getRwlockDatatype());
    }

    private List<Event> inlinePthreadRwlockAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_rwlockattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        if (init || destroy) {
            return List.of(
                    newStore(attrAddress, expressions.makeValue(init)),
                    assignSuccess(errorRegister)
            );
        }
        final boolean get = suffix.startsWith("get");
        checkUnknownIntrinsic(get || suffix.startsWith("set"), call);
        checkUnknownIntrinsic(P_THREAD_RWLOCK_ATTR.contains(suffix.substring(3)), call);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlineMalloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(1, call);
        final Type allocType = types.getByteType();
        final Expression totalSize = call.getArguments().get(0);
        return List.of(
                EventFactory.newAlloc(resultRegister, allocType, totalSize, true, false)
        );
    }

    private List<Event> inlineCalloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Type allocType = types.getByteType();
        final Expression elementCount = call.getArguments().get(0);
        final Expression elementSize = call.getArguments().get(1);
        final Expression totalSize = expressions.makeMul(elementCount, elementSize);
        return List.of(
                EventFactory.newAlloc(resultRegister, allocType, totalSize, true, true)
        );
    }

    private List<Event> inlineAlignedAlloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Type allocType = types.getByteType();
        final Expression alignment = call.getArguments().get(0);
        final Expression totalSize = call.getArguments().get(1);
        return List.of(
                EventFactory.newAlignedAlloc(resultRegister, allocType, totalSize, alignment, true, false)
        );
    }

    private List<Event> inlineFree(FunctionCall call) {
        final Expression address = call.getArguments().get(0);
        return List.of(newDealloc(address));
    }

    private List<Event> inlineAssert(FunctionCall call, AssertionType skip, String errorMsg) {
        final Expression condition = expressions.makeFalse();
        final Event assertion = notToInline.contains(skip) ? null : EventFactory.newAssert(condition, errorMsg);
        final Event abort = EventFactory.newAbortIf(expressions.makeTrue());
        abort.addTags(Tag.EXCEPTIONAL_TERMINATION);
        return eventSequence(assertion, abort);
    }

    private List<Event> inlineVerifierAssert(FunctionCall call, AssertionType skip, String errorMsg) {
        if(notToInline.contains(skip)) {
            return List.of();
        }
        assert call.getArguments().size() == 1;
        final Expression condition = call.getArguments().get(0);
        final Event assertion = EventFactory.newAssert(expressions.makeBooleanCast(condition), errorMsg);
        return List.of(assertion);
    }

    private List<Event> inlineUserAssert(FunctionCall call) {
        if (call.getCalledFunction().getIntrinsicInfo() == Info.VERIFIER_ASSERT) {
            return inlineVerifierAssert(call, AssertionType.USER, "user assertion");
        } else {
            return inlineAssert(call, AssertionType.USER, "user assertion");
        }
    }

    private List<Event> inlineIntegerOverflow(FunctionCall call) {
        return inlineAssert(call, AssertionType.OVERFLOW, "integer overflow");
    }

    private List<Event> inlineInvalidDereference(FunctionCall call) {
        return inlineAssert(call, AssertionType.INVALIDDEREF, "invalid dereference");
    }

    private List<Event> inlineUnknownFunction(FunctionCall call) {
        final List<Event> replacement = new ArrayList<>();
        if (call instanceof ValueFunctionCall) {
            replacement.addAll(inlineCallAsNonDet(call));
        }
        replacement.addAll(inlineAssert(call, AssertionType.UNKNOWN_FUNCTION,
            "Calling unknown function " + call.getCalledFunction().getName()));
        return replacement;
    }


    // --------------------------------------------------------------------------------------------------------
    // LLVM intrinsics

    private List<Event> handleLLVMIntrinsic(FunctionCall call) {
        assert call instanceof ValueFunctionCall && call.isDirectCall();
        final ValueFunctionCall valueCall = (ValueFunctionCall) call;
        final String name = call.getCalledFunction().getName();

        if (name.startsWith("llvm.ctlz")) {
            return inlineLLVMCtlz(valueCall);
        } else if (name.startsWith("llvm.cttz")) {
            return inlineLLVMCttz(valueCall);
        } else if (name.startsWith("llvm.ctpop")) {
            return inlineLLVMCtpop(valueCall);
        } else if (name.contains("add.sat")) {
            return inlineLLVMSaturatedAdd(valueCall);
        } else if (name.contains("sadd.with.overflow")) {
            return inlineLLVMSAddWithOverflow(valueCall);
        } else if (name.contains("ssub.with.overflow")) {
            return inlineLLVMSSubWithOverflow(valueCall);
        } else if (name.contains("smul.with.overflow")) {
            return inlineLLVMSMulWithOverflow(valueCall);
        } else if (name.contains("sub.sat")) {
            return inlineLLVMSaturatedSub(valueCall);
        } else if (name.startsWith("llvm.smax") || name.startsWith("llvm.smin")
                || name.startsWith("llvm.umax") || name.startsWith("llvm.umin")
                || name.startsWith("llvm.fmax") || name.startsWith("llvm.fmin")
                || name.startsWith("llvm.maxnum") || name.startsWith("llvm.minnum")) {
            return inlineLLVMMinMax(valueCall);
        } else if (name.contains("llvm.fabs")) {
            return inlineLLVMFAbs(valueCall);
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
        return List.of(EventFactory.newAssume(expressions.makeBooleanCast(call.getArguments().get(0))));
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
        final Expression resultExpression = expressions.makeCTLZ(input);
        final Event assignment = EventFactory.newLocal(resultReg, resultExpression);
        return List.of(assignment);
    }

    private List<Event> inlineLLVMCttz(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-cttz-intrinsic
        checkArgument(call.getArguments().size() == 2,
                "Expected 2 parameters for \"llvm.cttz\", got %s.", call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final Type type = resultReg.getType();
        checkArgument(resultReg.getType() instanceof IntegerType,
                "Non-integer %s type for \"llvm.cttz\".", type);
        checkArgument(input.getType().equals(type),
                "Return type %s of \"llvm.cttz\" must match argument type %s.", type, input.getType());
        final Expression resultExpression = expressions.makeCTTZ(input);
        final Event assignment = EventFactory.newLocal(resultReg, resultExpression);
        return List.of(assignment);
    }

    private List<Event> inlineLLVMCtpop(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-ctpop-intrinsic
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final IntegerType type = (IntegerType) resultReg.getType();
        final Expression increment = expressions.makeAdd(resultReg, expressions.makeOne(type));

        final List<Event> replacement = new ArrayList<>();
        replacement.add(EventFactory.newLocal(resultReg, expressions.makeZero(type)));
        //TODO: There might be more efficient ways to count bits set, though it is not clear
        // if they are also more friendly for the SMT backend.
        for (int i = type.getBitWidth() - 1; i >= 0; i--) {
            final Expression testMask = expressions.makeValue(BigInteger.ONE.shiftLeft(i), type);
            //TODO: dedicated test-bit expressions might yield better results, and they are supported by the SMT backend
            // in the form of extract operations.
            final Expression testBit = expressions.makeEQ(expressions.makeIntAnd(input, testMask), testMask);

            replacement.add(
                    EventFactory.newLocal(resultReg, expressions.makeITE(testBit, increment, resultReg))
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
        final boolean isMax = name.startsWith("llvm.smax.") || name.startsWith("llvm.umax.") || name.startsWith("llvm.fmax.") || name.startsWith("llvm.maxnum.");
        final boolean isFloat = name.startsWith("llvm.fmax.") || name.startsWith("llvm.fmin.") || name.startsWith("llvm.maxnum.") || name.startsWith("llvm.minnum.");
        if (isFloat) {
            final Expression result = isMax ? expressions.makeFMax(left, right) : expressions.makeFMin(left, right);
            return List.of(EventFactory.newLocal(call.getResultRegister(), result));
        }
        final Expression isLess = expressions.makeLT(left, right, signed);
        final Expression result = expressions.makeITE(isLess, isMax ? right : left, isMax ? left : right);
        return List.of(EventFactory.newLocal(call.getResultRegister(), result));
    }

    private List<Event> inlineLLVMFAbs(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
        final List<Expression> arguments = call.getArguments();
        final Expression operand = arguments.get(0);
        final String name = call.getCalledFunction().getName();
        return List.of(EventFactory.newLocal(call.getResultRegister(), expressions.makeFAbs(operand)));
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
                    expressions.makeLT(y, expressions.makeSub(x, resultReg), true)
            );

            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                    EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeSub(x, y), resultReg))
            );
        } else {
            final Expression noUnderflow = expressions.makeGT(x, y, false);
            final Expression zero = expressions.makeZero(type);
            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeITE(noUnderflow, expressions.makeSub(x, y), zero))
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
                expressions.makeGT(y, expressions.makeSub(resultReg, x), isSigned)
        );

        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeAdd(x, y), resultReg))
        );
    }

    private List<Event> inlineLLVMSAddWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.ADD);
    }

    private List<Event> inlineLLVMSSubWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.SUB);
    }

    private List<Event> inlineLLVMSMulWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.MUL);
    }

    private List<Event> inlineLLVMSOpWithOverflow(ValueFunctionCall call, IntBinaryOp op) {
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        assert x.getType() == y.getType();

        // The flag expression defined below has the form A & B. 
        // A is only relevant for integer encoding, B is only relevant for BV encoding.  
        // Here we do not yet know yet which encoding will be used and thus use both A & B.   
        // This probably has no noticeable impact on performance.

        // Check for integer encoding
        final IntegerType iType = (IntegerType) x.getType();
        final Expression result = expressions.makeIntBinary(x, op, y);
        final Expression rangeCheck = checkIfValueInRangeOfType(result, iType, true);

        // Check for BV encoding. From LLVM's language manual:
        // "An operation overflows if, for any values of its operands A and B and for any N larger than
        // the operands’ width, ext(A op B) to iN is not equal to (ext(A) to iN) op (ext(B) to iN) where 
        // ext is sext for signed overflow and zext for unsigned overflow, and op is the 
        // underlying arithmetic operation.""
        final int width = iType.getBitWidth();
        final Expression xExt = expressions.makeCast(x, types.getIntegerType(width + 1), true);
        final Expression yExt = expressions.makeCast(y, types.getIntegerType(width + 1), true);
        final Expression resultExt = expressions.makeCast(result, types.getIntegerType(width + 1), true);
        final Expression bvCheck = expressions.makeEQ(expressions.makeIntBinary(xExt, op, yExt), resultExt);
        final Expression flag = expressions.makeCast(
                expressions.makeNot(expressions.makeAnd(bvCheck, rangeCheck)),
                types.getIntegerType(1)
        );
        final Type type = types.getAggregateType(List.of(result.getType(), flag.getType()));
        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeConstruct(type, List.of(result, flag)))
        );
    }

    private Expression checkIfValueInRangeOfType(Expression value, IntegerType integerType, boolean signed) {
        final Expression minValue = expressions.makeValue(integerType.getMinimumValue(signed), integerType);
        final Expression maxValue = expressions.makeValue(integerType.getMaximumValue(signed), integerType);
        return expressions.makeAnd(
                expressions.makeLTE(minValue, value, true),
                expressions.makeLTE(value, maxValue, true)
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
        final Expression p4 = args.size() > 4 ? args.get(4) : null;

        final List<Event> result = new ArrayList<>();
        switch (call.getCalledFunction().getName()) {
            case "__LKMM_load" -> {
                checkArguments(3, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p2);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                result.add(EventFactory.Linux.newLoad(dummy, p0, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_store" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newStore(p0, value, mo));
            }
            case "__LKMM_xchg" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWExchange(p0, dummy, value, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_cmpxchg" -> {
                checkArguments(6, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression expectation = expressions.makeCast(p2, bytes);
                final Expression value = expressions.makeCast(p3, bytes);
                result.add(EventFactory.Linux.newRMWCompareExchange(p0, dummy, expectation, value, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_fetch_op" -> {
                checkArguments(5, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final IntBinaryOp op = toLKMMOperation(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWFetchOp(p0, dummy, value, op, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_op_return" -> {
                checkArguments(5, call);
                final Type bytes = toLKMMAccessSize(p1);
                final String mo = toLKMMMemoryOrder(p3);
                final IntBinaryOp op = toLKMMOperation(p4);
                final Register dummy = call.getFunction().newUniqueRegister("__lkmm_temp", bytes);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWOpReturn(p0, dummy, value, op, mo));
                result.add(EventFactory.newLocal(reg, expressions.makeCast(dummy, reg.getType())));
            }
            case "__LKMM_atomic_op" -> {
                checkArguments(4, call);
                final Type bytes = toLKMMAccessSize(p1);
                final IntBinaryOp op = toLKMMOperation(p3);
                final Expression value = expressions.makeCast(p2, bytes);
                result.add(EventFactory.Linux.newRMWOp(p0, value, op));
            }
            case "__LKMM_fence" -> {
                checkArguments(1, call);
                final String mo = toLKMMMemoryOrder(p0);
                result.add(EventFactory.Linux.newBarrier(mo));
            }
            case "__LKMM_SPIN_LOCK" -> {
                checkArguments(1, call);
                result.add(EventFactory.Linux.newLock(p0));
            }
            case "__LKMM_SPIN_UNLOCK" -> {
                checkArguments(1, call);
                result.add(EventFactory.Linux.newUnlock(p0));
            }
            default -> {
                assert false;
            }
        }
        return result;
    }

    private Type toLKMMAccessSize(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM access size \"" + argument + "\"");
        }
        return types.getIntegerType(8 * literal.getValueAsInt());
    }

    private String toLKMMMemoryOrder(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM memory order \"" + argument + "\"");
        }
        return Tag.Linux.intToMo(literal.getValueAsInt());
    }

    private IntBinaryOp toLKMMOperation(Expression argument) {
        if (!(argument instanceof IntLiteral literal)) {
            throw new UnsupportedOperationException("Variable LKMM operation \"" + argument + "\"");
        }
        return IntBinaryOp.intToOp(literal.getValueAsInt());
    }

    // --------------------------------------------------------------------------------------------------------
    // Simple late intrinsics

    private void inlineLate(Program program) {
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

    private List<Event> inlineCallAsNonDet(FunctionCall call) {
        return List.of(
                EventFactory.newSignedNonDetChoice(getResultRegister(call), true)
        );
    }

    private List<Event> inlineNonDet(FunctionCall call) {
        assert call.isDirectCall() && call instanceof ValueFunctionCall;
        final Register result = getResultRegister(call);
        final String name = call.getCalledFunction().getName();
        final String separator = "nondet_";
        final int index = name.indexOf(separator);
        assert index > -1;
        final String suffix = name.substring(index + separator.length());

        final Type nonDetType;
        final boolean signed;
        switch (suffix) {
            case "bool" -> {
                // Nondeterministic booleans
                signed = false;
                nonDetType = types.getBooleanType();
            }
            case "float" -> {
                // Nondeterministic floats (32 bits)
                signed = true;
                nonDetType = types.getIEEESingleType();
            }
            case "double" -> {
                // Nondeterministic floats (64 bits)
                signed = true;
                nonDetType = types.getIEEEDoubleType();
            }
            default -> {
                // Nondeterministic integers
                final int bits = switch (suffix) {
                    case "longlong", "ulonglong" -> 64;
                    case "long", "ulong" -> 64;
                    case "int", "uint", "unsigned_int" -> 32;
                    case "short", "ushort", "unsigned_short" -> 16;
                    case "char", "uchar" -> 8;
                    default -> throw new UnsupportedOperationException(String.format("%s is not supported", call));
                };

                signed = switch (suffix) {
                    case "int", "short", "long", "longlong", "char" -> true;
                    default -> false;
                };
                nonDetType = types.getIntegerType(bits);
            }
        }

        final Register nonDetReg = call.getFunction().getOrNewRegister("__r_nondet_" + suffix, nonDetType);
        return List.of(
                EventFactory.newSignedNonDetChoice(nonDetReg, signed),
                EventFactory.newLocal(result, expressions.makeCast(nonDetReg, result.getType(), signed))
        );
    }

    // Handles both std.memcpy and llvm.memcpy
    // https://en.cppreference.com/w/c/string/byte/memcpy
    private List<Event> inlineMemCpy(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression dest = call.getArguments().get(0);
        final Expression src = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memcpy has an extra argument

        final List<Event> replacement = new ArrayList<>();
        insertMemCopy(replacement, src, dest, countExpr, caller, call);
        if (call instanceof ValueFunctionCall valueCall) {
            // std.memcpy returns the destination address, llvm.memcpy has no return value
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    // https://en.cppreference.com/w/c/string/byte/memcpy
    private List<Event> inlineMemCpyS(FunctionCall call) {
        // Cast guaranteed to success by the return type of memcpy_s
        final Register resultRegister = ((ValueFunctionCall)call).getResultRegister();
        final Function caller = call.getFunction();
        final Expression dest = call.getArguments().get(0);
        final Expression destszExpr = call.getArguments().get(1);
        final Expression src = call.getArguments().get(2);
        final Expression countExpr = call.getArguments().get(3);

        // Runtime checks
        final Expression nullExpr = expressions.makeZero(types.getArchType());
        final Expression destIsNull = expressions.makeEQ(dest, nullExpr);
        final Expression srcIsNull = expressions.makeEQ(src, nullExpr);

        // We assume RSIZE_MAX = 2^64-1
        final Expression rsize_max = expressions.makeValue(BigInteger.ONE.shiftLeft(64).subtract(BigInteger.ONE), types.getArchType());
        // These parameters have type rsize_t/size_t which we model as types.getArchType(), thus the cast
        final Expression castDestszExpr = expressions.makeCast(destszExpr, types.getArchType());
        final Expression castCountExpr = expressions.makeCast(countExpr, types.getArchType());

        final Expression invalidDestsz = expressions.makeGT(castDestszExpr, rsize_max, false);
        final Expression countGtMax = expressions.makeGT(castCountExpr, rsize_max, false);
        final Expression countGtdestszExpr = expressions.makeGT(castCountExpr, castDestszExpr, false);
        final Expression invalidCount = expressions.makeOr(countGtMax, countGtdestszExpr);
        final Expression overlap = expressions.makeAnd(
                expressions.makeGT(expressions.makeAdd(src, castCountExpr), dest, false),
                expressions.makeGT(expressions.makeAdd(dest, castCountExpr), src, false));

        final List<Event> replacement = new ArrayList<>();
        
        final Label check1 = EventFactory.newLabel("__memcpy_s_check_1");
        final Label check1fail = EventFactory.newLabel("__memcpy_s_fail_1");
        final Label check2 = EventFactory.newLabel("__memcpy_s_check_2");
        final Label check2fail = EventFactory.newLabel("__memcpy_s_fail_2");
        final Label success = EventFactory.newLabel("__memcpy_s_success");
        final Label end = EventFactory.newLabel("__memcpy_s_end");

        final Expression returnCodeFail = expressions.makeOne((IntegerType)resultRegister.getType());
        final Expression returnCodeSuccess = expressions.makeZero((IntegerType)resultRegister.getType());

        // If dest == NULL or destsz > RSIZE_MAX,
        // return error > 0.
        final CondJump check1part1 = EventFactory.newJump(destIsNull, check1fail);
        final CondJump check1part2 = EventFactory.newJumpUnless(invalidDestsz, check2);
        final CondJump skipRest1 = EventFactory.newGoto(end);
        final Local retError1 = EventFactory.newLocal(resultRegister, returnCodeFail);
        replacement.addAll(List.of(
            check1,
            check1part1,
            check1part2,
            check1fail,
            retError1,
            skipRest1
        ));

        // Otherwise, if src == NULL || count > destsz || overlap(src, dest),
        // return error > 0 and zero out [dest, dest+destsz).
        final CondJump check2part1 = EventFactory.newJump(srcIsNull, check2fail);
        final CondJump check2part2 = EventFactory.newJump(invalidCount, check2fail);
        final CondJump check2part3 = EventFactory.newJumpUnless(overlap, success);
        final CondJump skipRest2 = EventFactory.newGoto(end);
        final Local retError2 = EventFactory.newLocal(resultRegister, returnCodeFail);
        replacement.addAll(List.of(
            check2,
            check2part1,
            check2part2,
            check2part3,
            check2fail
        ));

        // Otherwise, return error = 0 and do the actual copy.
        forEachMemSpan(replacement, destszExpr, call, (offset, type) -> {
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Expression zero = expressions.makeZero(type);
            replacement.add(EventFactory.newStore(destAddr, zero));
        });
        replacement.addAll(List.of(
            retError2,
            skipRest2
        ));

        final Local retSuccess = EventFactory.newLocal(resultRegister, returnCodeSuccess);
        replacement.add(success);
        insertMemCopy(replacement, src, dest, countExpr, caller, call);
        replacement.addAll(List.of(
            retSuccess,
            end
        ));

        return replacement;
    }

    private void insertMemCopy(List<Event> replacement, Expression src, Expression dest, Expression count,
            Function caller, FunctionCall call) {
        forEachMemSpan(replacement, count, call, (offset, type) -> {
            final Expression srcAddr = expressions.makeAdd(src, offset);
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Register register = caller.newUniqueRegister("__memcpy", type);
            final Event load = EventFactory.newLoad(register, srcAddr);
            final Event store = EventFactory.newStore(destAddr, register);
            replacement.addAll(List.of(load, store));
        });
    }

    // https://en.cppreference.com/w/c/string/byte/memcmp
    private List<Event> inlineMemCmp(FunctionCall call) {
        final Function caller = call.getFunction();
        final Expression src1 = call.getArguments().get(0);
        final Expression src2 = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        final Register returnReg = ((ValueFunctionCall)call).getResultRegister();
        // Stores the result in eight bits.
        final Register cmpReg = caller.newUniqueRegister("__memcmp_cmp", types.getByteType());
        // When this intrinsics is implemented with multibyte accesses, this determines the comparison order.
        final boolean bigEndian = caller.getProgram().getMemory().isBigEndian();
        assert bigEndian != caller.getProgram().getMemory().isLittleEndian();

        final List<Event> replacement = new ArrayList<>();
        final Label endCmp = EventFactory.newLabel("__memcmp_end");
        // Initialize the register for when `countExpr` is zero.
        replacement.add(EventFactory.newLocal(cmpReg, expressions.makeZero(types.getByteType())));
        // Compare all bytes in order.
        forEachMemSpan(replacement, countExpr, call, (offset, type) -> {
            final Expression src1Addr = expressions.makeAdd(src1, offset);
            final Expression src2Addr = expressions.makeAdd(src2, offset);
            final Register regSrc1 = caller.newUniqueRegister("__memcmp_src1", type);
            final Register regSrc2 = caller.newUniqueRegister("__memcmp_src2", type);
            replacement.add(EventFactory.newLoad(regSrc1, src1Addr));
            replacement.add(EventFactory.newLoad(regSrc2, src2Addr));
            // Iterate in byte order.
            final int bitWidth = type.getBitWidth();
            for (int cmpByte = 0; cmpByte < bitWidth; cmpByte += 8) {
                final int cmpOffset = bigEndian ? bitWidth - 8 - cmpByte : cmpByte;
                final Expression byte1 = expressions.makeIntExtract(regSrc1, cmpOffset, cmpOffset + 8 - 1);
                final Expression byte2 = expressions.makeIntExtract(regSrc2, cmpOffset, cmpOffset + 8 - 1);
                replacement.add(EventFactory.newLocal(cmpReg, expressions.makeSub(byte1, byte2)));
                replacement.add(EventFactory.newJump(expressions.makeNEQ(byte1, byte2), endCmp));
            }
        });
        replacement.add(endCmp);
        replacement.add(EventFactory.newLocal(returnReg, expressions.makeCast(cmpReg, returnReg.getType())));

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

        final List<Event> replacement = new ArrayList<>();

        // Generate stores
        final Expression fillByte = expressions.makeIntegerCast(fillExpr, types.getByteType(), false);
        final Map<Integer, Expression> fillByBitWidth = new HashMap<>();
        fillByBitWidth.put(8, fillByte);
        forEachMemSpan(replacement, countExpr, call, (offset, type) -> {
            final Expression destAddr = expressions.makeAdd(dest, offset);
            final Expression fill = fillByBitWidth.computeIfAbsent(type.getBitWidth(),
                    n -> expressions.makeIntConcat(IntStream.range(0, n / 8).mapToObj(x -> fillByte).toList()));

            replacement.add(newStore(destAddr, fill));
        });

        if (call instanceof ValueFunctionCall valueCall) {
            // `std.memset` returns the destination address, `llvm.memset` has no return value.
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
    }

    private interface MemAction { void run(Expression offsetBytes, IntegerType accessType); }

    // Used for memory operations with dynamic size.
    // Uses `countExpr` to divide the maximal byte range of the operation into consecutive smaller spans.
    // Performs `action` for either each span, or each byte, depending on the support for mixed size accesses.
    // Checks `countExpr` dynamically at the start of each next span.
    // The resulting program takes the form of an unrolled loop.
    private void forEachMemSpan(List<Event> replacement, Expression countExpr, FunctionCall call, MemAction action) {
        final Slice count = computeValueSpace(countExpr, call);
        checkArgument(0 <= count.start && count.start <= count.end && 0 < count.step, "Invalid count %s: %s", count, call);
        checkArgument(countExpr.getType() instanceof IntegerType, "Non-integer count expression: %s", call);
        if ((count.end - count.start) % count.step != 0) {
            logger.warn("Suspicious count {}: {}", count, call);
        }
        final IntegerType countType = (IntegerType) countExpr.getType();
        // Process the first span [0,count.start-1].
        // If `countExpr` is a positive constant, this is enabled.
        // The span does not need any checks for `countExpr`.
        if (count.start > 0) {
            translateMemSpan(expressions.makeZero(countType), count.start, countType, action);
        }
        // Each remaining span needs one check for `countExpr`.
        // If `countExpr` is a constant, this is disabled.
        // This is implemented as a loop.
        if (count.start + count.step < count.end) {
            final Register offsetRegister = call.getFunction().newUniqueRegister("__offset", countType);
            final Expression stepExpr = expressions.makeValue(count.step, countType);
            final Expression countReached = expressions.makeLTE(countExpr, offsetRegister, false);
            final Expression loopBound = expressions.makeValue((count.end - count.start) / count.step, countType);
            final Label loopEntry = EventFactory.newLabel("__start");
            final Label loopExit = EventFactory.newLabel("__end");
            replacement.add(EventFactory.newLocal(offsetRegister, expressions.makeValue(count.start, countType)));
            replacement.add(EventFactory.newLoopBound(loopBound));
            replacement.add(loopEntry);
            replacement.add(EventFactory.newIfJump(countReached, loopExit, loopExit));
            translateMemSpan(offsetRegister, count.step, countType, action);
            replacement.add(EventFactory.newLocal(offsetRegister, expressions.makeAdd(offsetRegister, stepExpr)));
            replacement.add(EventFactory.newGoto(loopEntry));
            replacement.add(loopExit);
        }
        // Mark all events to not generate `si`-pairs if torn with mixed-sized accesses.
        for (Event event : replacement) {
            if (event.hasTag(Tag.MEMORY)) {
                event.addTags(Tag.NO_INSTRUCTION);
            }
        }
    }

    // Describes the sums of `start` with some multiple of `step`, that are lower than `end`.
    private record Slice(int start, int end, int step) {}

    // Over-approximates the set of possible values for a count argument of a dynamic-sized memory operation.
    private Slice computeValueSpace(Expression countExpr, FunctionCall call) {
        if (countExpr instanceof IntLiteral literal) {
            final int value = literal.getValueAsInt();
            return new Slice(value, value + 1, 1);
        }
        //TODO: Perform loop unrolling after these intrinsics, when adding support for this.
        throw new UnsupportedOperationException("Cannot handle dynamic count argument: %s".formatted(call));
    }

    private void translateMemSpan(Expression initialOffset, int bytes, IntegerType countType, MemAction action) {
        // Perform `action` either byte-wise or for the entire byte span.
        final int restBytes = detectMixedSizeAccesses ? bytes : 1;
        final IntegerType restType = types.getIntegerType(8 * restBytes);
        for (int offset = 0; offset < bytes; offset += restBytes) {
            final Expression offsetBytes = expressions.makeValue(offset, countType);
            action.run(expressions.makeAdd(initialOffset, offsetBytes), restType);
        }
    }

    private List<Event> inlineLLVMThreadLocal(FunctionCall call) {
        final Register resultReg = getResultRegisterAndCheckArguments(1, call);
        final Expression exp = call.getArguments().get(0);
        checkArgument(exp instanceof MemoryObject object && object.isThreadLocal(), "Calling thread-local intrinsic on a non-thread-local object \"%s\"", call);
        return List.of(
            EventFactory.newLocal(resultReg, exp)
        );
    }

    private List<Event> inlineFfs(FunctionCall call) {
        //see https://linux.die.net/man/3/ffs
        final String name = call.getCalledFunction().getName();
        checkArgument(call.getArguments().size() == 1,
                "Expected 1 parameter for \"%s\", got %s.", name, call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        final Register resultReg = getResultRegister(call);
        final Type outputType = resultReg.getType();
        checkArgument(outputType instanceof IntegerType,
                "Non-integer %s type for \"%s\".", name, outputType);
        final IntegerType inputType  = (IntegerType)input.getType();
        final Expression cttz = expressions.makeCTTZ(input);
        final Expression widthExpr = expressions.makeValue(BigInteger.valueOf(inputType.getBitWidth()), inputType);
        final Expression count = expressions.makeAdd(cttz, expressions.makeOne(inputType));
        final Expression ite = expressions.makeITE(expressions.makeEQ(cttz, widthExpr), expressions.makeZero(inputType), count);
        final Expression cast = expressions.makeCast(ite, outputType, false);
        final Event assignment = EventFactory.newLocal(resultReg, cast);
        return List.of(assignment);
    }

    private IntegerType getNativeIntType() {
        return types.getIntegerType(32);
    }

    private Event assignPosixError(Register errorRegister, PosixErrorCode code) {
        final Expression value = expressions.makeValue(code.getValue(), (IntegerType) errorRegister.getType());
        return EventFactory.newLocal(errorRegister, value);
    }

    private Event assignSuccess(Register errorRegister) {
        return EventFactory.newLocal(errorRegister, expressions.makeGeneralZero(errorRegister.getType()));
    }

    private Register getResultRegisterAndCheckArguments(int expectedArgumentCount, FunctionCall call) {
        checkArguments(expectedArgumentCount, call);
        return getResultRegister(call);
    }

    private void checkArguments(int expectedArgumentCount, FunctionCall call) {
        checkArgument(call.getArguments().size() == expectedArgumentCount, "Wrong function type at %s", call);
    }

    private void checkUnknownIntrinsic(boolean condition, FunctionCall call) {
        checkArgument(condition, "Unknown intrinsic \"%s\"", call);
    }

    private Register getResultRegister(FunctionCall call) {
        checkArgument(call instanceof ValueFunctionCall, "Unexpected value discard at intrinsic \"%s\"", call);
        return ((ValueFunctionCall) call).getResultRegister();
    }
}
