package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
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
import java.util.function.BiPredicate;

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
        // --------------------------- pthread mutex ---------------------------
        P_THREAD_MUTEX_INIT("pthread_mutex_init", true, false, true, true, Intrinsics::inlinePthreadMutexInit),
        P_THREAD_MUTEX_LOCK("pthread_mutex_lock", true, true, false, true, Intrinsics::inlinePthreadMutexLock),
        P_THREAD_MUTEX_UNLOCK("pthread_mutex_unlock", true, false, true, true, Intrinsics::inlinePthreadMutexUnlock),
        P_THREAD_MUTEX_DESTROY("pthread_mutex_destroy", true, false, true, true, Intrinsics::inlinePthreadMutexDestroy),
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
        LLVM_STACK(List.of("llvm.stacksave", "llvm.stackrestore"), false, false, true, true, Intrinsics::inlineAsZero),
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
        STD_MEMSET("memset", true, false, true, false, Intrinsics::inlineMemSet),
        STD_MEMCMP("memcmp", false, true, true, false, Intrinsics::inlineMemCmp),
        STD_MALLOC("malloc", false, false, true, true, Intrinsics::inlineMalloc),
        STD_FREE("free", true, false, true, true, Intrinsics::inlineAsZero),//TODO support free
        STD_ASSERT(List.of("__assert_fail", "__assert_rtn"), false, false, false, true, Intrinsics::inlineAssert),
        STD_EXIT("exit", false, false, false, true, Intrinsics::inlineExit),
        STD_ABORT("abort", false, false, false, true, Intrinsics::inlineExit),
        STD_IO(List.of("puts", "putchar", "printf"), false, false, true, true, Intrinsics::inlineAsZero),
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
                case LLVM, LLVM_ASSUME, LLVM_STACK, LLVM_MEMCPY, LLVM_MEMSET -> true;
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

        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                final Info intrinsicsInfo = Arrays.stream(Info.values())
                        .filter(info -> info.matches(funcName))
                        .findFirst()
                        .orElseThrow(() -> new UnsupportedOperationException("Unknown intrinsic function " + funcName));
                func.setIntrinsicInfo(intrinsicsInfo);
            }
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

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        checkArgument(call.getArguments().size() == 2);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression lockValue = call.getArguments().get(1);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newInitLock(lockName, lockAddress, lockValue));
    }

    private List<Event> inlinePthreadMutexDestroy(FunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Register reg = ((ValueFunctionCall) call).getResultRegister();
        return List.of(EventFactory.newLocal(reg, expressions.makeZero((IntegerType) reg.getType())));
    }

    private List<Event> inlinePthreadMutexLock(FunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newLock(lockName, lockAddress));
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newUnlock(lockName, lockAddress));
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
            throw new ParsingException(String.format("Non-integer result register %s.", register));
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

    // Handles both std.memset and llvm.memset
    private List<Event> inlineMemSet(FunctionCall call) {
        final Expression dest = call.getArguments().get(0);
        final Expression fillExpr = call.getArguments().get(1);
        final Expression countExpr = call.getArguments().get(2);
        // final Expression isVolatile = call.getArguments.get(3) // LLVM's memset has an extra argument

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

}
