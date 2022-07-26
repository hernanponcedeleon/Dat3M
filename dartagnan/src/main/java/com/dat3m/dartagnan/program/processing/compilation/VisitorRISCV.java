package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory.RISCV;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.core.rmw.StoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicCmpXchg;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicFetchOp;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicLoad;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicStore;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicThreadFence;
import com.dat3m.dartagnan.program.event.lang.catomic.AtomicXchg;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMFence;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMLoad;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMStore;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
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
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.Tag.STRONG;
import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.EventFactory.newExecutionStatusWithDependencyTracking;
import java.util.List;

class VisitorRISCV extends VisitorBase implements EventVisitor<List<Event>> {

	protected VisitorRISCV() {}
	
	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo());
        store.addFilters(C11.PTHREAD);

        return eventSequence(
        		RISCV.newRWRWFence(),
                store,
                RISCV.newRWRWFence()
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		RISCV.newRWRWFence(),
        		newStore(e.getAddress(), IValue.ZERO, e.getMo()),
        		RISCV.newRWRWFence()
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);

        return eventSequence(
                load,
                RISCV.newRWRWFence(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        return eventSequence(
                newLoad(resultRegister, e.getAddress(), e.getMo()),
                RISCV.newRWRWFence(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = RISCV.newRMWStoreConditional(e.getAddress(), e.getMemValue(), e.getMo());

        return eventSequence(
                store,
                newExecutionStatusWithDependencyTracking(e.getResultRegister(), store)
        );
	}

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

	@Override
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Register regValue = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Store storeExpected = newStore(expectedAddr, regValue, null);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        Load loadValue = newRMWLoadExclusive(regValue, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store storeValue = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), e.is(STRONG));
        Register statusReg = e.getThread().newRegister("status(" + e.getUId() + ")",precision);
        // Execution status is normally optional.
        // Here we make it mandatory to guarantee that the RMWStoreExclusive
        // is followed by a ExecutionStatus which is required in RelIdd 
        ExecutionStatus execStatus = newExecutionStatus(statusReg, storeValue);
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
        }

        return eventSequence(
                // Indentation shows the branching structure
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                    storeValue,
                    execStatus,
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
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, dummyReg, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getUId() + ")", resultRegister.getPrecision());
        // Execution status is normally optional.
        // Here we make it mandatory to guarantee that the RMWStoreExclusive
        // is followed by a ExecutionStatus which is required in RelIdd 
        ExecutionStatus execStatus = newExecutionStatus(statusReg, store);

        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                localOp,
                store,
                execStatus
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? RISCV.newRWRWFence() :  null;
		Fence optionalBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? RISCV.newRRWFence() :  null;

		return eventSequence(
				optionalBarrierBefore,
				newLoad(e.getResultRegister(), e.getAddress(), null),
				optionalBarrierAfter
		);
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) ? RISCV.newRWWFence() :  null;

		return eventSequence(
				optionalBarrierBefore,
				newStore(e.getAddress(), e.getMemValue(), null)
		);
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		Fence fence = null;
		switch(e.getMo()) {
			case Tag.C11.MO_ACQUIRE:
				fence = RISCV.newRRWFence();
				break;
			case Tag.C11.MO_RELEASE:
				fence = RISCV.newRWWFence();
				break;
			case Tag.C11.MO_ACQUIRE_RELEASE:
				fence = RISCV.newTsoFence();
				break;
			case Tag.C11.MO_SC:
				fence = RISCV.newRWRWFence();
				break;
		}
			
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

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getUId() + ")", resultRegister.getPrecision());
        // Execution status is normally optional.
        // Here we make it mandatory to guarantee that the RMWStoreExclusive
        // is followed by a ExecutionStatus which is required in RelIdd 
        ExecutionStatus execStatus = newExecutionStatus(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                store,
                execStatus
        );
	}
	
    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

	@Override
	public List<Event> visitLKMMLoad(LKMMLoad e) {
        String mo = e.getMo();
		Fence optionalMemoryBarrier = mo.equals(MO_ACQUIRE) ? RISCV.newRRWFence() : null;
    
		return eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), null),
        		optionalMemoryBarrier
        );

	}

	@Override
	public List<Event> visitLKMMStore(LKMMStore e) {
        String mo = e.getMo();
		Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
		
		return eventSequence(
				newStore(e.getAddress(), e.getMemValue(), null),
        		optionalMemoryBarrier
        );

	}

	@Override
	public List<Event> visitLKMMFence(LKMMFence e) {
		Fence optionalMemoryBarrier;
		switch(e.getName()) {
			// smp_mb()
			case Tag.Linux.MO_MB:
				optionalMemoryBarrier = RISCV.newRWRWFence();
				break;
			// smp_rmb()
			case Tag.Linux.MO_RMB:
				optionalMemoryBarrier = RISCV.newRRFence();
				break;
			// smp_wmb()
			case Tag.Linux.MO_WMB:
				optionalMemoryBarrier = RISCV.newWWFence();
				break;
			default:
				optionalMemoryBarrier = null;
				break;
		}

		return eventSequence(
                optionalMemoryBarrier
        );
	}
}