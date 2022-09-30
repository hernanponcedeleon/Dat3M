package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory.*;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.core.rmw.StoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.STRONG;

class VisitorRISCV extends VisitorBase {
	// Some language memory models (e.g. RC11) are non-dependency tracking and might need a 
	// strong version of no-OOTA, thus we need to strength the compilation. None of the usual paper
	// "Repairing Sequential Consistency in C/C++11"
	// "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
	// talk about compilation to RISCV, but since it is closer to ARMv8 than Power
	// we use the same scheme as AMRv8
	private final boolean useRC11Scheme; 

	protected VisitorRISCV(boolean forceStart, boolean useRC11Scheme) {
		super(forceStart);
		this.useRC11Scheme = useRC11Scheme;
	}
	
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
        Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(Tag.STARTLOAD);

        return eventSequence(
        		load,
                RISCV.newRWRWFence(),
				super.visitStart(e),
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
        // We normally make the following two events optional.
        // Here we make them mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, storeValue);
        Local updateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));

        return eventSequence(
                // Indentation shows the branching structure
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                    storeValue,
                    execStatus,
                    updateCasCmpResult,
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
        // We normally make the following optional.
        // Here we make it mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);

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
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme ? RISCV.newRWWFence() :  null;

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
        // We normally make the following optional.
        // Here we make it mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);
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
        		optionalMemoryBarrier,
				newStore(e.getAddress(), e.getMemValue(), null)
        );

	}

	@Override
	public List<Event> visitLKMMFence(LKMMFence e) {
		Fence optionalMemoryBarrier;
		switch(e.getName()) {
			// smp_mb()
			case Tag.Linux.MO_MB:
			// https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
			// https://elixir.bootlin.com/linux/v5.18/source/arch/riscv/include/asm/barrier.h 
			case Tag.Linux.BEFORE_ATOMIC:
			case Tag.Linux.AFTER_ATOMIC:
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
				throw new UnsupportedOperationException("Compilation of fence " + e.getName() + " is not supported");
		}

		return eventSequence(
                optionalMemoryBarrier
        );
	}
	
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(dummy, NEQ, e.getCmp()), casEnd);
        
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = RISCV.newRMWStoreConditional(address, value, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : null, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;
        
        return eventSequence(
                // Indentation shows the branching structure
        		optionalMemoryBarrierBefore,
                load,
                branchOnCasCmpResult,
                    store,
                    status,
                    fakeCtrlDep,
                    label,
                    optionalMemoryBarrierAfter,
                casEnd,
                newLocal(resultRegister, dummy)
        );
	}
	
	// Following
	// https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
	// The linux kernel uses AMO instructions which we don't yet support
	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : null;
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : null;
		Store store = RISCV.newRMWStoreConditional(address, value, moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;

        return eventSequence(
                load,
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}
	
	// Following
	// https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
	// The linux kernel uses AMO instructions which we don't yet support
	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : null;
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : null;
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(dummy, op, value), moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);

        return eventSequence(
                load,
                store,
                status,
                fakeCtrlDep,
                label
        );
	};

	// The linux kernel uses AMO instructions which we don't yet support
	// The scheme is not described in
	// https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
	// Since in VisitorArm8 this one is similar to visitRMWCmpXchg
	// we also make it scheme similar to the one of visitRMWCmpXchg in this class
	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

		Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(dummy, e.getOp(), value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : null, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;

        return eventSequence(
        		optionalMemoryBarrierBefore,
                load,
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}

	// The linux kernel uses AMO instructions which we don't yet support
	// The scheme is not described in
	// https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
	// Since in VisitorArm8 this one is similar to visitRMWCmpXchg
	// we also make it scheme similar to the one of visitRMWCmpXchg in this class
	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = RISCV.newRMWStoreConditional(address, dummy, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : null, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;
        
        return eventSequence(
        		optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, new IExprBin(dummy, op, value)),
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};
	
	// This is a simplified version that should be correct according to the instruction's semantics.
	// The implementation from the kernel is overly complicated, but since it relies on several macros
	// (atomic_add_unless -> atomic_fetch_add_unless -> atomic_try_cmpxchg -> atomic_cmpxchg)
	// and not on inlined assembly, we don't really need to test that the compilation is correct
	// (the other methods implementing the macros are been tested already).
	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		int precision = resultRegister.getPrecision();

        Register regValue = e.getThread().newRegister(precision);
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

		Load load = newRMWLoadExclusive(regValue, address, null);
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(regValue, IOpBin.PLUS, (IExpr) value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : null, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);

        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		ExprInterface unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(new Atom(dummy, EQ, IValue.ZERO), cauEnd);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;

        return eventSequence(
                // Indentation shows the branching structure
                load,
                newLocal(dummy, new Atom(regValue, NEQ, unless)),
                branchOnCauCmpResult,
                    store,
                    status,
                    fakeCtrlDep,
                    label,
                    optionalMemoryBarrierAfter,
                cauEnd,
                newLocal(resultRegister, dummy)
        );
	};
	
	// The implementation is arch_${atomic}_op_return(i, v) == 0;
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/sub_and_test
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/inc_and_test
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/dec_and_test
	@Override
	public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
        Register retReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(retReg, new IExprBin(dummy, op, value));
        Local testOp = newLocal(resultRegister, new Atom(retReg, EQ, IValue.ZERO));

        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, retReg, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : null, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;
        
        return eventSequence(
                load,
                localOp,
                store,
                status,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                testOp
        );	
	};
}