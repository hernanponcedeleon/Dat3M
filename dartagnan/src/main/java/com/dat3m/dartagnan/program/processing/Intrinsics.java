package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.google.common.collect.ImmutableList;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.REMOVE_ASSERTION_OF_TYPE;
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

    private static final Logger logger = LogManager.getLogger(Intrinsics.class);

    @Option(name = REMOVE_ASSERTION_OF_TYPE,
            description = "Remove assertions of type [user, overflow, invalidderef].",
            toUppercase=true,
            secure = true)
    private EnumSet<AssertionType> notToInline = EnumSet.noneOf(AssertionType.class);

    private enum AssertionType { USER, OVERFLOW, INVALIDDEREF }

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
    
    public static Intrinsics fromConfig(Configuration config) throws InvalidConfigurationException {
        Intrinsics instance = newInstance();
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
        P_THREAD_CREATE("pthread_create", true, false, true, false, null),
        P_THREAD_EXIT("pthread_exit", false, false, false, false, null),
        P_THREAD_JOIN(List.of("pthread_join", "_pthread_join", "__pthread_join"), false, true, false, false, null),
        P_THREAD_BARRIER_WAIT("pthread_barrier_wait", false, false, true, true, Intrinsics::inlineAsZero),
        P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), false, false, true, false, null),
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
        P_THREAD_KEY_CREATE("pthread_key_create", false, false, true, false, Intrinsics::inlinePthreadKeyCreate),
        P_THREAD_KEY_DELETE("pthread_key_delete", false, false, true, false, Intrinsics::inlinePthreadKeyDelete),
        P_THREAD_GET_SPECIFIC("pthread_getspecific", false, true, true, false, Intrinsics::inlinePthreadGetSpecific),
        P_THREAD_SET_SPECIFIC("pthread_setspecific", true, false, true, false, Intrinsics::inlinePthreadSetSpecific),
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
        VERIFIER_LOOP_BEGIN("__VERIFIER_loop_begin", false, false, true, true, Intrinsics::inlineLoopBegin),
        VERIFIER_LOOP_BOUND("__VERIFIER_loop_bound", false, false, true, true, Intrinsics::inlineLoopBound),
        VERIFIER_SPIN_START("__VERIFIER_spin_start", false, false, true, true, Intrinsics::inlineSpinStart),
        VERIFIER_SPIN_END("__VERIFIER_spin_end", false, false, true, true, Intrinsics::inlineSpinEnd),
        VERIFIER_ASSUME("__VERIFIER_assume", false, false, true, true, Intrinsics::inlineAssume),
        VERIFIER_ASSERT("__VERIFIER_assert", false, false, false, false, Intrinsics::inlineUserAssert),
        VERIFIER_NONDET(List.of("__VERIFIER_nondet_bool",
                "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar"),
                false, false, true, false, Intrinsics::inlineNonDet),
        // --------------------------- LLVM ---------------------------
        LLVM(List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin",
                "llvm.ssub.sat", "llvm.usub.sat", "llvm.sadd.sat", "llvm.uadd.sat", // TODO: saturated shifts
                "llvm.sadd.with.overflow", "llvm.ssub.with.overflow", "llvm.smul.with.overflow",
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
        STD_MALLOC("malloc", false, false, true, true, Intrinsics::inlineMalloc),
        STD_CALLOC("calloc", false, false, true, true, Intrinsics::inlineCalloc),
        STD_FREE("free", true, false, true, true, Intrinsics::inlineAsZero),//TODO support free
        STD_ASSERT(List.of("__assert_fail", "__assert_rtn"), false, false, false, true, Intrinsics::inlineUserAssert),
        STD_EXIT("exit", false, false, false, true, Intrinsics::inlineExit),
        STD_ABORT("abort", false, false, false, true, Intrinsics::inlineExit),
        STD_IO(List.of("puts", "putchar", "printf"), false, false, true, true, Intrinsics::inlineAsZero),
        STD_SLEEP("sleep", false, false, true, true, Intrinsics::inlineAsZero),
        // --------------------------- UBSAN ---------------------------
        UBSAN_OVERFLOW(List.of("__ubsan_handle_add_overflow", "__ubsan_handle_sub_overflow", 
                "__ubsan_handle_divrem_overflow", "__ubsan_handle_mul_overflow", "__ubsan_handle_negate_overflow"),
                false, false, false, true, Intrinsics::inlineIntegerOverflow),
        UBSAN_TYPE_MISSMATCH(List.of("__ubsan_handle_type_mismatch_v1"), 
                false, false, false, true, Intrinsics::inlineInvalidDereference),
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
        final Expression attrAddress = call.getArguments().get(0);
        final boolean initial = suffix.equals("init");
        if (initial || suffix.equals("destroy")) {
            final Expression flag = expressions.makeValue(initial);
            return List.of(
                    EventFactory.newStore(attrAddress, flag),
                    assignSuccess(errorRegister)
            );
        }
        final boolean getter = suffix.startsWith("get");
        checkArgument(getter || suffix.startsWith("set"), "Unrecognized intrinsics \"%s\"", call);
        checkArgument(P_THREAD_ATTR.contains(suffix.substring(3)));
        //final Register oldValue = call.getFunction().newRegister(types.getBooleanType());
        //final Expression value = call.getArguments().get(1);
        return List.of(
                //EventFactory.newLoad(oldValue, attrAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression condAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        final Expression initializedState = expressions.makeTrue();
        return List.of(
                EventFactory.newStore(condAddress, initializedState),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression condAddress = call.getArguments().get(0);
        final Expression finalizedState = expressions.makeFalse();
        return List.of(
                EventFactory.newStore(condAddress, finalizedState),
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
        return List.of(
                // Allow other threads to access the condition variable.
                EventFactory.Pthread.newUnlock(lockAddress.toString(), lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                EventFactory.Pthread.newLock(lockAddress.toString(), lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondTimedwait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_timedwait
        final Register errorRegister = getResultRegisterAndCheckArguments(3, call);
        //final Expression condAddress = call.getArguments().get(0);
        final Expression lockAddress = call.getArguments().get(1);
        //final Expression timespec = call.getArguments().get(2);
        final var errorValue = new NonDetInt(constantId++, (IntegerType) errorRegister.getType(), true);
        errorValue.setMin(BigInteger.ZERO);
        call.getFunction().getProgram().addConstant(errorValue);
        return List.of(
                // Allow other threads to access the condition variable.
                EventFactory.Pthread.newUnlock(lockAddress.toString(), lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                EventFactory.Pthread.newLock(lockAddress.toString(), lockAddress),
                //TODO proper error code: ETIMEDOUT
                EventFactory.newLocal(errorRegister, errorValue)
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
                EventFactory.newStore(attrAddress, expressions.makeValue(init)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyCreate(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_create
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression keyAddress = call.getArguments().get(0);
        final Expression destructor = call.getArguments().get(1);
        final Program program = call.getFunction().getProgram();
        final long threadCount = program.getThreads().size();
        final int pointerBytes = types.getMemorySizeInBytes(types.getPointerType());
        final Register storageAddressRegister = call.getFunction().newRegister(types.getArchType());
        final Expression size = expressions.makeValue((threadCount + 1) * pointerBytes, types.getArchType());
        final Expression destructorOffset = expressions.makeValue(threadCount * pointerBytes, types.getArchType());
        //TODO call destructor at each thread's normal exit
        return List.of(
                EventFactory.newAlloc(storageAddressRegister, types.getArchType(), size, true),
                EventFactory.newStore(keyAddress, storageAddressRegister),
                EventFactory.newStore(expressions.makeADD(storageAddressRegister, destructorOffset), destructor),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyDelete(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_delete
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //final Expression key = call.getArguments().get(0);
        //final int threadID = call.getThread().getId();
        //TODO the destructor should no longer be called by pthread_exit
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadGetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_getspecific
        final Register result = getResultRegisterAndCheckArguments(1, call);
        final Expression key = call.getArguments().get(0);
        final int threadID = call.getThread().getId();
        final Expression offset = expressions.makeValue(threadID, (IntegerType) key.getType());
        return List.of(
                EventFactory.newLoad(result, expressions.makeADD(key, offset))
        );
    }

    private List<Event> inlinePthreadSetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_setspecific
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression key = call.getArguments().get(0);
        final Expression value = call.getArguments().get(1);
        final int threadID = call.getThread().getId();
        final Expression offset = expressions.makeValue(threadID, (IntegerType) key.getType());
        return List.of(
                EventFactory.newStore(expressions.makeADD(key, offset), value),
                assignSuccess(errorRegister)
        );
    }

    private static final List<String> P_THREAD_MUTEXATTR = List.of(
            "prioceiling",
            "protocol",
            "type",
            "policy_np"
    );

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression attributes = call.getArguments().get(1);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.Pthread.newInitLock(lockName, lockAddress, attributes),
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
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.Pthread.newLock(lockName, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexTryLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_trylock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(errorRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        // We currently use archType in InitLock, Lock and Unlock.
        final Register oldValueRegister = call.getFunction().newRegister(types.getArchType());
        final Register successRegister = call.getFunction().newRegister(types.getBooleanType());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression locked = expressions.makeOne(types.getArchType());
        final Expression unlocked = expressions.makeZero(types.getArchType());
        final Expression fail = expressions.makeNot(successRegister);
        return List.of(
                EventFactory.Llvm.newCompareExchange(oldValueRegister, successRegister, lockAddress, unlocked, locked, Tag.C11.MO_ACQUIRE),
                EventFactory.newLocal(errorRegister, expressions.makeCast(fail, errorRegister.getType()))
        );
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(
                EventFactory.Pthread.newUnlock(lockName, lockAddress),
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
                    EventFactory.newStore(attrAddress, expressions.makeValue(init)),
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

    private static final List<String> P_THREAD_RWLOCK_ATTR = List.of(
            "pshared"
    );

    private List<Event> inlinePthreadRwlockInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        return List.of(
                EventFactory.newStore(lockAddress, getRwlockUnlockedValue()),
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
        final Register successRegister = call.getFunction().newRegister(types.getBooleanType());
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(call, successRegister, lockAddress),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successRegister)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryWrlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_trywrlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Register successRegister = call.getFunction().newRegister(types.getBooleanType());
        final var error = new NonDetInt(constantId++, (IntegerType) errorRegister.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(call, successRegister, lockAddress),
                // Indicate success by returning zero.
                EventFactory.newAssume(expressions.makeEQ(successRegister, expressions.makeEQ(error, success))),
                EventFactory.newLocal(errorRegister, error)
        );
    }

    private Event newRwlockTryWrlock(FunctionCall call, Register successRegister, Expression lockAddress) {
        return EventFactory.Llvm.newCompareExchange(
                call.getFunction().newRegister(getRwlockDatatype()),
                successRegister,
                lockAddress,
                getRwlockUnlockedValue(),
                getRwlockWriteLockedValue(),
                Tag.C11.MO_ACQUIRE
        );
    }

    private List<Event> inlinePthreadRwlockRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_rdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register oldValueRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Register successRegister = call.getFunction().newRegister(types.getBooleanType());
        final Expression lockAddress = call.getArguments().get(0);
        final var expected = new NonDetInt(constantId++, getRwlockDatatype(), true);
        call.getFunction().getProgram().addConstant(expected);
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newAssume(expressions.makeNEQ(expected, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(call, oldValueRegister, successRegister, lockAddress, expected),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successRegister, expressions.makeEQ(oldValueRegister, getRwlockWriteLockedValue()))),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successRegister)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_tryrdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register oldValueRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Register successRegister = call.getFunction().newRegister(types.getBooleanType());
        final Expression lockAddress = call.getArguments().get(0);
        final var expected = new NonDetInt(constantId++, getRwlockDatatype(), true);
        call.getFunction().getProgram().addConstant(expected);
        final var error = new NonDetInt(constantId++, (IntegerType) errorRegister.getType(), true);
        call.getFunction().getProgram().addConstant(error);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newAssume(expressions.makeNEQ(expected, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(call, oldValueRegister, successRegister, lockAddress, expected),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successRegister, expressions.makeEQ(oldValueRegister, getRwlockWriteLockedValue()))),
                // Indicate success with zero.
                EventFactory.newAssume(expressions.makeEQ(successRegister, expressions.makeEQ(error, success))),
                EventFactory.newLocal(errorRegister, error)
        );
    }

    private Event newRwlockTryRdlock(FunctionCall call, Register oldValueRegister, Register successRegister, Expression lockAddress, Expression expected) {
        return EventFactory.Llvm.newCompareExchange(
                oldValueRegister,
                successRegister,
                lockAddress,
                expected,
                expressions.makeITE(
                        expressions.makeEQ(expected, getRwlockUnlockedValue()),
                        expressions.makeValue(BigInteger.TWO, getRwlockDatatype()),
                        expressions.makeADD(expected, expressions.makeOne(getRwlockDatatype()))
                ),
                Tag.C11.MO_ACQUIRE
        );
    }

    private List<Event> inlinePthreadRwlockUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register oldValueRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final var decrement = new NonDetInt(constantId++, getRwlockDatatype(), true);
        call.getFunction().getProgram().addConstant(decrement);
        final Expression one = expressions.makeOne(getRwlockDatatype());
        final Expression two = expressions.makeValue(BigInteger.TWO, getRwlockDatatype());
        final Expression lastReader = expressions.makeEQ(oldValueRegister, two);
        final Expression properDecrement = expressions.makeITE(lastReader, two, one);
        //TODO does not recognize whether the calling thread is allowed to unlock
        return List.of(
                // decreases the lock value by 1, if not the last reader, or else 2.
                EventFactory.Llvm.newRMW(oldValueRegister, lockAddress, decrement, IntBinaryOp.SUB, Tag.C11.MO_RELEASE),
                EventFactory.newAssume(expressions.makeEQ(decrement, properDecrement)),
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
                    EventFactory.newStore(attrAddress, expressions.makeValue(init)),
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
        final Expression totalSize = call.getArguments().get(0);
        return List.of(
                EventFactory.newAlloc(resultRegister, TypeFactory.getInstance().getByteType(), totalSize, true)
        );
    }

    private List<Event> inlineCalloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression elementCount = call.getArguments().get(0);
        final Expression elementSize = call.getArguments().get(1);
        final Expression totalSize = expressions.makeMUL(elementCount, elementSize);
        return List.of(
                EventFactory.newAlloc(resultRegister, TypeFactory.getInstance().getByteType(), totalSize, true)
        );
    }

    private List<Event> inlineAssert(FunctionCall call, AssertionType skip, String errorMsg) {
        if(notToInline.contains(skip)) {
            return List.of();
        }
        final Expression condition = expressions.makeFalse();
        final Event assertion = EventFactory.newAssert(condition, errorMsg);
        final Event abort = EventFactory.newAbortIf(expressions.makeTrue());
        abort.addTags(Tag.EARLYTERMINATION);
        return List.of(assertion, abort);
    }

    private List<Event> inlineUserAssert(FunctionCall call) {
        return inlineAssert(call, AssertionType.USER, "user assertion");
    }

    private List<Event> inlineIntegerOverflow(FunctionCall call) {
        return inlineAssert(call, AssertionType.OVERFLOW, "integer overflow");
    }

    private List<Event> inlineInvalidDereference(FunctionCall call) {
        return inlineAssert(call, AssertionType.INVALIDDEREF, "invalid dereference");
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
        } else if (name.contains("sadd.with.overflow")) {
            return inlineLLVMSAddWithOverflow(valueCall);
        } else if (name.contains("ssub.with.overflow")) {
            return inlineLLVMSSubWithOverflow(valueCall);
        } else if (name.contains("smul.with.overflow")) {
            return inlineLLVMSMulWithOverflow(valueCall);
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
        final boolean isMax = name.startsWith("llvm.smax.") || name.startsWith("llvm.umax.");
        final Expression isLess = expressions.makeLT(left, right, signed);
        final Expression result = expressions.makeITE(isLess, isMax ? right : left, isMax ? left : right);
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
                    EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                    EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeSUB(x, y), resultReg))
            );
        } else {
            final Expression noUnderflow = expressions.makeGT(x, y, false);
            final Expression zero = expressions.makeZero(type);
            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeITE(noUnderflow, expressions.makeSUB(x, y), zero))
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
                EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeADD(x, y), resultReg))
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
        final Expression result = expressions.makeBinary(x, op, y);
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
        final Expression bvCheck = expressions.makeEQ(expressions.makeBinary(xExt, op, yExt), resultExt);

        final Expression flag = expressions.makeCast(
                expressions.makeNot(expressions.makeAnd(bvCheck, rangeCheck)),
                types.getIntegerType(1)
        );

        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeConstruct(List.of(result, flag)))
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

        final String mo;
        final IntBinaryOp op;
        final List<Event> result = new ArrayList<>();
        switch (call.getCalledFunction().getName()) {
            case "__LKMM_LOAD" -> {
                checkArgument(p1 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p1).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMLoad(reg, p0, mo));
            }
            case "__LKMM_STORE" -> {
                checkArgument(p2 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p2).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMStore(p0, p1, mo.equals(Tag.Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo));
                if (mo.equals(Tag.Linux.MO_MB)) {
                    result.add(EventFactory.Linux.newMemoryBarrier());
                }
            }
            case "__LKMM_XCHG" -> {
                checkArgument(p2 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWExchange(p0, reg, p1, mo));
            }
            case "__LKMM_CMPXCHG" -> {
                checkArgument(p3 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWCompareExchange(p0, reg, p1, p2, mo));
            }
            case "__LKMM_ATOMIC_FETCH_OP" -> {
                checkArgument(p2 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p2).getValueAsInt());
                checkArgument(p3 instanceof IntLiteral, "No support for variable operator.");
                op = IntBinaryOp.intToOp(((IntLiteral) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWFetchOp(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP_RETURN" -> {
                checkArgument(p2 instanceof IntLiteral, "No support for variable memory order.");
                mo = Tag.Linux.intToMo(((IntLiteral) p2).getValueAsInt());
                checkArgument(p3 instanceof IntLiteral, "No support for variable operator.");
                op = IntBinaryOp.intToOp(((IntLiteral) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOpReturn(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP" -> {
                checkArgument(p2 instanceof IntLiteral, "No support for variable operator.");
                op = IntBinaryOp.intToOp(((IntLiteral) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOp(p0, p1, op));
            }
            case "__LKMM_FENCE" -> {
                String fence = Tag.Linux.intToMo(((IntLiteral) p0).getValueAsInt());
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
            var nondeterministicExpression = new NonDetBool(booleanType);
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
        var expression = new NonDetInt(constantId++, type, signed);
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

        if (!(countExpr instanceof IntLiteral countValue)) {
            final String error = "Cannot handle memcpy with dynamic count argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = countValue.getValueAsInt();

        final List<Event> replacement = new ArrayList<>(2 * count + 1);
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(i, types.getArchType());
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

        if (!(numExpr instanceof IntLiteral numValue)) {
            final String error = "Cannot handle memcmp with dynamic num argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = numValue.getValueAsInt();

        final List<Event> replacement = new ArrayList<>(4 * count + 1);
        final Label endCmp = EventFactory.newLabel("__memcmp_end");
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(i, types.getArchType());
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

        if (!(countExpr instanceof IntLiteral countValue)) {
            final String error = "Cannot handle memset with dynamic count argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        if (!(fillExpr instanceof IntLiteral fillValue && fillValue.isZero())) {
            //FIXME: We can soundly handle only 0 (and possibly -1) because the concatenation of
            // byte-sized 0's results in 0's of larger types. This makes the value robust against mixed-sized accesses.
            final String error = "Cannot handle memset with non-zero fill argument: " + call;
            throw new UnsupportedOperationException(error);
        }
        final int count = countValue.getValueAsInt();
        final int fill = fillValue.getValueAsInt();
        assert fill == 0;

        final Expression zero = expressions.makeValue(fill, types.getByteType());
        final List<Event> replacement = new ArrayList<>( count + 1);
        for (int i = 0; i < count; i++) {
            final Expression offset = expressions.makeValue(i, types.getArchType());
            final Expression destAddr = expressions.makeADD(dest, offset);

            replacement.add(EventFactory.newStore(destAddr, zero));
        }
        if (call instanceof ValueFunctionCall valueCall) {
            // std.memset returns the destination address, llvm.memset has no return value
            replacement.add(EventFactory.newLocal(valueCall.getResultRegister(), dest));
        }

        return replacement;
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
