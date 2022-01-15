package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.EventFactory.AArch64;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.event.EventFactory.newExecutionStatus;
import static com.dat3m.dartagnan.program.event.EventFactory.newFakeCtrlDep;
import static com.dat3m.dartagnan.program.event.EventFactory.newGoto;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static com.dat3m.dartagnan.program.event.EventFactory.newJumpUnless;
import static com.dat3m.dartagnan.program.event.EventFactory.newLabel;
import static com.dat3m.dartagnan.program.event.EventFactory.newLoad;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWLoadExclusive;
import static com.dat3m.dartagnan.program.event.EventFactory.newRMWStoreExclusive;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.Tag.STRONG;

@Options
public class VisitorArm8 extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorArm8() {}
	
	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo(), e.getCLine());
        store.addFilters(C11.PTHREAD);

        return eventSequence(
        		AArch64.DMB.newISHBarrier(),
                store,
                AArch64.DMB.newISHBarrier()
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		AArch64.DMB.newISHBarrier(),
        		newStore(e.getAddress(), IConst.ZERO, e.getMo()),
                AArch64.DMB.newISHBarrier()
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        List<Event> events = new ArrayList<>();
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);
        events.add(load);
        events.add(AArch64.DMB.newISHBarrier());
        events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ZERO), e.getLabel()));
        
        return events;
	}

	@Override
	public List<Event> visitStart(Start e) {
        List<Event> events = new ArrayList<>();
        Register resultRegister = e.getResultRegister();
        events.add(newLoad(resultRegister, e.getAddress(), e.getMo()));
        events.add(AArch64.DMB.newISHBarrier());
        events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), e.getLabel()));
        
        return events;
	}

	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());
        
        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
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
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        Load loadValue = newRMWLoadExclusive(regValue, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
        Store storeValue = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), e.is(STRONG));
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            Register statusReg = new Register("status(" + e.getOId() + ")", threadId, precision);
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
        }

        return eventSequence(
                // Indentation shows the branching structure
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
                casEnd
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

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, dummyReg, Tag.ARMv8.extractStoreMoFromCMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                localOp,
                store
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
                newLoad(e.getResultRegister(), e.getAddress(), Tag.ARMv8.extractLoadMoFromCMo(e.getMo()))
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), Tag.ARMv8.extractStoreMoFromCMo(e.getMo()))
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		String mo = e.getMo();
        Fence fence = null;
                fence = mo.equals(Tag.C11.MO_RELEASE) || mo.equals(Tag.C11.MO_ACQUIRE_RELEASE) || mo.equals(Tag.C11.MO_SC) ? AArch64.DMB.newISHBarrier()
                        : mo.equals(Tag.C11.MO_ACQUIRE) ? AArch64.DSB.newISHLDBarrier() : null;

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

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                store
        );
	}

	@Override
	public List<Event> visitDat3mCAS(Dat3mCAS e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		ExprInterface expectedValue = e.getExpectedValue();

        // Events common for all compilation schemes.
        Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);

        Load load = newRMWLoadExclusive(regValue, address, Tag.ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, value, Tag.ARMv8.extractStoreMoFromCMo(mo), true);

        // --- Add success events ---
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