package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
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

public class IntrinsicsInsertion implements FunctionProcessor {

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    private IntrinsicsInsertion() {}

    public static IntrinsicsInsertion newInstance() {
        return new IntrinsicsInsertion();
    }

    @Override
    public void run(Function function) {
        currentAtomicBegin = null;
        for (final DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            final List<Event> replacement;
            if (isLKMMIntrinsic(call)) {
                replacement = handleLKMMIntrinsic(call);
            } else {
                replacement = switch (call.getCallTarget().getName()) {
                    case "__VERIFIER_loop_begin" -> inlineLoopBegin(call);
                    case "__VERIFIER_loop_bound" -> inlineLoopBound(call);
                    case "__VERIFIER_spin_start" -> inlineSpinStart(call);
                    case "__VERIFIER_spin_end" -> inlineSpinEnd(call);
                    case "__VERIFIER_atomic_begin" -> inlineAtomicBegin(call);
                    case "__VERIFIER_atomic_end" -> inlineAtomicEnd(call);
                    case "pthread_mutex_init" -> inlinePthreadMutexInit(call);
                    case "pthread_mutex_lock" -> inlinePthreadMutexLock(call);
                    case "pthread_mutex_unlock" -> inlinePthreadMutexUnlock(call);
                    case "exit" -> inlineExit(call);
                    case "printf" -> List.of();
                    default -> List.of(call);
                };
            }

            if (replacement.isEmpty()) {
                call.tryDelete();
            } else if (replacement.get(0) != call) {
                call.replaceBy(replacement);
                replacement.forEach(e -> e.copyAllMetadataFrom(call));
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
