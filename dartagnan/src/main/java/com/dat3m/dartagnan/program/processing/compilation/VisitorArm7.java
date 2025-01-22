package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;

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
                AArch64.DMB.newISHBarrier()
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return eventSequence(
                AArch64.DMB.newISHBarrier(),
                newStore(e.getAddress(), e.getMemValue())
        );
    }

}
