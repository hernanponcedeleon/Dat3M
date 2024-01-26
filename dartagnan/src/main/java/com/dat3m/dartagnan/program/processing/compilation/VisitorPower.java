package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
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

public class VisitorPower extends VisitorBase<EventFactory.Power> {

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

    protected VisitorPower(EventFactory events, boolean useRC11Scheme, PowerScheme cToPowerScheme) {
        super(events.withPower());
        this.useRC11Scheme = useRC11Scheme;
        this.cToPowerScheme = cToPowerScheme;
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                eventFactory.newLwSyncBarrier(),
                eventFactory.newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType) e.getAccessType();
        Register dummy = e.getFunction().newRegister(type);
        Label label = eventFactory.newLabel("FakeDep");
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
        // use assumes. The fake control dependency + isync guarantee acquire semantics.
        return eventSequence(
                eventFactory.newRMWLoadExclusive(dummy, e.getAddress()),
                eventFactory.newAssume(expressions.makeNot(expressions.makeBooleanCast(dummy))),
                eventFactory.newRMWStoreConditional(e.getAddress(), expressions.makeOne(type), true),
                // Fake dependency to guarantee acquire semantics
                eventFactory.newFakeCtrlDep(dummy, label),
                label,
                eventFactory.newISyncBarrier()
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                eventFactory.newLwSyncBarrier(),
                eventFactory.newStore(e.getAddress(), expressions.makeZero((IntegerType) e.getAccessType()))
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        Register resultRegister = e.getResultRegister();

        Event optionalBarrierBefore = null;
        Load load = eventFactory.newLoad(resultRegister, e.getAddress());
        Label optionalLabel = null;
        CondJump optionalFakeCtrlDep = null;
        Event optionalBarrierAfter = null;

        switch (e.getMo()) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalLabel = eventFactory.newLabel("FakeDep");
                    optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalLabel = eventFactory.newLabel("FakeDep");
                optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELAXED:
                if (useRC11Scheme) {
                    optionalLabel = eventFactory.newLabel("FakeDep");
                    optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
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
    public List<Event> visitLlvmStore(LlvmStore e) {
        Event optionalBarrierBefore = null;
        Store store = eventFactory.newStore(e.getAddress(), e.getMemValue());
        Event optionalBarrierAfter = null;

        switch (e.getMo()) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
        }

        return eventSequence(
                optionalBarrierBefore,
                store,
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        // Power does not have mo tags, thus we use null
        Load load = eventFactory.newRMWLoadExclusive(resultRegister, address);
        Store store = eventFactory.newRMWStoreConditional(address, e.getValue(), true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
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

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);

        // Power does not have mo tags, thus we use null
        Load load = eventFactory.newRMWLoadExclusive(resultRegister, address);
        Store store = eventFactory.newRMWStoreConditional(address, dummyReg, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

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
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
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
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);
        verify(resultRegister.getType() instanceof BooleanType);

        Expression address = e.getAddress();
        String mo = e.getMo();

        Expression isExpectedValue = expressions.makeEQ(oldValueRegister, e.getExpectedValue());
        Local casCmpResult = eventFactory.newLocal(resultRegister, isExpectedValue);
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(resultRegister, casEnd);

        Load load = eventFactory.newRMWLoadExclusive(oldValueRegister, address);
        Store store = eventFactory.newRMWStoreConditional(address, e.getStoreValue(), true);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
        }

        return eventSequence(
                optionalBarrierBefore,
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                casEnd,
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        Event fence = e.getMo().equals(Tag.C11.MO_SC) ? eventFactory.newSyncBarrier() : eventFactory.newLwSyncBarrier();

        return eventSequence(
                fence
        );
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
        Local castResult = type instanceof BooleanType ? null : newAssignment(resultRegister, booleanResultRegister);
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);
        Load loadExpected = eventFactory.newLoad(regExpected, expectedAddr);
        Store storeExpected = eventFactory.newStore(expectedAddr, regValue);
        Label casFail = eventFactory.newLabel("CAS_fail");
        Label casEnd = eventFactory.newLabel("CAS_end");
        Local casCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = eventFactory.newGoto(casEnd);
        // Power does not have mo tags, thus we use the empty string
        Load loadValue = eventFactory.newRMWLoadExclusive(regValue, address);
        Store storeValue = eventFactory.newRMWStoreConditional(address, value, e.isStrong());
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (e.isWeak()) {
            Register statusReg = e.getFunction().newRegister(types.getBooleanType());
            optionalExecStatus = eventFactory.newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeNot(statusReg));
        }
        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;
        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
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

        Expression result = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = eventFactory.newLocal(dummyReg, result);

        Load load = eventFactory.newRMWLoadExclusive(resultRegister, address);
        Store store = eventFactory.newRMWStoreConditional(address, dummyReg, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers claim.
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
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
        Load load = eventFactory.newLoad(resultRegister, address);
        Label optionalLabel = null;
        CondJump optionalFakeCtrlDep = null;
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalLabel = eventFactory.newLabel("FakeDep");
                    optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalLabel = eventFactory.newLabel("FakeDep");
                optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELAXED:
                if (useRC11Scheme) {
                    optionalLabel = eventFactory.newLabel("FakeDep");
                    optionalFakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, optionalLabel);
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
        Store store = eventFactory.newStore(address, value);
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
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
        Event fence = mo.equals(Tag.C11.MO_SC) ? eventFactory.newSyncBarrier() : eventFactory.newLwSyncBarrier();

        return eventSequence(
                fence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = eventFactory.newRMWLoadExclusive(resultRegister, address);
        Store store = eventFactory.newRMWStoreConditional(address, e.getValue(), true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

        Event optionalBarrierBefore = null;
        Event optionalBarrierAfter = null;

        switch (mo) {
            case C11.MO_SC:
                if (cToPowerScheme.equals(LEADING_SYNC)) {
                    optionalBarrierBefore = eventFactory.newSyncBarrier();
                    optionalBarrierAfter = eventFactory.newISyncBarrier();
                } else {
                    optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                    optionalBarrierAfter = eventFactory.newSyncBarrier();
                }
                break;
            case C11.MO_ACQUIRE:
                optionalBarrierAfter = eventFactory.newISyncBarrier();
                break;
            case C11.MO_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                break;
            case C11.MO_ACQUIRE_RELEASE:
                optionalBarrierBefore = eventFactory.newLwSyncBarrier();
                optionalBarrierAfter = eventFactory.newISyncBarrier();
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
        Load load = eventFactory.newLoad(resultRegister, address);
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newLwSyncBarrier() : null;

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

        Store store = eventFactory.newStore(address, value);
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrier,
                store
        );
    }

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getName()) {
            case Tag.Linux.MO_MB, Tag.Linux.MO_RMB, Tag.Linux.MO_WMB, Tag.Linux.BEFORE_ATOMIC, Tag.Linux.AFTER_ATOMIC
                    -> eventFactory.newSyncBarrier();
            // #define smp_mb__after_spinlock()	smp_mb()
            // 		https://elixir.bootlin.com/linux/v6.1/source/arch/powerpc/include/asm/spinlock.h#L14
            case Tag.Linux.AFTER_SPINLOCK -> eventFactory.newSyncBarrier();
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            // 		https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> eventFactory.newSyncBarrier();
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default -> throw new UnsupportedOperationException(
                    "Compilation of fence " + e.getName() + " is not supported");
        };

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
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreConditional(address, e.getStoreValue(), true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                branchOnCasCmpResult,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                casEnd,
                eventFactory.newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreConditional(address, e.getValue(), true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy),
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
        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreConditional(address, storeValue, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;


        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreConditional(address, dummy, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;


        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                eventFactory.newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Expression modifiedValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreConditional(address, modifiedValue, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy),
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
        Load load = eventFactory.newRMWLoadExclusive(regValue, address);
        Store store = eventFactory.newRMWStoreConditional(address, expressions.makeADD(regValue, e.getOperand()), true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(regValue, label);

        Register dummy = e.getFunction().newRegister(types.getBooleanType());
        Expression unless = e.getCmp();
        Label cauEnd = eventFactory.newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = eventFactory.newJumpUnless(dummy, cauEnd);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                eventFactory.newLocal(dummy, expressions.makeNEQ(regValue, unless)),
                branchOnCauCmpResult,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                cauEnd,
                newAssignment(resultRegister, dummy)
        );
    }

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

        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Local localOp = eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = eventFactory.newRMWStoreConditional(address, dummy, true);
        Local testOp = newAssignment(resultRegister, testResult);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newLwSyncBarrier() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newSyncBarrier() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newISyncBarrier() : null;


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

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Register dummy = e.getFunction().newRegister(type);
        Label label = eventFactory.newLabel("FakeDep");
        // Spinlock events are guaranteed to succeed, i.e. we can use assumes
        return eventSequence(
                eventFactory.newRMWLoadExclusive(dummy, e.getLock()),
                eventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                eventFactory.newRMWStoreConditional(e.getLock(), one, true),
                // Fake dependency to guarantee acquire semantics
                eventFactory.newFakeCtrlDep(dummy, label),
                label,
                eventFactory.newISyncBarrier()
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        return eventSequence(
                eventFactory.newLwSyncBarrier(),
                eventFactory.newStore(e.getAddress(), expressions.makeZero((IntegerType) e.getAccessType()))
        );
    }

    public enum PowerScheme {

        LEADING_SYNC, TRAILING_SYNC

    }
}