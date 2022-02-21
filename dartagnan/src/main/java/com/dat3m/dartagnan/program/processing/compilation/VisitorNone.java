package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.math.BigInteger;
import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorNone extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorNone() {}
	
	@Override
	public List<Event> visitCreate(Create e) {

        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
        store.addFilters(C11.PTHREAD);

        return eventSequence(
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
                newStore(e.getAddress(), IValue.ZERO, e.getMo())
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
        		load,
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), e.getLabel())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();

        return eventSequence(
        		newLoad(resultRegister, e.getAddress(), e.getMo()),
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), e.getLabel())
        );
	}

	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
        Register resultRegister = e.getResultRegister();
		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, e.getCmp(), e.getAddress(), Tag.Linux.MO_RELAXED);

        return eventSequence(
                Linux.newConditionalMemoryBarrier(load),
                load,
                Linux.newRMWStoreCond(load, e.getAddress(), new IExprBin(dummy, IOpBin.PLUS, (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED),
                newLocal(resultRegister, new Atom(dummy, NEQ, e.getCmp())),
                Linux.newConditionalMemoryBarrier(load)
        );
	}

	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface cmp = e.getCmp();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = resultRegister;
        if(resultRegister == value || resultRegister == cmp){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

        RMWReadCondCmp load = Linux.newRMWReadCondCmp(dummy, cmp, address, Tag.Linux.loadMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newConditionalMemoryBarrier(load) : null;

        return eventSequence(
                optionalMbBefore,
                load,
                Linux.newRMWStoreCond(load, address, value, Tag.Linux.storeMO(mo)),
                optionalUpdateReg,
                optionalMbAfter
        );
	}

	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();
        ExprInterface value = e.getMemValue();

        Register dummy = resultRegister;
		if(resultRegister == value){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStore(load, address, new IExprBin(dummy, e.getOp(), (IExpr) value), Tag.Linux.storeMO(mo)),
                optionalUpdateReg,
                optionalMbAfter
        );
	}

	@Override
	public List<Event> visitRMWOp(RMWOp e) {
        IExpr address = e.getAddress();
        Register resultRegister = e.getResultRegister();
		
        Load load = newRMWLoad(resultRegister, address, Tag.Linux.MO_RELAXED);
        load.addFilters(Tag.Linux.NORETURN);
        
        return eventSequence(
                load,
                newRMWStore(load, address, new IExprBin(resultRegister, e.getOp(), (IExpr) e.getMemValue()), Tag.Linux.MO_RELAXED)
        );
	}

	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        int precision = resultRegister.getPrecision();
        
		Register dummy = new Register(null, resultRegister.getThreadId(), precision);
		Load load = newRMWLoad(dummy, address, Tag.Linux.MO_RELAXED);

        //TODO: Are the memory barriers really unconditional?
        return eventSequence(
                Linux.newMemoryBarrier(),
                load,
                newLocal(dummy, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStore(load, address, dummy, Tag.Linux.MO_RELAXED),
                newLocal(resultRegister, new Atom(dummy, EQ, new IValue(BigInteger.ZERO, precision))),
                Linux.newMemoryBarrier()
        );
	}

	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();
        String mo = e.getMo();
        
		Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newLocal(resultRegister, new IExprBin(dummy, e.getOp(), (IExpr) e.getMemValue())),
                newRMWStore(load, address, resultRegister, Tag.Linux.storeMO(mo)),
                optionalMbAfter
        );
	}

	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
        Register resultRegister = e.getResultRegister();
        String mo = e.getMo();
        IExpr address = e.getAddress();

        Register dummy = resultRegister;
        if(resultRegister == e.getMemValue()){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

		Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;
		Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                newRMWStore(load, address, e.getMemValue(), Tag.Linux.storeMO(mo)),
                optionalUpdateReg,
                optionalMbAfter
        );
	}

	@Override
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
        int threadId = resultRegister.getThreadId();
		int precision = resultRegister.getPrecision();

		Register regExpected = new Register(null, threadId, precision);
        Register regValue = new Register(null, threadId, precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Store storeExpected = newStore(expectedAddr, regValue, null);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoad(regValue, address, mo);
        Store storeValue = newRMWStore(loadValue, address, e.getMemValue(), mo);

        return eventSequence(
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
	}

	@Override
	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, mo);

        return eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
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
        return eventSequence(
        		newStore(e.getAddress(), e.getMemValue(), e.getMo())
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        return Collections.emptyList();
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
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		ExprInterface expectedValue = e.getExpectedValue();

        Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

        Load load = newRMWLoad(regValue, address, mo);
        Store store = newRMWStore(load, address, value, mo);

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