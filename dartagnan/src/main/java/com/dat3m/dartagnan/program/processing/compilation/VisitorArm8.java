package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.ARMv8;
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
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = newRMWStoreExclusive(e.getAddress(), e.getMemValue(), e.getMo());

        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
        );
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.ARMv8.MO_REL);
        store.addTags(C11.PTHREAD);

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitEnd(End e) {
        return eventSequence(
                newStore(e.getAddress(), zero, Tag.ARMv8.MO_REL)
        );
    }

    @Override
    public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoad(resultRegister, e.getAddress(), Tag.ARMv8.MO_ACQ);
        load.addTags(C11.PTHREAD);

        return eventSequence(
                load,
                newJumpUnless(expressions.makeBinary(resultRegister, EQ, zero), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoad(resultRegister, e.getAddress(), Tag.ARMv8.MO_ACQ);
        load.addTags(Tag.STARTLOAD);

        return eventSequence(
                load,
                super.visitStart(e),
                newJumpUnless(expressions.makeBinary(resultRegister, EQ, one), (Label) e.getThread().getExit())
        );
    }

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                newStore(e.getAddress(), e.getMemValue(), ARMv8.MO_REL));
    }

    @Override
    public List<Event> visitLock(Lock e) {
        Register dummy = e.getThread().newRegister(archType);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can use
        // assumes. With this we miss a ctrl dependency, but this does not matter
        // because the load is an acquire one.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getAddress(), ARMv8.MO_ACQ),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, zero)),
                newRMWStoreExclusive(e.getAddress(), one, "", true));
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                newStore(e.getAddress(), zero, ARMv8.MO_REL));
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        Load load = newLoad(e.getResultRegister(), e.getAddress(), ARMv8.extractLoadMoFromCMo(e.getMo()));

        return eventSequence(
                load
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), ARMv8.extractStoreMoFromCMo(e.getMo()));

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
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
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        IOpBin op = e.getOp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

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
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        Register oldValueRegister = e.getStructRegister(0);
        Register resultRegister = e.getStructRegister(1);

        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(oldValueRegister, EQ, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, one), casEnd);

        Load load = newRMWLoadExclusive(oldValueRegister, address, ARMv8.extractLoadMoFromCMo(mo));
        Store store = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromCMo(mo), true);

        return eventSequence(
                // Indentation shows the branching structure
                load,
                casCmpResult,
                branchOnCasCmpResult,
                    store,
                casEnd
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        String mo = e.getMo();
        Fence fence = mo.equals(C11.MO_RELEASE) || mo.equals(C11.MO_ACQUIRE_RELEASE) || mo.equals(C11.MO_SC) ?
                AArch64.DMB.newISHBarrier() :
                mo.equals(C11.MO_ACQUIRE) ?
                        AArch64.DSB.newISHLDBarrier() :
                        null;

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

        Load loadValue = newRMWLoadExclusive(regValue, address, ARMv8.extractLoadMoFromCMo(mo));
        Store storeValue = newRMWStoreExclusive(address, value, ARMv8.extractStoreMoFromCMo(mo), e.isStrong());
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (e.isWeak()) {
            Register statusReg = e.getThread().newRegister("status(" + e.getGlobalId() + ")", type);
            optionalExecStatus = newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = newLocal(resultRegister, expressions.makeNot(statusReg));
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
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

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
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
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

    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/barrier.h#L151
    @Override
    public List<Event> visitLKMMLoad(LKMMLoad e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
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
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Store store = newStore(address, value, mo.equals(Tag.Linux.MO_RELEASE) ? Tag.ARMv8.MO_REL : "");

        return eventSequence(
                store
        );
    }

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Fence optionalMemoryBarrier;
        switch (e.getName()) {
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
            // #define smp_mb__after_spinlock()	smp_mb()
            //              https://elixir.bootlin.com/linux/v6.1/source/arch/arm64/include/asm/spinlock.h#L12
            case Tag.Linux.AFTER_SPINLOCK:
                optionalMemoryBarrier = AArch64.DSB.newISHBarrier();
                break;
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            //              https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK:
                optionalMemoryBarrier = AArch64.DSB.newISHBarrier();
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
        Expression address = e.getAddress();
        Expression value = e.getMemValue();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        // The real scheme uses XOR instead of comparison, but both are semantically
        // equivalent and XOR harms performance substantially.
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(dummy, NEQ, e.getCmp()), casEnd);

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
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
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
        Expression value = e.getMemValue();
        Expression address = e.getAddress();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address, "");
        Store store = newRMWStoreExclusive(address, expressions.makeBinary(dummy, op, value), "", true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);

        return eventSequence(
                load,
                store,
                fakeCtrlDep,
                label
        );
    }

    ;

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L56
    @Override
    public List<Event> visitRMWOpReturn(RMWOpReturn e) {
        Register resultRegister = e.getResultRegister();
        IOpBin op = e.getOp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, dummy, ARMv8.extractStoreMoFromLKMo(mo), true);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(dummy, label);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                load,
                newLocal(dummy, expressions.makeBinary(dummy, op, value)),
                store,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    ;

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L78
    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoadExclusive(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, expressions.makeBinary(dummy, e.getOp(), value), ARMv8.extractStoreMoFromLKMo(mo), true);
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
        Expression address = e.getAddress();
        Expression value = e.getMemValue();
        String mo = e.getMo();
        Type type = resultRegister.getType();

        Register regValue = e.getThread().newRegister(type);
        Load load = newRMWLoadExclusive(regValue, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = newRMWStoreExclusive(address, expressions.makeBinary(regValue, IOpBin.PLUS, value), ARMv8.extractStoreMoFromLKMo(mo), true);

        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newFakeCtrlDep(regValue, label);

        Register dummy = e.getThread().newRegister(type);
        Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJump(expressions.makeBinary(dummy, EQ, expressions.makeZero(type)), cauEnd);
        Fence optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? AArch64.DMB.newISHBarrier() : null;

        return eventSequence(
                // Indentation shows the branching structure
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
    }

    ;

    // The implementation is arch_${atomic}_op_return(i, v) == 0;
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/sub_and_test
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/inc_and_test
    // 		https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/dec_and_test
    @Override
    public List<Event> visitRMWOpAndTest(RMWOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        IOpBin op = e.getOp();
        Expression value = e.getMemValue();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getThread().newRegister(type);
        Register retReg = e.getThread().newRegister(type);
        Local localOp = newLocal(retReg, expressions.makeBinary(dummy, op, value));
        Local testOp = newLocal(resultRegister, expressions.makeBinary(retReg, EQ, expressions.makeZero(type)));

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
    }

    ;

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        Register dummy = e.getThread().newRegister(archType);
        // Spinlock events are guaranteed to succeed, i.e. we can use assumes
        // With this we miss a ctrl dependency, but this does not matter
        // because the load is an acquire one.
        return eventSequence(
                newRMWLoadExclusive(dummy, e.getLock(), ARMv8.MO_ACQ),
                newAssume(expressions.makeBinary(dummy, COpBin.EQ, zero)),
                newRMWStoreExclusive(e.getLock(), one, "", true)
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        return eventSequence(
                newStore(e.getAddress(), zero, ARMv8.MO_REL)
        );
    }

}