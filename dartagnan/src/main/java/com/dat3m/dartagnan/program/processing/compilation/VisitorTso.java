package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.EventFactory.X86;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicAbstract;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicCmpXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicFetchOp;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicLoad;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicThreadFence;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.Dat3mCAS;
import com.dat3m.dartagnan.program.event.lang.linux.RMWAbstract;
import com.dat3m.dartagnan.program.event.lang.linux.RMWAddUnless;
import com.dat3m.dartagnan.program.event.lang.linux.RMWCmpXchg;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpAndTest;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpReturn;
import com.dat3m.dartagnan.program.event.lang.linux.RMWXchg;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.common.configuration.Options;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newGoto;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static com.dat3m.dartagnan.program.event.EventFactory.newJumpUnless;
import static com.dat3m.dartagnan.program.event.EventFactory.newLabel;
import static com.dat3m.dartagnan.program.event.EventFactory.newLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStore;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.processing.compilation.Compilation.commonVisitLock;
import static com.dat3m.dartagnan.program.processing.compilation.Compilation.commonVisitUnlock;

@Options
public class VisitorTso implements EventVisitor<List<Event>> {

	protected VisitorTso() {}

	@Override
	public List<Event> visitEvent(Event e) {
		return Collections.singletonList(e);
	};

	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
        store.addFilters(C11.PTHREAD);
        
        return eventSequence(
                store,
                X86.newMemoryFence()
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		newStore(e.getAddress(), IConst.ZERO, e.getMo()),
                X86.newMemoryFence()
        );
	}

	@Override
	public List<Event> visitInitLock(InitLock e) {
		return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), e.getMo())
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
        		load,
        		newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel())
        );
	}

	@Override
	public List<Event> visitLock(Lock e) {
		return commonVisitLock(e);
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();

        return eventSequence(
        		newLoad(resultRegister, e.getAddress(), e.getMo()),
        		newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel())
        );
	}

	@Override
	public List<Event> visitUnlock(Unlock e) {
		return commonVisitUnlock(e);
	}

	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};

	@Override
	public List<Event> visitRMWAbstract(RMWAbstract e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};
	
	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	};

	@Override
	public List<Event> visitXchg(Xchg e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();

        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
		Load load = newRMWLoad(dummyReg, address, null);
        load.addFilters(Tag.TSO.ATOM);

        RMWStore store = newRMWStore(load, address, resultRegister, null);
        store.addFilters(Tag.TSO.ATOM);

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummyReg)
        );
	}

	@Override
	public List<Event> visitAtomicAbstract(AtomicAbstract e) {
		throw new IllegalArgumentException("Compilation to " + TSO + " is not supported for " + e.getClass().getName());
	}

	@Override
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
        int threadId = resultRegister.getThreadId();
		int precision = resultRegister.getPrecision();

		List<Event> events;

		Register regExpected = new Register(null, threadId, precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Register regValue = new Register(null, threadId, precision);
        Load loadValue = newRMWLoad(regValue, address, mo);
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        Label casFail = newLabel("CAS_fail");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
        Store storeValue = newRMWStore(loadValue, address, value, mo);
        Label casEnd = newLabel("CAS_end");
        CondJump gotoCasEnd = newGoto(casEnd);
        Store storeExpected = newStore(expectedAddr, regValue, null);

        events = eventSequence(
                // Indentation shows the branching structure
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                    storeValue,
                    gotoCasEnd,
                casFail,
                    storeExpected,
                casEnd
        );

        return events;
	}

	@Override
	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, mo);
        
        return eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, e.getOp(), (IExpr)e.getMemValue())),
                newRMWStore(load, address, dummyReg, mo)
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), e.getMo())
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();

        Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

        return eventSequence(
        		newStore(e.getAddress(), e.getMemValue(), mo),
                optionalMFence
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;
        
        return eventSequence(
        		optionalFence
        );
	}

	@Override
	public List<Event> visitAtomicXchg(AtomicXchg e) {
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoad(e.getResultRegister(), address, mo);

        return eventSequence(
                load,
                newRMWStore(load, address, e.getMemValue(), mo)
        );
	}

	@Override
	public List<Event> visitDat3mCAS(Dat3mCAS e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, e.getExpectedValue()));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);
        Load load = newRMWLoad(regValue, address, mo);
        Store store = newRMWStore(load, address, e.getMemValue(), mo);

        return eventSequence(
                // Indentation shows the branching structure
                load,
                casCmpResult,
                branchOnCasCmpResult,
                    store,
                casEnd
        );
	}
}