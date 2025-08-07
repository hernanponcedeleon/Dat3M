package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMFetchOp;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorArm7 extends VisitorBase {

    protected VisitorArm7() {}

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = newRMWStoreExclusiveWithMo(e.getAddress(), e.getMemValue(), false, e.getMo());

        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
        );
    }

    // This is the minimal required support to properly handle pthread_create and pthread_join
    // The rest of the synchronization is expected to be done via inline asm.

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
                newLoad(e.getResultRegister(), e.getAddress()),
                isAtomicAcquire(e.getMo()) ? AArch64.DMB.newISHBarrier() : null
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return eventSequence(
                isAtomicRelease(e.getMo()) ? AArch64.DMB.newISHBarrier() : null,
                newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        final Expression value = expressions.makeIntBinary(e.getResultRegister(), e.getOperator(), e.getOperand());
        final Load load = newRMWLoad(e.getResultRegister(), e.getAddress());
        return eventSequence(
                load,
                isAtomicAcquire(e.getMo()) || isAtomicRelease(e.getMo()) ? AArch64.DMB.newISHBarrier() : null,
                newRMWStore(load, e.getAddress(), value)
        );
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        final Expression value = expressions.makeIntBinary(e.getResultRegister(), e.getOperator(), e.getOperand());
        final Load load = newRMWLoad(e.getResultRegister(), e.getAddress());
        return eventSequence(
                load,
                isAtomicAcquire(e.getMo()) || isAtomicRelease(e.getMo()) ? AArch64.DMB.newISHBarrier() : null,
                newRMWStore(load, e.getAddress(), value)
        );
    }

    private boolean isAtomicAcquire(String mo) {
        return switch (mo) {
            case Tag.C11.MO_ACQUIRE -> true;
            case Tag.C11.MO_RELEASE, Tag.C11.MO_RELAXED -> false;
            default -> throw new UnsupportedOperationException("Unsupported memory order");
        };
    }

    private boolean isAtomicRelease(String mo) {
        return switch (mo) {
            case Tag.C11.MO_RELEASE -> true;
            case Tag.C11.MO_ACQUIRE, Tag.C11.MO_RELAXED -> false;
            default -> throw new UnsupportedOperationException("Unsupported memory order");
        };
    }
}
