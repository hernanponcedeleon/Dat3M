package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMFence;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMLoad;
import com.dat3m.dartagnan.program.event.lang.linux.LKMMStore;
import com.dat3m.dartagnan.program.event.lang.linux.RMWAddUnless;
import com.dat3m.dartagnan.program.event.lang.linux.RMWCmpXchg;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpAndTest;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOpReturn;
import com.dat3m.dartagnan.program.event.lang.linux.RMWXchg;
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
        Store store = newStore(e.getAddress(), e.getMemValue(), e.getMo());
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
        CondJump fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        return eventSequence(
                load,
                fakeCtrlDep,
                label,
                Power.newISyncBarrier(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoad(resultRegister, e.getAddress(), e.getMo());
        Label label = newLabel("Jump_" + e.getOId());
        CondJump fakeCtrlDep = newFakeCtrlDep(resultRegister, label);
        
		return eventSequence(
                load,
                fakeCtrlDep,
                label,
                Power.newISyncBarrier(),
                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
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

        // Power does not have mo tags, thus we use null
        Load loadValue = newRMWLoadExclusive(regValue, address, null);
        Store storeValue = newRMWStoreExclusive(address, value, null, e.is(STRONG));
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            Register statusReg = e.getThread().newRegister(precision);
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
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(resultRegister, address, null);
        Store store = newRMWStoreExclusive(address, dummyReg, null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalMemoryBarrier = null;
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers claim.
        Fence optionalISyncBarrier = mo.equals(C11.MO_SC) || mo.equals(C11.MO_ACQUIRE) || mo.equals(C11.MO_ACQUIRE_RELEASE) ? Power.newISyncBarrier() : null;
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

        Register regValue = e.getThread().newRegister(resultRegister.getPrecision());
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
	
    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

	// Following
	//		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLKMMLoad(LKMMLoad e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        // Power does not have mo tags, thus we use null
        Load load = newLoad(resultRegister, address, null);
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
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use null
        Store store = newStore(address, value, null);
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
		String mo = e.getName();
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_MB) 
        		|| mo.equals(Tag.Linux.MO_WMB) || mo.equals(Tag.Linux.MO_RMB)
        		|| mo.equals(Tag.Linux.BEFORE_ATOMIC) || mo.equals(Tag.Linux.AFTER_ATOMIC) ?
        		Power.newSyncBarrier() : null;
        
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
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(e.getResultRegister().getPrecision());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(dummy, NEQ, e.getCmp()), casEnd);

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, value, null, true);
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
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, value, null, true);
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
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, new IExprBin(dummy, op, value), null, true);
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
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, dummy, null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, new IExprBin(dummy, op, value)),
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
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, new IExprBin(dummy, e.getOp(), value), null, true);
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
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		int precision = resultRegister.getPrecision();

        Register regValue = e.getThread().newRegister(precision);
        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(regValue, address, null);
        Store store = newRMWStoreExclusive(address, new IExprBin(regValue, IOpBin.PLUS, (IExpr) value), null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(resultRegister.getPrecision());
		ExprInterface unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(new Atom(dummy, EQ, IValue.ZERO), cauEnd);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrierBefore,
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

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(dummy, address, null);
        Store store = newRMWStoreExclusive(address, retReg, null, true);
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
        );	};
}