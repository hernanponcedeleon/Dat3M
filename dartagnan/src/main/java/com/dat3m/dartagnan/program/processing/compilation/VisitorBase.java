package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.*;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicAbstract;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

class VisitorBase implements EventVisitor<List<Event>> {

	protected boolean forceStart;

	protected VisitorBase(boolean forceStart) {
		this.forceStart = forceStart;
	}
	
	@Override
	public List<Event> visitEvent(Event e) {
		return Collections.singletonList(e);
	};

	@Override
	public List<Event> visitCondJump(CondJump e) {
    	Preconditions.checkState(e.getSuccessor() != null, "Malformed CondJump event");
		return visitEvent(e);
	};

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Register statusRegister = e.getThread().newRegister(resultRegister.getPrecision());

        return eventSequence(
                forceStart ? newExecutionStatus(statusRegister, e.getCreationEvent()) : null,
                forceStart ? newAssume(new BExprBin(resultRegister, BOpBin.OR, statusRegister)) : null
        );
	}
	
	@Override
	public List<Event> visitInitLock(InitLock e) {
		return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), e.getMo())
        );
	}

	@Override
    public List<Event> visitLock(Lock e) {
        Register resultRegister = e.getResultRegister();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, e.getAddress(), mo),
                newJump(new Atom(resultRegister, NEQ, IValue.ZERO), (Label) e.getThread().getExit()),
                newStore(e.getAddress(), IValue.ONE, mo)
        );
        
		for(Event child : events) {
            child.addFilters(C11.LOCK, RMW);
        }
        
		return events;
    }
    
    @Override
	public List<Event> visitUnlock(Unlock e) {
        Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
		List<Event> events = eventSequence(
                newLoad(resultRegister, address, mo),
                newJump(new Atom(resultRegister, NEQ, IValue.ONE), (Label) e.getThread().getExit()),
                newStore(address, IValue.ZERO, mo)
        );
        
		for(Event child : events) {
            child.addFilters(C11.LOCK, RMW);
        }
        
		return events;
	}

    @Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};

	@Override
	public List<Event> visitRMWAbstract(RMWAbstract e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};

	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	};

	@Override
	public List<Event> visitXchg(Xchg e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	}

	@Override
	public List<Event> visitRMW(RMW e) {
        Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
		Load load = newRMWLoad(dummyReg, address, mo);
        RMWStore store = newRMWStore(load, address, e.getMemValue(), mo);
		return eventSequence(
        		load,
                store,
                newLocal(resultRegister, dummyReg)
        );
	}
	
	@Override
	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
		throw new IllegalArgumentException("Compilation for " + e.getClass().getName() + " is not supported by " + getClass().getName());
	}
}