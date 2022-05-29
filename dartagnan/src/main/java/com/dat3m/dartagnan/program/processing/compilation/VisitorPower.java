package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.RMWCmpXchg;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;
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

	// =============================================================================================
	// 										GENERAL COMMENTS
	// =============================================================================================
	// Methods with no suffix (e.g. atomic_xchg), which are those having MO_MB in our case,
	// are surrounded by a __atomic_pre_full_fence() or __atomic_post_full_fence()
	// 		https://github.com/torvalds/linux/blob/master/scripts/atomic/fallbacks/fence
	// which in turn are smp_mb__before_atomic and smp_mb__after_atomic
	// 		https://github.com/torvalds/linux/blob/master/include/linux/atomic.h
	// which in turn are __smp_mb()
	// 		https://github.com/torvalds/linux/blob/master/include/asm-generic/barrier.h
	// which in turn is just a sync
	// 		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/barrier.h
	//
	// Methods with acquire or release as a suffix
	// 		https://github.com/torvalds/linux/blob/master/scripts/atomic/fallbacks/acquire
	// 		https://github.com/torvalds/linux/blob/master/scripts/atomic/fallbacks/release
	// which result in a isync (acquire) or lwsync (release)
	// 		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/atomic.h
	// 		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/synch.h
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
		int precision = resultRegister.getPrecision();

		ExprInterface expected = e.getCmp();
        Register regValue = e.getThread().newRegister(precision);
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);
        CondJump gotoCasEnd = newGoto(casEnd);

        // Power does not have mo tags, thus we use null
        Load loadValue = newRMWLoadExclusive(regValue, address, null);
        // TODO: we don't use STRONG for LKMM, should we?
        Store storeValue = newRMWStoreExclusive(address, value, null, e.is(STRONG));
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (!e.is(STRONG)) {
            Register statusReg = e.getThread().newRegister(precision);
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
        }
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
                optionalMemoryBarrierBefore,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                    storeValue,
                    optionalExecStatus,
                    optionalUpdateCasCmpResult,
                    fakeCtrlDep,
                    label,
                    gotoCasEnd,
                casEnd,
                optionalMemoryBarrierAfter
        );
	}
	
	@Override
	public List<Event> visitRMWXchg(RMWXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(resultRegister, address, null);
        Store store = newRMWStoreExclusive(address, value, null, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

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
	}
	
	// For the following three events (i.e. RMWOpReturn, RMWOp, RMWFetchOp), the only difference here
	// 		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/atomic.h
	// is the use of #asm_op "%I2" and #asm_op "%I3". This seems to be related to using
	// immediate assembly operations, but I could not find any difference between I2 and I3, thus
	// all three methods have the same implementation.
	
	@Override
	public List<Event> visitRMWOpReturn(RMWOpReturn e) {
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

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                load,
                localOp,
                optionalMemoryBarrierBefore,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};

	@Override
	public List<Event> visitRMWOp(RMWOp e) {
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

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                load,
                localOp,
                optionalMemoryBarrierBefore,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	};

	@Override
	public List<Event> visitRMWFetchOp(RMWFetchOp e) {
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

        Fence optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
        		: mo.equals(Tag.Linux.MO_ACQUIRE)? Power.newISyncBarrier() : null;

        
        return eventSequence(
                load,
                localOp,
                optionalMemoryBarrierBefore,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
	}
	
	// Following
	//		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitLoad(Load e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        // Power does not have mo tags, thus we use null
        Load load = newLoad(resultRegister, address, null);
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newSyncBarrier() : null;
        
        return eventSequence(
                load,
                optionalMemoryBarrier
        );
	}

	// Following
	//		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitStore(Store e) {
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

        // Power does not have mo tags, thus we use null
        Store store = newStore(address, value, null);
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? Power.newSyncBarrier() : null;
        
        return eventSequence(
                optionalMemoryBarrier,
                store
        );
	}

	// Following
	//		https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/barrier.h
	@Override
	public List<Event> visitFence(Fence e) {
		String mo = e.getName();
        Fence optionalMemoryBarrier = mo.equals(Tag.Linux.MO_MB) 
        		|| mo.equals(Tag.Linux.MO_WMB) 
        		|| mo.equals(Tag.Linux.MO_RMB) ? 
        		Power.newSyncBarrier() : null;
        
        return eventSequence(
                optionalMemoryBarrier
        );
	}
}