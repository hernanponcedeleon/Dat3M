package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_ACQUIRE;

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
	public List<AbstractEvent> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = RISCV.newRMWStoreConditional(e.getAddress(), e.getMemValue(), e.getMo());

        return eventSequence(
                store,
                newExecutionStatusWithDependencyTracking(e.getResultRegister(), store)
        );
	}

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
	public List<AbstractEvent> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.RISCV.MO_REL);
        store.addTags(C11.PTHREAD);

        return eventSequence(
                store
        );
	}

	@Override
	public List<AbstractEvent> visitEnd(End e) {
        return eventSequence(
        		newStore(e.getAddress(), IValue.ZERO, Tag.RISCV.MO_REL));
	}

	@Override
	public List<AbstractEvent> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), Tag.RISCV.MO_ACQ);
        load.addTags(C11.PTHREAD);

        return eventSequence(
                load,
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<AbstractEvent> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), Tag.RISCV.MO_ACQ);
        load.addTags(Tag.STARTLOAD);

        return eventSequence(
        		load,
				super.visitStart(e),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
	}

    @Override
    public List<AbstractEvent> visitInitLock(InitLock e) {
        return eventSequence(
                RISCV.newRWWFence(),
                newStore(e.getAddress(), e.getMemValue(), ""));
    }

    @Override
    public List<AbstractEvent> visitLock(Lock e) {
        Register dummy = e.getThread().newRegister(GlobalSettings.getArchPrecision());
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can use
        // assumes. With this we miss a ctrl dependency, but this does not matter
        // because of the fence.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getAddress(), ""),
                newAssume(new Atom(dummy, COpBin.EQ, IValue.ZERO)),
                newRMWStoreExclusive(e.getAddress(), IValue.ONE, "", true),
                RISCV.newRRWFence());
    }

    @Override
    public List<AbstractEvent> visitUnlock(Unlock e) {
        return eventSequence(
                RISCV.newRWWFence(),
                newStore(e.getAddress(), IValue.ZERO, ""));
    }
    
	// =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

	@Override
	public List<AbstractEvent> visitLlvmLoad(LlvmLoad e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? RISCV.newRWRWFence() : null;
		Fence optionalBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? RISCV.newRRWFence()
				: null;

		return eventSequence(
				optionalBarrierBefore,
				newLoad(e.getResultRegister(), e.getAddress(), ""),
				optionalBarrierAfter);
	}

	@Override
	public List<AbstractEvent> visitLlvmStore(LlvmStore e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme
				? RISCV.newRWWFence()
				: null;

		return eventSequence(
				optionalBarrierBefore,
				newStore(e.getAddress(), e.getMemValue(), ""));
	}

	@Override
	public List<AbstractEvent> visitLlvmXchg(LlvmXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
		Store store = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);
		Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getPrecision());
		// We normally make the following optional.
		// Here we make it mandatory to guarantee correct dependencies.
		ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);
		Label label = newLabel("FakeDep");
		AbstractEvent fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		return eventSequence(
				load,
				fakeCtrlDep,
				label,
				store,
				execStatus);
	}

	@Override
	public List<AbstractEvent> visitLlvmRMW(LlvmRMW e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
		Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

		Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
		Store store = RISCV.newRMWStoreConditional(address, dummyReg, Tag.RISCV.extractStoreMoFromCMo(mo), true);
		Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getPrecision());
		// We normally make the following optional.
		// Here we make it mandatory to guarantee correct dependencies.
		ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);

		Label label = newLabel("FakeDep");
		AbstractEvent fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		return eventSequence(
				load,
				fakeCtrlDep,
				label,
				localOp,
				store,
				execStatus);
	}

	@Override
	public List<AbstractEvent> visitLlvmCmpXchg(LlvmCmpXchg e) {
		Register oldValueRegister = e.getStructRegister(0);
		Register resultRegister = e.getStructRegister(1);

		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		ExprInterface expectedValue = e.getExpectedValue();

		Local casCmpResult = newLocal(resultRegister, new Atom(oldValueRegister, EQ, expectedValue));
		Label casEnd = newLabel("CAS_end");
		CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

		Load load = newRMWLoadExclusive(oldValueRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
		Store store = newRMWStoreExclusive(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);

		return eventSequence(
				// Indentation shows the branching structure
				load,
				casCmpResult,
				branchOnCasCmpResult,
				store,
				casEnd);
	}

	@Override
	public List<AbstractEvent> visitLlvmFence(LlvmFence e) {
		Fence fence = null;
		switch (e.getMo()) {
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
				fence);
	}

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

	@Override
	public List<AbstractEvent> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Register regValue = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        Load loadValue = newRMWLoadExclusive(regValue, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store storeValue = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), e.isStrong());
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", precision);
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
	public List<AbstractEvent> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, dummyReg, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getPrecision());
        // We normally make the following optional.
        // Here we make it mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);

        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

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
	public List<AbstractEvent> visitAtomicLoad(AtomicLoad e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? RISCV.newRWRWFence() :  null;
		Fence optionalBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? RISCV.newRRWFence() :  null;

		return eventSequence(
				optionalBarrierBefore,
				newLoad(e.getResultRegister(), e.getAddress(), ""),
				optionalBarrierAfter
		);
	}

	@Override
	public List<AbstractEvent> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme ? RISCV.newRWWFence() :  null;

		return eventSequence(
				optionalBarrierBefore,
				newStore(e.getAddress(), e.getMemValue(), "")
		);
	}

	@Override
	public List<AbstractEvent> visitAtomicThreadFence(AtomicThreadFence e) {
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
	public List<AbstractEvent> visitAtomicXchg(AtomicXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getPrecision());
        // We normally make the following optional.
        // Here we make it mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

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
	public List<AbstractEvent> visitLKMMLoad(LKMMLoad e) {
        String mo = e.getMo();
		Fence optionalMemoryBarrier = mo.equals(MO_ACQUIRE) ? RISCV.newRRWFence() : null;
    
		return eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), ""),
        		optionalMemoryBarrier
        );

	}

	@Override
	public List<AbstractEvent> visitLKMMStore(LKMMStore e) {
        String mo = e.getMo();
		Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
		
		return eventSequence(
        		optionalMemoryBarrier,
				newStore(e.getAddress(), e.getMemValue(), "")
        );

	}

	@Override
	public List<AbstractEvent> visitLKMMFence(LKMMFence e) {
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
			// ##define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)    
            // 		https://elixir.bootlin.com/linux/v6.1/source/arch/riscv/include/asm/barrier.h#L72
			// RISCV_FENCE(iorw,iorw) imposes ordering both on devices and memory
			// 		https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/barrier.h
			// Since the memory model says nothing about devices, we use RISCV_FENCE(rw,rw) which I think
			// gives the ordering we want wrt. memory
            case Tag.Linux.AFTER_SPINLOCK:
				optionalMemoryBarrier = RISCV.newRWRWFence();
				break;
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            // 		https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK:
				optionalMemoryBarrier = RISCV.newRWRWFence();
				break;
			default:
				throw new UnsupportedOperationException("Compilation of fence " + e.getName() + " is not supported");
		}

		return eventSequence(
                optionalMemoryBarrier
        );
	}
	
	public List<AbstractEvent> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(dummy, NEQ, e.getCmp()), casEnd);
        
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, value, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
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
	public List<AbstractEvent> visitRMWXchg(RMWXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
		Store store = RISCV.newRMWStoreConditional(address, value, moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
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
	public List<AbstractEvent> visitRMWOp(RMWOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(dummy, op, value), moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);

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
	public List<AbstractEvent> visitRMWFetchOp(RMWFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

		Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(dummy, e.getOp(), value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
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
	public List<AbstractEvent> visitRMWOpReturn(RMWOpReturn e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, dummy, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newJump(new Atom(statusReg, EQ, IValue.ZERO), label);
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
	public List<AbstractEvent> visitRMWAddUnless(RMWAddUnless e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		int precision = resultRegister.getPrecision();

        Register regValue = e.getThread().newRegister(precision);
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getPrecision());

		Load load = newRMWLoadExclusive(regValue, address, "");
        Store store = RISCV.newRMWStoreConditional(address, new IExprBin(regValue, IOpBin.PLUS, (IExpr) value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);

        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newFakeCtrlDep(regValue, label);

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
	public List<AbstractEvent> visitRMWOpAndTest(RMWOpAndTest e) {
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

        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = newRMWStoreExclusive(address, retReg, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        AbstractEvent fakeCtrlDep = newFakeCtrlDep(dummy, label);
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

	@Override
	public List<AbstractEvent> visitLKMMLock(LKMMLock e) {
	Register dummy = e.getThread().newRegister(GlobalSettings.getArchPrecision());
    // From this "unofficial" source (there is no RISCV specific implementation in the kernel)
	// 		https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/spinlock.h
	// We replace AMO instructions with LL/SC
	return eventSequence(
				newRMWLoadExclusive(dummy, e.getLock(), ""),
                newAssume(new Atom(dummy, COpBin.EQ, IValue.ZERO)),
                newRMWStoreExclusive(e.getLock(), IValue.ONE, "", true),
				RISCV.newRRWFence()
        );
	}

    @Override
	public List<AbstractEvent> visitLKMMUnlock(LKMMUnlock e) {
	return eventSequence(
				RISCV.newRWWFence(),
				newStore(e.getAddress(), IValue.ZERO, "")
        );
	}
}