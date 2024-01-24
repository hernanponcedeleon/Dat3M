package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.ARMv8;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.AArch64.Option.*;
import static com.google.common.base.Verify.verify;

class VisitorArm8 extends VisitorBase<EventFactory.AArch64> {

    // If the source WMM does not allow OOTA behaviors (e.g. RC11)
    // we need to strength the compilation following the paper
    // "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
    private final boolean useRC11Scheme;

    protected VisitorArm8(EventFactory events, boolean useRC11Scheme) {
        super(events.withAArch64());
        this.useRC11Scheme = useRC11Scheme;
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        Event store = eventFactory.newRMWStoreExclusiveWithMo(e.getAddress(), e.getMemValue(), false, e.getMo());

        return eventSequence(
                store,
                eventFactory.newExecutionStatus(e.getResultRegister(), store)
        );
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), ARMv8.MO_REL)
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Register dummy = e.getFunction().newRegister(type);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can use
        // assumes. With this we miss a ctrl dependency, but this does not matter
        // because the load is an acquire one.
        return eventSequence(
                eventFactory.newRMWLoadExclusiveWithMo(dummy, e.getAddress(), ARMv8.MO_ACQ),
                eventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                eventFactory.newRMWStoreExclusive(e.getAddress(), one, true)
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(),
                expressions.makeZero((IntegerType) e.getAccessType()),
                ARMv8.MO_REL)
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        String mo = ARMv8.extractLoadMoFromCMo(e.getMo());
        Load load = eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), mo);

        return eventSequence(
                load
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        String mo = ARMv8.extractStoreMoFromCMo(e.getMo());
        Store store = eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), mo);

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromCMo(mo);
        String moStore = ARMv8.extractStoreMoFromCMo(mo);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getValue(), true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

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
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromCMo(mo);
        String moStore = ARMv8.extractStoreMoFromCMo(mo);

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummyReg, true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

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
        verify(resultRegister.getType() instanceof BooleanType);

        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromCMo(mo);
        String moStore = ARMv8.extractStoreMoFromCMo(mo);
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = eventFactory.newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(resultRegister, casEnd);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(oldValueRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, moStore);

        return eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                casEnd
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        final Event fence = switch (e.getMo()) {
            case C11.MO_RELEASE, C11.MO_ACQUIRE_RELEASE, C11.MO_SC -> eventFactory.newDataMemoryBarrier(ISH);
            case C11.MO_ACQUIRE -> eventFactory.newDataSynchronizationBarrier(ISHLD);
            default -> null;
        };

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
        String moLoad = ARMv8.extractLoadMoFromCMo(mo);
        String moStore = ARMv8.extractStoreMoFromCMo(mo);
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
        Load loadValue = eventFactory.newRMWLoadExclusiveWithMo(regValue, address, moLoad);
        Store storeValue = eventFactory.newRMWStoreExclusiveWithMo(address, value, e.isStrong(), moStore);
        ExecutionStatus optionalExecStatus = null;
        Local optionalUpdateCasCmpResult = null;
        if (e.isWeak()) {
            Register statusReg = e.getFunction().newRegister("status(" + e.getGlobalId() + ")", types.getBooleanType());
            optionalExecStatus = eventFactory.newExecutionStatus(statusReg, storeValue);
            optionalUpdateCasCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeNot(statusReg));
        }
        return eventSequence(
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
                castResult
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, ARMv8.extractLoadMoFromCMo(mo));
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummyReg, true, ARMv8.extractStoreMoFromCMo(mo));
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

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
        String mo = ARMv8.extractLoadMoFromCMo(e.getMo());
        return eventSequence(
                eventFactory.newLoadWithMo(e.getResultRegister(), e.getAddress(), mo)
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = useRC11Scheme ? ARMv8.MO_REL : ARMv8.extractStoreMoFromCMo(e.getMo());
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), e.getMemValue(), mo)
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        final Event fence = switch(e.getMo()) {
            case C11.MO_RELEASE, C11.MO_ACQUIRE_RELEASE, C11.MO_SC -> eventFactory.newDataMemoryBarrier(ISH);
            case C11.MO_ACQUIRE -> eventFactory.newDataSynchronizationBarrier(ISHLD);
            default -> null;
        };

        return eventSequence(
                fence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromCMo(mo);
        String moStore = ARMv8.extractStoreMoFromCMo(mo);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getValue(), true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(resultRegister, label);

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
        String mo = ARMv8.extractLoadMoFromLKMo(e.getMo());

        Load load = eventFactory.newLoadWithMo(resultRegister, address, mo);

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
        String mo = e.getMo().equals(Tag.Linux.MO_RELEASE) ? Tag.ARMv8.MO_REL : "";

        Store store = eventFactory.newStoreWithMo(address, value, mo);

        return eventSequence(
                store
        );
    }

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getName()) {
            // mb()
            case Tag.Linux.MO_MB -> eventFactory.newDataSynchronizationBarrier(ISH);
            // rmb()
            case Tag.Linux.MO_RMB -> eventFactory.newDataSynchronizationBarrier(ISHLD);
            // wmb()
            case Tag.Linux.MO_WMB -> eventFactory.newDataSynchronizationBarrier(ISHST);
            // __smp_mb()
            // 		https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
            case Tag.Linux.BEFORE_ATOMIC, Tag.Linux.AFTER_ATOMIC -> eventFactory.newDataMemoryBarrier(ISH);
            // #define smp_mb__after_spinlock()	smp_mb()
            //              https://elixir.bootlin.com/linux/v6.1/source/arch/arm64/include/asm/spinlock.h#L12
            case Tag.Linux.AFTER_SPINLOCK -> eventFactory.newDataSynchronizationBarrier(ISH);
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            //              https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> eventFactory.newDataSynchronizationBarrier(ISH);
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default -> throw new UnsupportedOperationException(
                    String.format("Compilation of fence %s is not supported", e.getName()));
        };

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
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromLKMo(mo);
        String moStore = ARMv8.extractStoreMoFromLKMo(mo);

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Label casEnd = eventFactory.newLabel("CAS_end");
        // The real scheme uses XOR instead of comparison, but both are semantically
        // equivalent and XOR harms performance substantially.
        CondJump branchOnCasCmpResult = eventFactory.newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = newMemoryBarrierAfter(mo);

        return eventSequence(
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

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/cmpxchg.h#L21
    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromLKMo(mo);
        String moStore = ARMv8.extractStoreMoFromLKMo(mo);

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getValue(), true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = newMemoryBarrierAfter(mo);

        return eventSequence(
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L38
    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadExclusive(dummy, address);
        Store store = eventFactory.newRMWStoreExclusive(address, storeValue, true);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);

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
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, ARMv8.extractLoadMoFromLKMo(mo));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummy, true, ARMv8.extractStoreMoFromLKMo(mo));
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newDataMemoryBarrier(ISH) : null;

        return eventSequence(
                load,
                eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                eventFactory.newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    ;

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L78
    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromLKMo(mo);
        String moStore = ARMv8.extractStoreMoFromLKMo(mo);

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Expression modifiedValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, modifiedValue, true, moStore);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = newMemoryBarrierAfter(mo);

        return eventSequence(
                load,
                store,
                eventFactory.newLocal(resultRegister, dummy),
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
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = ARMv8.extractLoadMoFromLKMo(mo);
        String moStore = ARMv8.extractStoreMoFromLKMo(mo);
        Type type = resultRegister.getType();

        Register regValue = e.getFunction().newRegister(type);
        Expression modifiedValue = expressions.makeADD(regValue, e.getOperand());
        Load load = eventFactory.newRMWLoadExclusiveWithMo(regValue, address, moLoad);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, modifiedValue, true, moStore);

        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(regValue, label);

        Register dummy = e.getFunction().newRegister(type);
        Expression unless = e.getCmp();
        Label cauEnd = eventFactory.newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = eventFactory.newJumpUnless(expressions.makeBooleanCast(dummy), cauEnd);
        Event optionalMemoryBarrierAfter = newMemoryBarrierAfter(mo);

        return eventSequence(
                load,
                newAssignment(dummy, expressions.makeNEQ(regValue, unless)),
                branchOnCauCmpResult,
                store,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                cauEnd,
                eventFactory.newLocal(resultRegister, dummy)
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
        String moLoad = ARMv8.extractLoadMoFromLKMo(mo);
        String moStore = ARMv8.extractStoreMoFromLKMo(mo);
        Register dummy = e.getFunction().newRegister(e.getAccessType());

        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        Local localOp = eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummy, true, moStore);
        Local testOp = newAssignment(resultRegister, expressions.makeNot(expressions.makeBooleanCast(dummy)));
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = newMemoryBarrierAfter(mo);

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
        IntegerType type = (IntegerType) e.getAccessType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Register dummy = e.getFunction().newRegister(type);
        // Spinlock events are guaranteed to succeed, i.e. we can use assumes
        // With this we miss a ctrl dependency, but this does not matter
        // because the load is an acquire one.
        return eventSequence(
                eventFactory.newRMWLoadExclusiveWithMo(dummy, e.getLock(), ARMv8.MO_ACQ),
                eventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                eventFactory.newRMWStoreExclusive(e.getLock(), one, true)
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        Expression zero = expressions.makeZero((IntegerType)e.getAccessType());
        return eventSequence(
                eventFactory.newStoreWithMo(e.getAddress(), zero, ARMv8.MO_REL)
        );
    }

    private Event newMemoryBarrierAfter(String mo) {
        return mo.equals(Tag.Linux.MO_MB) ? eventFactory.newDataMemoryBarrier(ISH) : null;
    }
}