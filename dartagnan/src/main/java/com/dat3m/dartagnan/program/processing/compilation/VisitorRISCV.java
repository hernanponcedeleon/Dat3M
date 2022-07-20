package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.RISCV;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.riscv.AmoOp;
import com.dat3m.dartagnan.program.event.arch.riscv.AmoSwap;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newExecutionStatus;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStore;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;

import java.util.List;

class VisitorRISCV extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorRISCV() {}

	@Override
	public List<Event> visitAmoOp(AmoOp e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();
		
        Load load = newRMWLoad(resultRegister, address, mo);
		load.addFilters(RISCV.AMO);
		
        RMWStore store = newRMWStore(load, address, new IExprBin(resultRegister, e.getOp(), e.getOperand()), mo);
        store.addFilters(RISCV.AMO);
        
		return eventSequence(
                load,
                store
        );
	}
	
	@Override
	public List<Event> visitAmoSwap(AmoSwap e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();
		
        Load load = newRMWLoad(resultRegister, address, mo);
		load.addFilters(RISCV.AMO);
		
        RMWStore store = newRMWStore(load, address, e.getValue(), mo);
        store.addFilters(RISCV.AMO);
        
		return eventSequence(
                load,
                store
        );
	}
	
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