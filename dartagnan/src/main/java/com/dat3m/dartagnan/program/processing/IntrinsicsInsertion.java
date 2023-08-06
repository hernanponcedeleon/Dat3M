package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public class IntrinsicsInsertion implements ProgramProcessor {

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    private BeginAtomic currentAtomicBegin;

    private IntrinsicsInsertion() {}

    public static IntrinsicsInsertion newInstance() {
        return new IntrinsicsInsertion();
    }

    @Override
    public void run(Program program) {
        for (final Function thread : program.getThreads()) {
            run(thread);
        }
        for (final Function function : program.getFunctions()) {
            run(function);
        }
    }

    private void run(Function function) {
        currentAtomicBegin = null;
        for (final DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            Event replacement = switch (call.getCallTarget().getName()) {
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
                case "printf" -> null;
                default -> call;
            };

            if (replacement == null) {
                call.tryDelete();
            } else if (call != replacement) {
                call.replaceBy(replacement);
                replacement.copyAllMetadataFrom(call);
            }
        }
    }

    private Event inlineExit(DirectFunctionCall ignored) {
        return EventFactory.newAbortIf(ExpressionFactory.getInstance().makeTrue());
    }

    private Event inlineLoopBegin(DirectFunctionCall ignored) {
        return EventFactory.Svcomp.newLoopBegin();
    }

    private Event inlineLoopBound(DirectFunctionCall call) {
        final Expression boundExpression = call.getArguments().get(0);
        if (!(boundExpression instanceof IValue value)) {
            throw new MalformedProgramException("Non-constant bound for loop.");
        }
        return EventFactory.Svcomp.newLoopBound(value.getValueAsInt());
    }

    private Event inlineSpinStart(DirectFunctionCall ignored) {
        return EventFactory.Svcomp.newSpinStart();
    }

    private Event inlineSpinEnd(DirectFunctionCall ignored) {
        return EventFactory.Svcomp.newSpinEnd();
    }

    private Event inlineAtomicBegin(DirectFunctionCall ignored) {
        return currentAtomicBegin = EventFactory.Svcomp.newBeginAtomic();
    }

    private Event inlineAtomicEnd(DirectFunctionCall ignored) {
        return EventFactory.Svcomp.newEndAtomic(checkNotNull(currentAtomicBegin));
    }

    private Event inlinePthreadMutexInit(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 2);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression lockValue = call.getArguments().get(1);
        final String lockName = lockAddress.toString();
        return EventFactory.Pthread.newInitLock(lockName, lockAddress, lockValue);
    }

    private Event inlinePthreadMutexLock(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return EventFactory.Pthread.newLock(lockName, lockAddress);
    }

    private Event inlinePthreadMutexUnlock(DirectFunctionCall call) {
        checkArgument(call.getArguments().size() == 1);
        final Expression lockAddress = call.getArguments().get(0);
        final String lockName = lockAddress.toString();
        return EventFactory.Pthread.newUnlock(lockName, lockAddress);
    }
}
