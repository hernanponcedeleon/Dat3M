package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.google.common.collect.ImmutableList;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
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

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    // TODO: This id should be part of Program
    private int constantId;
    private int assertionId;

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

    public record Info(
            String groupName, // Can end with a "*", in which case the variants are treated as prefixes
            List<String> variants,
            boolean writesMemory,
            boolean readsMemory,
            boolean alwaysReturns,
            boolean isEarly,
            Replacer replacer) {
        public Info(String name, boolean writesMemory, boolean readsMemory, boolean alwaysReturns, boolean isEarly,
                Replacer replacer) {
            this(name, List.of(name), writesMemory, readsMemory, alwaysReturns, isEarly, replacer);
        }

        public void replace(DirectFunctionCall call) {
            if (replacer == null) {
                throw new MalformedProgramException(
                        String.format("Intrinsic \"%s\" without replacer", call.getCallTarget().getName()));
            }
            final List<Event> replacement = replacer.replace(call);
            if (replacement.isEmpty()) {
                call.tryDelete();
            } else if (replacement.get(0) != call) {
                call.replaceBy(replacement);
                replacement.forEach(e -> e.copyAllMetadataFrom(call));
            }
        }

        private boolean matches(String funcName) {
            BiPredicate<String, String> matchingFunction = groupName.endsWith("*") ? String::startsWith : String::equals;
            return variants.stream().anyMatch(v -> matchingFunction.test(funcName, v));
        }
    }

    @FunctionalInterface
    private interface Replacer {
        List<Event> replace(DirectFunctionCall call);
    }

    private final List<Info> INTRINSICS = ImmutableList.copyOf(List.of(
            // --------------------------- pthread threading ---------------------------
            new Info("pthread_create", true, false, true, false, null),
            new Info("pthread_exit", false, false, false, false, null),
            new Info("pthread_join",
                    List.of("pthread_join", "__pthread_join", "\"\\01_pthread_join\""),
                    false, true, false, false, null),
            // --------------------------- pthread mutex ---------------------------
            new Info("pthread_mutex_init", true, false, true, true, this::inlinePthreadMutexInit),
            new Info("pthread_mutex_lock", true, true, false, true, this::inlinePthreadMutexLock),
            new Info("pthread_mutex_unlock", true, false, true, true, this::inlinePthreadMutexUnlock),
            new Info("pthread_mutex_destroy", true, false, true, true, this::inlinePthreadMutexDestroy),
            // --------------------------- SVCOMP ---------------------------
            new Info("__VERIFIER_atomic_begin", false, false, true, true, this::inlineAtomicBegin),
            new Info("__VERIFIER_atomic_end", false, false, true, true, this::inlineAtomicEnd),
            // --------------------------- __VERIFIER ---------------------------
            new Info("__VERIFIER_loop_begin", false, false, true, true, this::inlineLoopBegin),
            new Info("__VERIFIER_loop_bound", false, false, true, true, this::inlineLoopBound),
            new Info("__VERIFIER_spin_start", false, false, true, true, this::inlineSpinStart),
            new Info("__VERIFIER_spin_end", false, false, true, true, this::inlineSpinEnd),
            new Info("__VERIFIER_assume", false, false, true, true, this::inlineAssume),
            new Info("__VERIFIER_assert", false, false, false, false, this::inlineAssert),
            new Info("__VERIFIER_nondet",
                    List.of("__VERIFIER_nondet_bool",
                            "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                            "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                            "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                            "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar"),
                    false, false, true, false, this::inlineNonDet),
            // --------------------------- LLVM ---------------------------
            new Info("llvm.*",
                    List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin", "llvm.ctlz"),
                    false, false, true, true, this::handleLLVMIntrinsic),
            // --------------------------- LKMM ---------------------------
            new Info("__LKMM_LOAD", false, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_STORE", true, false, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_XCHG", true, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_CMPXCHG", true, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_ATOMIC_FETCH_OP", true, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_ATOMIC_OP", true, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_ATOMIC_OP_RETURN", true, true, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_SPIN_LOCK", true, true, false, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_SPIN_UNLOCK", true, false, true, true, this::handleLKMMIntrinsic),
            new Info("__LKMM_FENCE", false, false, false, true, this::handleLKMMIntrinsic),
            // --------------------------- Misc ---------------------------
            new Info("malloc", false, false, true, true, this::inlineMalloc),
            new Info("free", true, false, true, true, e -> List.of()),//TODO support free
            new Info("assert", List.of("__assert_fail", "__assert_rtn"),
                    false, false, false, false, this::inlineAssert),
            new Info("exit", false, false, false, true, this::inlineExit),
            new Info("abort", false, false, false, true, this::inlineExit),
            new Info("printf", false, false, true, true, e -> List.of()),
            new Info("puts", false, false, true, true, e -> List.of())
    ));

    private void markIntrinsics(Program program) {
        TypeFactory types = TypeFactory.getInstance();
        // used by VisitorLKMM
        program.declareFunction(
                "__VERIFIER_nondet_bool",
                types.getFunctionType(types.getBooleanType(), List.of()),
                List.of());

        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                final Info intrinsicsInfo = INTRINSICS.stream()
                        .filter(info -> info.matches(funcName))
                        .findFirst()
                        .orElseThrow(() -> new UnsupportedOperationException("Unknown intrinsic function " + funcName));
                func.setIntrinsicInfo(intrinsicsInfo);
            }
        }
    }

    // --------------------------------------------------------------------------------------------------------
    // Simple early intrinsics

    private void inlineEarly(Function function) {
        for (final DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            final Intrinsics.Info info = call.getCallTarget().getIntrinsicInfo();
            if (info != null && info.isEarly()) {
                info.replace(call);
            }
        }
    }

    private List<Event> inlineExit(DirectFunctionCall ignored) {
        return List.of(EventFactory.newAbortIf(ExpressionFactory.getInstance().makeTrue()));
    }

    private List<Event> inlineLoopBegin(DirectFunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newLoopBegin());
    }

    private List<Event> inlineLoopBound(DirectFunctionCall call) {
        final Expression boundExpression = call.getArguments().get(0);
        if (!(boundExpression instanceof IValue value)) {
            throw new MalformedProgramException("Non-constant bound for loop.");
        }
        return List.of(EventFactory.Svcomp.newLoopBound(value.getValueAsInt()));
    }

    private List<Event> inlineSpinStart(DirectFunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newSpinStart());
    }

    private List<Event> inlineSpinEnd(DirectFunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newSpinEnd());
    }

    private List<Event> inlineAssume(DirectFunctionCall call) {
        final Expression assumption = call.getArguments().get(0);
        return List.of(EventFactory.newAssume(assumption));
    }

    private List<Event> inlineAtomicBegin(DirectFunctionCall ignored) {
        return List.of(currentAtomicBegin = EventFactory.Svcomp.newBeginAtomic());
    }

    private List<Event> inlineAtomicEnd(DirectFunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newEndAtomic(checkNotNull(currentAtomicBegin)));
    }

    private List<Event> inlinePthreadMutexInit(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 2);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression lockValue = call.getArguments().get(1);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newInitLock(lockName, lockAddress, lockValue));
    }

    private List<Event> inlinePthreadMutexDestroy(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Register reg = ((DirectValueFunctionCall) call).getResultRegister();
        return List.of(EventFactory.newLocal(reg, expressions.makeZero((IntegerType) reg.getType())));
    }

    private List<Event> inlinePthreadMutexLock(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newLock(lockName, lockAddress));
    }

    private List<Event> inlinePthreadMutexUnlock(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return List.of(EventFactory.Pthread.newUnlock(lockName, lockAddress));
    }

    private List<Event> inlineMalloc(DirectFunctionCall call) {
        if (call.getArguments().size() != 1) {
            throw new UnsupportedOperationException(String.format("Unsupported signature for %s.", call));
        }
        final DirectValueFunctionCall valueCall = (DirectValueFunctionCall) call;
        return List.of(EventFactory.Std.newMalloc(valueCall.getResultRegister(), valueCall.getArguments().get(0)));
    }

    // --------------------------------------------------------------------------------------------------------
    // LLVM intrinsics

    private List<Event> handleLLVMIntrinsic(DirectFunctionCall call) {
        assert call instanceof DirectValueFunctionCall;
        final DirectValueFunctionCall valueCall = (DirectValueFunctionCall) call;
        final String name = call.getCallTarget().getName();

        if (name.startsWith("llvm.ctlz")) {
            return inlineLLVMCtlz(valueCall);
        } else if (name.startsWith("llvm.smax") || name.startsWith("llvm.smin")
                || name.startsWith("llvm.umax") || name.startsWith("llvm.umin")) {
            return inlineLLVMMinMax(valueCall);
        } else {
            final String error = String.format(
                    "Call %s to LLVM intrinsic %s cannot be handled.", call, call.getCallTarget());
            throw new UnsupportedOperationException(error);
        }
    }

    private List<Event> inlineLLVMCtlz(DirectValueFunctionCall call) {
        // TODO: Handle the second parameter as well
        final Expression input = call.getArguments().get(0);
        final Expression result = expressions.makeCTLZ(input, (IntegerType) call.getResultRegister().getType());
        return List.of(EventFactory.newLocal(call.getResultRegister(), result));
    }

    private List<Event> inlineLLVMMinMax(DirectValueFunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        final Expression left = arguments.get(0);
        final Expression right = arguments.get(1);
        final String name = call.getCallTarget().getName();
        final boolean signed = name.startsWith("llvm.smax.") || name.startsWith("llvm.smin.");
        final boolean isMax = name.startsWith("llvm.smax.") || name.startsWith("llvm.umax.");
        final Expression isLess = expressions.makeLT(left, right, signed);
        final Expression result = expressions.makeConditional(isLess, isMax ? right : left, isMax ? left : right);
        return List.of(EventFactory.newLocal(call.getResultRegister(), result));
    }

    // --------------------------------------------------------------------------------------------------------
    // LKMM intrinsics

    private List<Event> handleLKMMIntrinsic(DirectFunctionCall call) {
        final Register reg = (call instanceof DirectValueFunctionCall valueCall) ? valueCall.getResultRegister() : null;
        final List<Expression> args = call.getArguments();

        final Expression p0 = args.get(0);
        final Expression p1 = args.size() > 1 ? args.get(1) : null;
        final Expression p2 = args.size() > 2 ? args.get(2) : null;
        final Expression p3 = args.size() > 3 ? args.get(3) : null;

        final String mo;
        final IOpBin op;
        final List<Event> result = new ArrayList<>();
        switch (call.getCallTarget().getName()) {
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
        for (DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            assert !call.getCallTarget().hasBody();

            final List<Event> replacement = switch (call.getCallTarget().getName()) {
                case "__VERIFIER_nondet_bool",
                        "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                        "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                        "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                        "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar" -> inlineNonDet(call);
                case "__assert_fail", "__assert_rtn" -> inlineAssert(call);
                default -> throw new UnsupportedOperationException(
                        String.format("Undefined function %s", call.getCallTarget().getName()));
            };

            replacement.forEach(e -> e.copyAllMetadataFrom(call));
            call.replaceBy(replacement);
        }
    }

    private List<Event> inlineNonDet(DirectFunctionCall call) {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        assert call instanceof DirectValueFunctionCall;
        Register register = ((DirectValueFunctionCall) call).getResultRegister();
        String name = call.getCallTarget().getName();
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

    private List<Event> inlineAssert(DirectFunctionCall call) {
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        final Expression condition = expressions.makeFalse();
        final Register register = call.getFunction().getOrNewRegister("assert_" + assertionId++, condition.getType());
        final Event endOfThread = call.getFunction().getExit();
        assert endOfThread instanceof Label;
        final Event flag = EventFactory.newLocal(register, condition);
        flag.addTags(Tag.ASSERTION);
        final Event jump = EventFactory.newGoto((Label) endOfThread);
        jump.addTags(Tag.EARLYTERMINATION);
        return List.of(flag, jump);
    }
}
