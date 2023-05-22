package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme.LEADING_SYNC;

public class VisitorPower extends VisitorBase {

	// The compilation schemes below follows the paper
	// "Clarifying and Compiling C/C++ Concurrency: from C++11 to POWER"
	// The paper does not define the mappings for RMW, but we derive them
	// using the same pattern as for Load/Store
	private final PowerScheme cToPowerScheme;
	// Some language memory models (e.g. RC11) are non-dependency tracking and might need a
	// strong version of no-OOTA, thus we need to strength the compilation following the papers
	// "Repairing Sequential Consistency in C/C++11"
	// "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
	private final boolean useRC11Scheme;

	protected VisitorPower(boolean forceStart, boolean useRC11Scheme, PowerScheme cToPowerScheme) {
		super(forceStart);
		this.useRC11Scheme = useRC11Scheme;
		this.cToPowerScheme = cToPowerScheme;
	}

	// =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo());
        store.addTags(C11.PTHREAD);

        return eventSequence(
                Power.newSyncBarrier(),
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
				Power.newSyncBarrier(),
				newStore(e.getAddress(), zero, e.getMo())
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Literal zero = expressions.makeZero(resultRegister.getType());
		Load load = newLoad(resultRegister, e.getAddress(), "");
        load.addTags(C11.PTHREAD);
        Label label = newLabel("Jump_" + e.getGlobalId());
        CondJump fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                Power.newISyncBarrier(),
                newJump(expressions.makeBinary(resultRegister, NEQ, zero), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
		Literal one = expressions.makeOne(resultRegister.getType());
        Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
		load.addTags(Tag.STARTLOAD);
		Label label = newLabel("Jump_" + e.getGlobalId());
        CondJump fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		return eventSequence(
                load,
                fakeCtrlDep,
                label,
                Power.newISyncBarrier(),
				super.visitStart(e),
                newJump(expressions.makeBinary(resultRegister, NEQ, one), (Label) e.getThread().getExit())
        );
	}

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                Power.newLwSyncBarrier(),
                newStore(e.getAddress(), e.getMemValue(), ""));
    }

    @Override
    public List<Event> visitLock(Lock e) {
        Register dummy = e.getThread().newRegister(archType);
        Label label = newLabel("FakeDep");
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
        // use assumes. The fake control dependency + isync guarantee acquire semantics.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getAddress(), ""),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, zero)),
                Power.newRMWStoreConditional(e.getAddress(), one, "", true),
                // Fake dependency to guarantee acquire semantics
                newFakeCtrlDep(dummy, label),
                label,
                Power.newISyncBarrier());
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                Power.newLwSyncBarrier(),
                newStore(e.getAddress(), zero, ""));
    }
    
    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

	@Override
	public List<Event> visitLlvmLoad(LlvmLoad e) {
		Register resultRegister = e.getResultRegister();

		Fence optionalBarrierBefore = null;
		Load load = newLoad(resultRegister, e.getAddress(), "");
		Label optionalLabel = null;
		CondJump optionalFakeCtrlDep = null;
		Fence optionalBarrierAfter = null;

		switch (e.getMo()) {
			case C11.MO_SC:
				if (cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalLabel = newLabel("FakeDep");
					optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalLabel = newLabel("FakeDep");
				optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELAXED:
				if (useRC11Scheme) {
					optionalLabel = newLabel("FakeDep");
					optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
				}
				break;
		}

		return eventSequence(
				optionalBarrierBefore,
				load,
				optionalFakeCtrlDep,
				optionalLabel,
				optionalBarrierAfter);
	}

	@Override
	public List<Event> visitLlvmStore(LlvmStore e) {
		Fence optionalBarrierBefore = null;
		Store store = newStore(e.getAddress(), e.getMemValue(), "");
		Fence optionalBarrierAfter = null;

		switch (e.getMo()) {
			case C11.MO_SC:
				if (cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
		}

		return eventSequence(
				optionalBarrierBefore,
				store,
				optionalBarrierAfter);
	}

	@Override
	public List<Event> visitLlvmXchg(LlvmXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		String mo = e.getMo();

		// Power does not have mo tags, thus we use null
		Load load = newRMWLoadExclusive(resultRegister, address, "");
		Store store = Power.newRMWStoreConditional(address, e.getMemValue(), "",  true);
		Label label = newLabel("FakeDep");
		Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		Fence optionalBarrierBefore = null;
		Fence optionalBarrierAfter = null;

		switch (mo) {
			case C11.MO_SC:
				if (cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}

		return eventSequence(
				optionalBarrierBefore,
				load,
				fakeCtrlDep,
				label,
				store,
				optionalBarrierAfter);
	}

	@Override
	public List<Event> visitLlvmRMW(LlvmRMW e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
		Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOp(), e.getMemValue()));

		// Power does not have mo tags, thus we use null
		Load load = newRMWLoadExclusive(resultRegister, address, "");
		Store store = Power.newRMWStoreConditional(address, dummyReg, "", true);
		Label label = newLabel("FakeDep");
		Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		Fence optionalBarrierBefore = null;
		// Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync
		// barrier is enough
		// However, power compilers in godbolt.org use a lwsync.
		// We stick to the literature to potentially find bugs in what researchers
		// claim.
		Fence optionalBarrierAfter = null;

		switch (mo) {
			case C11.MO_SC:
				if (cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}

		return eventSequence(
				optionalBarrierBefore,
				load,
				fakeCtrlDep,
				label,
				localOp,
				store,
				optionalBarrierAfter);
	}

	@Override
	public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
		Register oldValueRegister = e.getStructRegister(0);
		Register resultRegister = e.getStructRegister(1);

		Expression address = e.getAddress();
		String mo = e.getMo();

		Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(oldValueRegister, EQ, e.getExpectedValue()));
		Label casEnd = newLabel("CAS_end");
		CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, one), casEnd);

		Load load = newRMWLoadExclusive(oldValueRegister, address, "");
		Store store = Power.newRMWStoreConditional(address, e.getMemValue(), "", true);

		Fence optionalBarrierBefore = null;
		Fence optionalBarrierAfter = null;

		switch (mo) {
			case C11.MO_SC:
				if (cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}

		return eventSequence(
				// Indentation shows the branching structure
				optionalBarrierBefore,
				load,
				casCmpResult,
				branchOnCasCmpResult,
				store,
				casEnd,
				optionalBarrierAfter);
	}

	@Override
	public List<Event> visitLlvmFence(LlvmFence e) {
		Fence fence = e.getMo().equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : Power.newLwSyncBarrier();

		return eventSequence(
				fence);
	}

    // =============================================================================================
    // ============================================ C11 ============================================
    // =============================================================================================

	@Override
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		Expression value = e.getMemValue();
		String mo = e.getMo();
		Expression expectedAddr = e.getExpectedAddr();
		Type type = resultRegister.getType();

		Register regExpected = e.getThread().newRegister(type);
        Register regValue = e.getThread().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, one), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        // Power does not have mo tags, thus we use the emptz string
        Load loadValue = newRMWLoadExclusive(regValue, address, "");
        Store storeValue = Power.newRMWStoreConditional(address, value, "", e.isStrong());
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (e.isWeak()) {
            Register statusReg = e.getThread().newRegister(type);
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(resultRegister, expressions.makeNot(statusReg));
        }

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        
        switch(mo) {
			case C11.MO_SC:
				if(cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}

        return eventSequence(
                // Indentation shows the branching structure
                optionalBarrierBefore,
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
                optionalBarrierAfter
        );
	}

	@Override
	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

        // Power does not have mo tags, thus we use the emptz string
        Load load = newRMWLoadExclusive(resultRegister, address, "");
        Store store = Power.newRMWStoreConditional(address, dummyReg, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalBarrierBefore = null;
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers claim.
        Fence optionalBarrierAfter = null;
        
        switch(mo) {
			case C11.MO_SC:
				if(cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}

        return eventSequence(
				optionalBarrierBefore,
                load,
                fakeCtrlDep,
                label,
                localOp,
                store,
                optionalBarrierAfter
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Fence optionalBarrierBefore = null;
        Load load = newLoad(resultRegister, address, mo);
        Label optionalLabel = null;
        CondJump optionalFakeCtrlDep = null;
        Fence optionalBarrierAfter = null;
        
        switch(mo) {
			case C11.MO_SC:
				if(cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalLabel = newLabel("FakeDep");
					optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalLabel = newLabel("FakeDep");
				optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELAXED:
				if(useRC11Scheme) {
					optionalLabel = newLabel("FakeDep");
					optionalFakeCtrlDep = newFakeCtrlDep(resultRegister, optionalLabel);
				}
				break;
		}

        return eventSequence(
                optionalBarrierBefore,
                load,
                optionalFakeCtrlDep,
                optionalLabel,
                optionalBarrierAfter
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

        Fence optionalBarrierBefore = null;
        Store store = newStore(address, value, mo);
        Fence optionalBarrierAfter = null;
        
        switch(mo) {
			case C11.MO_SC:
				if(cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
        }
        
        return eventSequence(
                optionalBarrierBefore,
                store,
                optionalBarrierAfter
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		String mo = e.getMo();
        Fence fence = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : Power.newLwSyncBarrier();

        return eventSequence(
                fence
        );
	}

	@Override
	public List<Event> visitAtomicXchg(AtomicXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use the emptz string
        Load load = newRMWLoadExclusive(resultRegister, address, "");
        Store store = Power.newRMWStoreConditional(address, value, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        
        switch(mo) {
			case C11.MO_SC:
				if(cToPowerScheme.equals(LEADING_SYNC)) {
					optionalBarrierBefore = Power.newSyncBarrier();
					optionalBarrierAfter = Power.newISyncBarrier();
				} else {
					optionalBarrierBefore = Power.newLwSyncBarrier();
					optionalBarrierAfter = Power.newSyncBarrier();
				}
				break;
			case C11.MO_ACQUIRE:
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
			case C11.MO_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				break;
			case C11.MO_ACQUIRE_RELEASE:
				optionalBarrierBefore = Power.newLwSyncBarrier();
				optionalBarrierAfter = Power.newISyncBarrier();
				break;
		}
        
        return eventSequence(
				optionalBarrierBefore,
                load,
                fakeCtrlDep,
                label,
                store,
                optionalBarrierAfter
        );
	}

    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLKMMLoad(LKMMLoad e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		String mo = e.getMo();

		// Power does not have mo tags, thus we use the empty string
        Load load = newLoad(resultRegister, address, "");
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newLwSyncBarrier() : null;
        
        return eventSequence(
                load,
                optionalMemoryBarrier
        );
	}

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLKMMStore(LKMMStore e) {
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use the empty string
        Store store = newStore(address, value, "");
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        
        return eventSequence(
                optionalMemoryBarrier,
                store
        );
	}

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLKMMFence(LKMMFence e) {
		Fence optionalMemoryBarrier;
		switch(e.getName()) {
			case Tag.Linux.MO_MB:
			case Tag.Linux.MO_RMB:
			case Tag.Linux.MO_WMB:
			case Tag.Linux.BEFORE_ATOMIC:
			case Tag.Linux.AFTER_ATOMIC:
				optionalMemoryBarrier = Power.newSyncBarrier();
				break;
			// #define smp_mb__after_spinlock()	smp_mb()
            // 		https://elixir.bootlin.com/linux/v6.1/source/arch/powerpc/include/asm/spinlock.h#L14
            case Tag.Linux.AFTER_SPINLOCK:
				optionalMemoryBarrier = Power.newSyncBarrier();
				break;
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            // 		https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK:
				optionalMemoryBarrier = Power.newSyncBarrier();
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
	// Methods with no suffix (e.g. atomic_xchg), which are those having MO_MB in our case,
	// are surrounded by a __atomic_pre_full_fence() or __atomic_post_full_fence()
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/fence
	// which in turn are smp_mb__before_atomic and smp_mb__after_atomic
	// 		https://elixir.bootlin.com/linux/v5.18/source/include/linux/atomic.h
	// which in turn are __smp_mb()
	// 		https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
	// which in turn is just a sync
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	//
	// Methods with acquire or release as a suffix
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/acquire
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/release
	// which result in a isync (acquire) or lwsync (release)
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/atomic.h
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/synch.h
	//
	// Most compilations have this snippet
	// 1:	ldarx	%0,0,%2
	//  	stdcx	%3,0,%2
	// bne	1b
	// Since we compile after unrolling, and our encoding enforces that the RMW pair is successful,
	// we just need the final iteration of the control dependency, thus we use a newFakeCtrlDep.
	// =============================================================================================

	@Override
	public List<Event> visitRMWCmpXchg(RMWCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		Expression value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(dummy, NEQ, e.getCmp()), casEnd);

        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, value, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrierBefore,
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

	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		Register resultRegister = e.getResultRegister();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, value, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}

	@Override
	public List<Event> visitRMWOp(RMWOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, expressions.makeBinary(dummy, op, value), "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};

	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, dummy, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, op, value)),
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};

	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
		Register resultRegister = e.getResultRegister();
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
		Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, expressions.makeBinary(dummy, e.getOp(), value), "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
				optionalMemoryBarrierBefore,
                load,
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}

	// The implementation relies on arch_atomic_fetch_add_unless
	// 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/add_unless
	// which uses a sub at the end to return the value before the operation
	// 		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/atomic.h
	// Since RMWAddUnless does not care about any returned value, we don't need the final sub
	@Override
	public List<Event> visitRMWAddUnless(RMWAddUnless e) {
		Register resultRegister = e.getResultRegister();
		Expression address = e.getAddress();
		Expression value = e.getMemValue();
		String mo = e.getMo();
		Type type = resultRegister.getType();

        Register regValue = e.getThread().newRegister(type);
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(regValue, address, "");
        Store store = Power.newRMWStoreConditional(address, expressions.makeBinary(regValue, IOpBin.PLUS, value), "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(resultRegister.getType());
		Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(expressions.makeBinary(dummy, EQ, zero), cauEnd);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, expressions.makeBinary(regValue, NEQ, unless)),
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
		Expression value = e.getMemValue();
		Expression address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getType());
        Register retReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(retReg, expressions.makeBinary(dummy, op, value));
        Local testOp = newLocal(resultRegister, expressions.makeBinary(retReg, EQ, zero));

        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = Power.newRMWStoreConditional(address, retReg, "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
				: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                localOp,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                testOp
        );
	};

	@Override
	public List<Event> visitLKMMLock(LKMMLock e) {
		Register dummy = e.getThread().newRegister(archType);
		Label label = newLabel("FakeDep");
    // Spinlock events are guaranteed to succeed, i.e. we can use assumes
		return eventSequence(
				newRMWLoadExclusive(dummy, e.getLock(), ""),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, zero)),
                Power.newRMWStoreConditional(e.getLock(), one, "", true),
				// Fake dependency to guarantee acquire semantics
				newFakeCtrlDep(dummy, label),
				label,
				Power.newISyncBarrier()
        );
	}

        @Override
		public List<Event> visitLKMMUnlock(LKMMUnlock e) {
			return eventSequence(
					Power.newLwSyncBarrier(),
                newStore(e.getAddress(), zero, "")
        );
		}

	public enum PowerScheme {

		LEADING_SYNC, TRAILING_SYNC;

	}
}