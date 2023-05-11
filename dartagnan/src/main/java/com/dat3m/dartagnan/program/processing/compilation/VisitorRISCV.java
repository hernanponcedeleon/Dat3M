package com.dat3m.dartagnan.program.processing.compilation;

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
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.Type;

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
	public List<Event> visitStoreExclusive(StoreExclusive e) {
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
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.RISCV.MO_REL);
        store.addFilters(C11.PTHREAD);

        return eventSequence(
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
				newStore(e.getAddress(), IValue.ZERO, Tag.RISCV.MO_REL));
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		IValue zero = expressions.makeZero(resultRegister.getType());
		Load load = newLoad(resultRegister, e.getAddress(), Tag.RISCV.MO_ACQ);
        load.addFilters(C11.PTHREAD);

        return eventSequence(
                load,
                newJump(expressions.makeBinary(resultRegister, NEQ, zero), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
		IValue one = expressions.makeOne(resultRegister.getType());
		Load load = newLoad(resultRegister, e.getAddress(), Tag.RISCV.MO_ACQ);
        load.addFilters(Tag.STARTLOAD);

        return eventSequence(
				load,
				super.visitStart(e),
                newJump(expressions.makeBinary(resultRegister, NEQ, one), (Label) e.getThread().getExit())
        );
	}

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                RISCV.newRWWFence(),
                newStore(e.getAddress(), e.getMemValue(), ""));
    }

    @Override
    public List<Event> visitLock(Lock e) {
        Register dummy = e.getThread().newRegister(archType);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can use
        // assumes. With this we miss a ctrl dependency, but this does not matter
        // because of the fence.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getAddress(), ""),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, IValue.ZERO)),
                newRMWStoreExclusive(e.getAddress(), IValue.ONE, "", true),
                RISCV.newRRWFence());
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                RISCV.newRWWFence(),
                newStore(e.getAddress(), IValue.ZERO, ""));
    }

	// =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

	@Override
	public List<Event> visitLlvmLoad(LlvmLoad e) {
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
	public List<Event> visitLlvmStore(LlvmStore e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme
				? RISCV.newRWWFence()
				: null;

		return eventSequence(
				optionalBarrierBefore,
				newStore(e.getAddress(), e.getMemValue(), ""));
	}

	@Override
	public List<Event> visitLlvmXchg(LlvmXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
		Store store = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);
		Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getType());
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
				execStatus);
	}

	@Override
	public List<Event> visitLlvmRMW(LlvmRMW e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
		Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

		Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
		Store store = RISCV.newRMWStoreConditional(address, dummyReg, Tag.RISCV.extractStoreMoFromCMo(mo), true);
		Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getType());
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
				execStatus);
	}

	@Override
	public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
		Register oldValueRegister = e.getStructRegister(0);
		Register resultRegister = e.getStructRegister(1);

		Expression value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		Expression expectedValue = e.getExpectedValue();

		Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(oldValueRegister, EQ, expectedValue));
		Label casEnd = newLabel("CAS_end");
		CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, IValue.ONE), casEnd);

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
	public List<Event> visitLlvmFence(LlvmFence e) {
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
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		Expression value = e.getMemValue();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		Type type = resultRegister.getType();

		Register regExpected = e.getThread().newRegister(type);
        Register regValue = e.getThread().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        Load loadValue = newRMWLoadExclusive(regValue, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store storeValue = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), e.isStrong());
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", type);
        // We normally make the following two events optional.
        // Here we make them mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, storeValue);
        Local updateCasCmpResult = newLocal(resultRegister, expressions.makeUnary(BOpUn.NOT, statusReg));

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

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, dummyReg, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getType());
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
				newLoad(e.getResultRegister(), e.getAddress(), ""),
				optionalBarrierAfter
		);
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();
		Fence optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme ? RISCV.newRWWFence() :  null;

		return eventSequence(
				optionalBarrierBefore,
				newStore(e.getAddress(), e.getMemValue(), "")
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
		Expression value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoadExclusive(resultRegister, address, Tag.RISCV.extractLoadMoFromCMo(mo));
        Store store = RISCV.newRMWStoreConditional(address, value, Tag.RISCV.extractStoreMoFromCMo(mo), true);
        Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", resultRegister.getType());
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
				newLoad(e.getResultRegister(), e.getAddress(), ""),
				optionalMemoryBarrier
        );

	}

	@Override
	public List<Event> visitLKMMStore(LKMMStore e) {
        String mo = e.getMo();
		Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;

		return eventSequence(
				optionalMemoryBarrier,
				newStore(e.getAddress(), e.getMemValue(), "")
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

	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		Expression value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(dummy, NEQ, e.getCmp()), casEnd);
        
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, value, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(expressions.makeBinary(statusReg, EQ, IValue.ZERO), label);
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
		Expression value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
		Store store = RISCV.newRMWStoreConditional(address, value, moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(expressions.makeBinary(statusReg, EQ, IValue.ZERO), label);
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

        Register dummy = e.getThread().newRegister(resultRegister.getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());
		String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = newRMWLoadExclusive(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
        Store store = RISCV.newRMWStoreConditional(address, expressions.makeBinary(dummy, op, value), moStore, true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(expressions.makeBinary(statusReg, EQ, IValue.ZERO), label);

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

		Register dummy = e.getThread().newRegister(resultRegister.getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());

		Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, expressions.makeBinary(dummy, e.getOp(), value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(expressions.makeBinary(statusReg, EQ, IValue.ZERO), label);
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

		Register dummy = e.getThread().newRegister(resultRegister.getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());

        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = RISCV.newRMWStoreConditional(address, dummy, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(expressions.makeBinary(statusReg, EQ, IValue.ZERO), label);
        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? RISCV.newRWWFence() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;
        
        return eventSequence(
				optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, op, value)),
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
		Expression value = e.getMemValue();
		String mo = e.getMo();
		Type type = resultRegister.getType();

        Register regValue = e.getThread().newRegister(type);
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());

		Load load = newRMWLoadExclusive(regValue, address, "");
        Store store = RISCV.newRMWStoreConditional(address, expressions.makeBinary(regValue, IOpBin.PLUS, (IExpr) value), mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);

        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(resultRegister.getType());
		Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(expressions.makeBinary(dummy, EQ, IValue.ZERO), cauEnd);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? RISCV.newRWRWFence() : mo.equals(Tag.Linux.MO_ACQUIRE) ? RISCV.newRRWFence() : null;

        return eventSequence(
                // Indentation shows the branching structure
                load,
                newLocal(dummy, expressions.makeBinary(regValue, NEQ, unless)),
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

		Register dummy = e.getThread().newRegister(resultRegister.getType());
		Register statusReg = e.getThread().newRegister(e.getResultRegister().getType());
        Register retReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(retReg, expressions.makeBinary(dummy, op, value));
        Local testOp = newLocal(resultRegister, expressions.makeBinary(retReg, EQ, IValue.ZERO));

        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = newRMWStoreExclusive(address, retReg, mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "", true);
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

	@Override
	public List<Event> visitLKMMLock(LKMMLock e) {
		Register dummy = e.getThread().newRegister(archType);
    // From this "unofficial" source (there is no RISCV specific implementation in the kernel)
		// 		https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/spinlock.h
		// We replace AMO instructions with LL/SC
		return eventSequence(
				newRMWLoadExclusive(dummy, e.getLock(), ""),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, IValue.ZERO)),
                newRMWStoreExclusive(e.getLock(), IValue.ONE, "", true),
				RISCV.newRRWFence()
        );
	}

    @Override
	public List<Event> visitLKMMUnlock(LKMMUnlock e) {
		return eventSequence(
				RISCV.newRWWFence(),
				newStore(e.getAddress(), IValue.ZERO, "")
        );
	}
}