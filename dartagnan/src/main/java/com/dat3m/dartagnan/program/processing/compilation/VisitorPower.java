package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme.LEADING_SYNC;
import static com.google.common.base.Verify.verify;

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

    protected VisitorPower(boolean useRC11Scheme, PowerScheme cToPowerScheme) {
        this.useRC11Scheme = useRC11Scheme;
        this.cToPowerScheme = cToPowerScheme;
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                Power.newLwSyncBarrier(),
                newStore(e.getAddress(), e.getMemValue()));
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType) e.getAccessType();
        Register dummy = e.getFunction().newRegister(type);
        Label label = newLabel("FakeDep");
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
        // use assumes. The fake control dependency + isync guarantee acquire semantics.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getAddress()),
                newAssume(expressions.makeNot(expressions.makeBooleanCast(dummy))),
                Power.newRMWStoreConditional(e.getAddress(), expressions.makeOne(type), true),
                // Fake dependency to guarantee acquire semantics
                newFakeCtrlDep(dummy, label),
                label,
                Power.newISyncBarrier());
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                Power.newLwSyncBarrier(),
                newStore(e.getAddress(), expressions.makeZero((IntegerType)e.getAccessType())));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        Register resultRegister = e.getResultRegister();

        Event optionalBarrierBefore = null;
        Load load = newLoad(resultRegister, e.getAddress());
        Label optionalLabel = null;
        CondJump optionalFakeCtrlDep = null;
        Event optionalBarrierAfter = null;

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
        Event optionalBarrierBefore = null;
        Store store = newStore(e.getAddress(), e.getMemValue());
        Event optionalBarrierAfter = null;

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
        Load load = newRMWLoadExclusive(resultRegister, address);
        Store store = Power.newRMWStoreConditional(address, e.getValue(), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

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

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand()));

        // Power does not have mo tags, thus we use null
        Load load = newRMWLoadExclusive(resultRegister, address);
        Store store = Power.newRMWStoreConditional(address, dummyReg, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync
        // barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers
        // claim.
        Event optionalBarrierAfter = null;

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
        verify(resultRegister.getType() instanceof BooleanType);

        Expression address = e.getAddress();
        String mo = e.getMo();

        Local casCmpResult = newLocal(resultRegister, expressions.makeEQ(oldValueRegister, e.getExpectedValue()));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(resultRegister, casEnd);

        Load load = newRMWLoadExclusive(oldValueRegister, address);
        Store store = Power.newRMWStoreConditional(address, e.getStoreValue(), true);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

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
                casCmpResult,
                branchOnCasCmpResult,
                store,
                casEnd,
                optionalBarrierAfter);
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        Event fence = e.getMo().equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : Power.newLwSyncBarrier();

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
        Expression value = e.getStoreValue();
        String mo = e.getMo();
        Expression expectedAddr = e.getAddressOfExpected();
        Type type = resultRegister.getType();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Local castResult = type instanceof BooleanType ? null :
                newLocal(resultRegister, expressions.makeCast(booleanResultRegister, type));
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr);
        Store storeExpected = newStore(expectedAddr, regValue);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        // Power does not have mo tags, thus we use the empty string
        Load loadValue = newRMWLoadExclusive(regValue, address);
        Store storeValue = Power.newRMWStoreConditional(address, value, e.isStrong());
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (e.isWeak()) {
            Register statusReg = e.getFunction().newRegister(types.getBooleanType());
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(booleanResultRegister, expressions.makeNot(statusReg));
        }
        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;
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
                optionalBarrierAfter,
                castResult
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newRMWLoadExclusive(resultRegister, address);
        Store store = Power.newRMWStoreConditional(address, dummyReg, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers claim.
        Event optionalBarrierAfter = null;

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
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Event optionalBarrierBefore = null;
        Load load = newLoad(resultRegister, address);
        Label optionalLabel = null;
        CondJump optionalFakeCtrlDep = null;
        Event optionalBarrierAfter = null;

        switch (mo) {
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
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Event optionalBarrierBefore = null;
        Store store = newStore(address, value);
        Event optionalBarrierAfter = null;

        switch (mo) {
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
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        String mo = e.getMo();
        Event fence = mo.equals(Tag.C11.MO_SC) ? Power.newSyncBarrier() : Power.newLwSyncBarrier();

        return eventSequence(
                fence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newRMWLoadExclusive(resultRegister, address);
        Store store = Power.newRMWStoreConditional(address, e.getValue(), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

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
        Load load = newLoad(resultRegister, address);
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newLwSyncBarrier() : null;

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

        Store store = newStore(address, value);
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrier,
                store
        );
    }

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier;
        switch (e.getName()) {
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
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER:
                optionalMemoryBarrier = null;
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
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = newRMWLoadExclusive(dummy, address);
        Store store = Power.newRMWStoreConditional(address, e.getStoreValue(), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;

        return eventSequence(
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
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address);
        Store store = Power.newRMWStoreConditional(address, e.getValue(), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;

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
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(dummy, address);
        Store store = Power.newRMWStoreConditional(address, storeValue, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;


        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    ;

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address);
        Store store = Power.newRMWStoreConditional(address, dummy, true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;


        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    ;

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address);
        Store store = Power.newRMWStoreConditional(address, expressions.makeBinary(dummy, e.getOperator(), e.getOperand()), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;

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
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Type type = resultRegister.getType();

        Register regValue = e.getFunction().newRegister(type);
        // Power does not have mo tags, thus we use the empty string
        Load load = newRMWLoadExclusive(regValue, address);
        Store store = Power.newRMWStoreConditional(address, expressions.makeADD(regValue, e.getOperand()), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getFunction().newRegister(types.getBooleanType());
        Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJumpUnless(dummy, cauEnd);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                newLocal(dummy, expressions.makeNEQ(regValue, unless)),
                branchOnCauCmpResult,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                cauEnd,
                newLocal(resultRegister, expressions.makeCast(dummy, resultRegister.getType()))
        );
    }

    ;

    // The implementation is arch_${atomic}_op_return(i, v) == 0;
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/sub_and_test
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/inc_and_test
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/dec_and_test
    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        Load load = newRMWLoadExclusive(dummy, address);
        Local localOp = newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = Power.newRMWStoreConditional(address, dummy, true);
        Local testOp = newLocal(resultRegister, expressions.makeCast(testResult, resultRegister.getType()));
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_RELEASE) ? Power.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? Power.newSyncBarrier()
                : mo.equals(Tag.Linux.MO_ACQUIRE) ? Power.newISyncBarrier() : null;


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
    }

    ;

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Register dummy = e.getFunction().newRegister(type);
        Label label = newLabel("FakeDep");
        // Spinlock events are guaranteed to succeed, i.e. we can use assumes
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getLock()),
                newAssume(expressions.makeEQ(dummy, zero)),
                Power.newRMWStoreConditional(e.getLock(), one, true),
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
                newStore(e.getAddress(), expressions.makeZero((IntegerType)e.getAccessType()))
        );
    }

    public enum PowerScheme {

        LEADING_SYNC, TRAILING_SYNC;

    }
}