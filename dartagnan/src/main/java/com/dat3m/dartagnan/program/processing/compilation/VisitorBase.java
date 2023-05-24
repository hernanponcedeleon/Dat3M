package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicAbstract;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmAbstractRMW;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.google.common.base.Preconditions;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorBase implements EventVisitor<List<Event>> {

	protected boolean forceStart;
	protected static final TypeFactory types = TypeFactory.getInstance();
	protected static final Type archType = types.getPointerType();
	protected final ExpressionFactory expressions = ExpressionFactory.getInstance();
	protected final Literal zero = expressions.makeZero(types.getPointerType());
	protected final Literal one = expressions.makeOne(types.getPointerType());

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
        Register statusRegister = e.getThread().newRegister(resultRegister.getType());

        return eventSequence(
                forceStart ? newExecutionStatus(statusRegister, e.getCreationEvent()) : null,
                forceStart ? newAssume(expressions.makeOr(resultRegister, statusRegister)) : null
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
		Literal zero = expressions.makeZero(resultRegister.getType());
		String mo = e.getMo();

		Load rmwLoad = newRMWLoad(resultRegister, e.getAddress(), mo);
		return eventSequence(
                rmwLoad,
                newJump(expressions.makeBinary(resultRegister, NEQ, zero), (Label) e.getThread().getExit()),
                newRMWStore(rmwLoad, e.getAddress(), one, mo)
        );
    }
    
    @Override
	public List<Event> visitUnlock(Unlock e) {
        Register resultRegister = e.getResultRegister();
		Expression one = expressions.makeOne(resultRegister.getType());
		Expression address = e.getAddress();
		String mo = e.getMo();

		Load rmwLoad = newRMWLoad(resultRegister, address, mo);
		return eventSequence(
                rmwLoad,
                newJump(expressions.makeBinary(resultRegister, NEQ, one), (Label) e.getThread().getExit()),
                newRMWStore(rmwLoad, address, zero, mo)
        );
	}

	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWAbstract(RMWAbstract e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		throw error(e);

	};

	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		throw error(e);

	};

	@Override
	public List<Event> visitXchg(Xchg e) {
		throw error(e);

	}

	@Override
	public List<Event> visitRMW(RMW e) {
        Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		String mo = e.getMo();
        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
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
		throw error(e);

	}

	// LLVM Events
	@Override
	public List<Event> visitLlvmAbstract(LlvmAbstractRMW e) {
		throw error(e);

	}

	@Override
	public List<Event> visitLlvmLoad(LlvmLoad e) {
		throw error(e);

	}

	@Override
	public List<Event> visitLlvmStore(LlvmStore e) {
		throw error(e);
	}

	private IllegalArgumentException error(Event e) {
		return new IllegalArgumentException("Compilation for " + e.getClass().getSimpleName() +
				" is not supported by " + getClass().getSimpleName());
	}

}