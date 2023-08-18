package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/*
    This pass runs early in the processing chain and resolves intrinsics whose semantics
    can be captured by a sequence of other events.

    TODO: We could insert the definitions here directly into the function declarations of the intrinsics.
 */
public class EarlyIntrinsicsInlining implements FunctionProcessor {

    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    private EarlyIntrinsicsInlining() {}

    public static EarlyIntrinsicsInlining newInstance() {
        return new EarlyIntrinsicsInlining();
    }

    @Override
    public void run(Function function) {
        currentAtomicBegin = null;
        for (final DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            final List<Event> replacement;
            if (isLLVMIntrinsic(call)) {
                replacement = handleLLVMIntrinsic(call);
            } else if (isLKMMIntrinsic(call)) {
                replacement = handleLKMMIntrinsic(call);
            } else {
                replacement = handleDefaultIntrinsics(call);
            }

            if (replacement.isEmpty()) {
                call.tryDelete();
            } else if (replacement.get(0) != call) {
                call.replaceBy(replacement);
                replacement.forEach(e -> e.copyAllMetadataFrom(call));
            }
        }
    }

    private List<Event> handleDefaultIntrinsics(DirectFunctionCall call) {
        final List<Event> replacement;
        replacement = switch (call.getCallTarget().getName()) {
            case "__VERIFIER_loop_begin" -> inlineLoopBegin(call);
            case "__VERIFIER_loop_bound" -> inlineLoopBound(call);
            case "__VERIFIER_spin_start" -> inlineSpinStart(call);
            case "__VERIFIER_spin_end" -> inlineSpinEnd(call);
            case "__VERIFIER_atomic_begin" -> inlineAtomicBegin(call);
            case "__VERIFIER_atomic_end" -> inlineAtomicEnd(call);
            case "__VERIFIER_assume" -> inlineAssume(call);
            case "pthread_mutex_init" -> inlinePthreadMutexInit(call);
            case "pthread_mutex_lock" -> inlinePthreadMutexLock(call);
            case "pthread_mutex_unlock" -> inlinePthreadMutexUnlock(call);
            case "pthread_mutex_destroy" -> inlinePthreadMutexDestroy(call);
            case "exit", "abort" -> inlineExit(call);
            case "malloc" -> inlineMalloc(call);
            case "free" -> List.of(); // TODO add support for free
            case "printf", "puts" -> List.of();
            default -> List.of(call);
        };
        return replacement;
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

    private boolean isLLVMIntrinsic(DirectFunctionCall call) {
        return call.getCallTarget().getName().startsWith("llvm.");
    }

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

    private static final List<String> LKMMPROCEDURES = Arrays.asList(
            "__LKMM_LOAD",
            "__LKMM_STORE",
            "__LKMM_XCHG",
            "__LKMM_CMPXCHG",
            "__LKMM_ATOMIC_FETCH_OP",
            "__LKMM_ATOMIC_OP",
            "__LKMM_ATOMIC_OP_RETURN",
            "__LKMM_FENCE",
            "__LKMM_SPIN_LOCK",
            "__LKMM_SPIN_UNLOCK");

    private boolean isLKMMIntrinsic(DirectFunctionCall call) {
        return LKMMPROCEDURES.contains(call.getCallTarget().getName());
    }

    private List<Event> handleLKMMIntrinsic(DirectFunctionCall call) {
        final Register reg = (call instanceof DirectValueFunctionCall valueCall) ? valueCall.getResultRegister() : null;
        final List<Expression> args = call.getArguments();

        final Expression p0 = args.get(0);
        final Expression p1 = args.size() > 1 ? args.get(1) : null;
        final Expression p2 = args.size() > 2 ? args.get(2) : null;
        final Expression p3 = args.size() > 3 ? args.get(3) : null;

        String mo;
        IOpBin op;
        List<Event> result = new ArrayList<>();
        switch (call.getCallTarget().getName()) {
            case "__LKMM_LOAD" -> {
                mo = Tag.Linux.intToMo(((IConst) p1).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMLoad(reg, p0, mo));
            }
            case "__LKMM_STORE" -> {
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newLKMMStore(p0, p1, mo.equals(Tag.Linux.MO_MB) ? Tag.Linux.MO_ONCE : mo));
                if (mo.equals(Tag.Linux.MO_MB)) {
                    result.add(EventFactory.Linux.newMemoryBarrier());
                }
            }
            case "__LKMM_XCHG" -> {
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWExchange(p0, reg, p1, mo));
            }
            case "__LKMM_CMPXCHG" -> {
                mo = Tag.Linux.intToMo(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWCompareExchange(p0, reg, p1, p2, mo));
            }
            case "__LKMM_ATOMIC_FETCH_OP" -> {
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWFetchOp(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP_RETURN" -> {
                mo = Tag.Linux.intToMo(((IConst) p2).getValueAsInt());
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOpReturn(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP" -> {
                op = IOpBin.intToOp(((IConst) p2).getValueAsInt());
                result.add(EventFactory.Linux.newRMWOp( p0, p1, op));
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
}
