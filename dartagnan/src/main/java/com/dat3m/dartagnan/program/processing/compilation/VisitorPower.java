package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.STRONG;

class VisitorPower extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorPower() {}
	
	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
        store.addFilters(C11.PTHREAD);

        return eventSequence(
                Power.newSyncBarrier(),
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		Power.newSyncBarrier(),
        		newStore(e.getAddress(), IValue.ZERO, e.getMo())
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);
        Label label = newLabel("Jump_" + e.getOId());

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister, label),
                label,
                Power.newISyncBarrier(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), e.getLabel())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        Label label = newLabel("Jump_" + e.getOId());

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister, label),
                label,
                Power.newISyncBarrier(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), e.getLabel())
        );
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

		Register regExpected = new Register(null, threadId, precision);
        Register regValue = new Register(null, threadId, precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Store storeExpected = newStore(expectedAddr, regValue, null);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        // Power does not have mo tags, thus we use null
        Load loadValue = newRMWLoadExclusive(regValue, address, null);
        Store storeValue = newRMWStoreExclusive(address, value, null, e.is(STRONG));
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            Register statusReg = new Register("status(" + e.getOId() + ")", threadId, precision);
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
        }

        Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                : null;
        Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrier,
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                    storeValue,
                    optionalExecStatus,
                    optionalUpdateCasCmpResult,
                    gotoCasEnd,
                casFail,
                    storeExpected,
                casEnd,
                optionalISyncBarrier
        );
	}

	@Override
	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(resultRegister, address, null);
        Store store = newRMWStoreExclusive(address, dummyReg, null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalMemoryBarrier = null;
        // Academics papers normally say an isync barrier is enough
        // However this makes benchmark linuxrwlocks.c fail
        // Additionally, power compilers in godbolt.org use a lwsync
        Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier() : null;
        optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                : null;

        return eventSequence(
                optionalMemoryBarrier,
                load,
                fakeCtrlDep,
                label,
                localOp,
                store,
                optionalISyncBarrier
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Load load = newLoad(resultRegister, address, mo);
        Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : null;
        Label optionalLabel =
                (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELAXED)) ?
                        newLabel("FakeDep") :
                        null;
        CondJump optionalFakeCtrlDep =
                (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELAXED)) ?
                        newFakeCtrlDep(resultRegister, optionalLabel) :
                        null;
        Fence optionalISyncBarrier =
                (mo.equals(Tag.C11.MO_SC) || mo.equals(Tag.C11.MO_ACQUIRE)) ?
                        Power.newISyncBarrier() :
                        null;
        
        return eventSequence(
                optionalMemoryBarrier,
                load,
                optionalFakeCtrlDep,
                optionalLabel,
                optionalISyncBarrier
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Store store = newStore(address, value, mo);
        Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                : mo.equals(Tag.C11.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        
        return eventSequence(
                optionalMemoryBarrier,
                store
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		String mo = e.getMo();
        Fence fence = mo.equals(Tag.C11.MO_ACQUIRE) || mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ?
                        Power.newLwSyncBarrier() : null;

        return eventSequence(
                fence
        );
	}

	@Override
	public List<Event> visitAtomicXchg(AtomicXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(resultRegister, address, null);
        Store store = newRMWStoreExclusive(address, value, null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                : null;

        Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrier,
                load,
                fakeCtrlDep,
                label,
                store,
                optionalISyncBarrier
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
        Load load = newRMWLoadExclusive(regValue, address, null);
        Store store = newRMWStoreExclusive(address, value, null, true);

        Fence optionalMemoryBarrier = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier()
                : mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newLwSyncBarrier()
                : null;
        Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;
        
        // --- Add success events ---
        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrier,
                load,
                casCmpResult,
                branchOnCasCmpResult,
                    store,
                optionalISyncBarrier,
                casEnd
        );
	}
}