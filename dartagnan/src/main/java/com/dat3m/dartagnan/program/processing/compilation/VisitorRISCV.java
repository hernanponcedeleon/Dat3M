package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.core.rmw.StoreExclusive;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newExecutionStatus;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;

import java.util.List;

class VisitorRISCV extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorRISCV() {}
	
	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());
        store.addFilters(Tag.RISCV.STCOND);

        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
        );
	}

}