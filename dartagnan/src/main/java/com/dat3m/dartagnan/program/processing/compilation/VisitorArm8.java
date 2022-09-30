package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory.*;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.ARMv8;
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
import static com.dat3m.dartagnan.program.event.Tag.STRONG;

class VisitorArm8 extends VisitorBase {

	// If the source WMM does not allow OOTA behaviors (e.g. RC11)
	// we need to strength the compilation following the paper
	// "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
	private final boolean useRC11Scheme; 
	
	protected VisitorArm8(boolean forceStart, boolean useRC11Scheme) {
		super(forceStart);
		this.useRC11Scheme = useRC11Scheme;
	}
	
	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo());
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
        		newStore(e.getAddress(), IValue.ZERO, e.getMo()),
                AArch64.DMB.newISHBarrier()
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        load.addFilters(C11.PTHREAD);

        return eventSequence(
                load,
                AArch64.DMB.newISHBarrier(),
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
				AArch64.DMB.newISHBarrier(),
                super.visitStart(e),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());
        
        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
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

        Load loadValue = newRMWLoadExclusive(regValue, address, ARMv8.extractLoadMoFromCMo(mo));
        Store storeValue = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromCMo(mo), e.is(STRONG));
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            Register statusReg = e.getThread().newRegister("status(" + e.getUId() + ")",precision);
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
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

        Load load = newRMWLoadExclusive(resultRegister, address, ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, dummyReg, ARMv8.extractStoreMoFromCMo(mo), true);
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
                newLoad(e.getResultRegister(), e.getAddress(), ARMv8.extractLoadMoFromCMo(e.getMo()))
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), useRC11Scheme ? ARMv8.MO_REL : ARMv8.extractStoreMoFromCMo(e.getMo()))
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		String mo = e.getMo();
        Fence fence = mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) || mo.equals(C11.MO_SC) ? AArch64.DMB.newISHBarrier()
                        : mo.equals(C11.MO_ACQUIRE) ? AArch64.DSB.newISHLDBarrier() : null;

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

        Load load = newRMWLoadExclusive(resultRegister, address, ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromCMo(mo), true);
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
        Register regValue = e.getThread().newRegister(resultRegister.getPrecision());
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

        Load load = newRMWLoadExclusive(regValue, address, ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromCMo(mo), true);

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
	
    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/barrier.h#L151
	@Override
	public List<Event> visitLKMMLoad(LKMMLoad e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Load load = newLoad(resultRegister, address, ARMv8.extractLoadMoFromLKMo(mo));
        
        return eventSequence(
                load
        );
	}

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/barrier.h#L116
	@Override
	public List<Event> visitLKMMStore(LKMMStore e) {
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Store store = newStore(address, value, mo.equals(Tag.Linux.MO_RELEASE) ? Tag.ARMv8.MO_REL : null);
        
        return eventSequence(
                store
        );
	}

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLKMMFence(LKMMFence e) {
		Fence optionalMemoryBarrier;
		switch(e.getName()) {
			// mb()
			case Tag.Linux.MO_MB:
				optionalMemoryBarrier = AArch64.DSB.newISHBarrier();
				break;
			// rmb()
			case Tag.Linux.MO_RMB:
				optionalMemoryBarrier = AArch64.DSB.newISHLDBarrier();
				break;
			// wmb()
			case Tag.Linux.MO_WMB:
				optionalMemoryBarrier = AArch64.DSB.newISHSTBarrier();
				break;
			// __smp_mb()
			// 		https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
			case Tag.Linux.BEFORE_ATOMIC:
			case Tag.Linux.AFTER_ATOMIC:
				optionalMemoryBarrier = AArch64.DMB.newISHBarrier();
				break;
			default:
				throw new UnsupportedOperationException("Compilation of fence " + e.getName() + " is not supported");
		}

		return eventSequence(
                optionalMemoryBarrier
        );
	}
	
	// =============================================================================================
	// 										GENERAL COMMENTS
	// =============================================================================================
	// We currently only support LL/SC (exclusive load/store) compilation. 
	// However the kernel also supports using hardware atomic operations
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/lse.h
	// =============================================================================================

	// Following
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L259
	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getPrecision());
        Label casEnd = newLabel("CAS_end");
    	// The real scheme uses XOR instead of comparison, but both are semantically 
        // equivalent and XOR harms performance substantially.
        CondJump branchOnCasCmpResult = newJump(new Atom(dummy, NEQ, e.getCmp()), casEnd);
        
        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                load,
                branchOnCasCmpResult,
                    store,
                    fakeCtrlDep,
                    label,
                    optionalMemoryBarrierAfter,
                casEnd,
                newLocal(resultRegister, dummy)
        );
	}

	// Following
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/cmpxchg.h#L21
	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}
	
	// Following
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L38
	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, new IExprBin(dummy, op, value), null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        return eventSequence(
                load,
                store,
                fakeCtrlDep,
                label
        );
	};

	// Following
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L56
	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, dummy, ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;
        
        return eventSequence(
                load,
                newLocal(dummy, new IExprBin(dummy, op, value)),
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};

	// Following
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L78
	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, new IExprBin(dummy, e.getOp(), value), ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}
	
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
		Load load = newRMWLoadExclusive(regValue, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, new IExprBin(regValue, IOpBin.PLUS, (IExpr) value), ARMv8.extractStoreMoFromLKMo(mo), true);
        
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		ExprInterface unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(new Atom(dummy, EQ, IValue.ZERO), cauEnd);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                load,
                newLocal(dummy, new Atom(regValue, NEQ, unless)),
                branchOnCauCmpResult,
                    store,
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
        Register retReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(retReg, new IExprBin(dummy, op, value));
        Local testOp = newLocal(resultRegister, new Atom(retReg, EQ, IValue.ZERO));

        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, retReg, ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        
        return eventSequence(
                load,
                localOp,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                testOp
        );	
	};
}