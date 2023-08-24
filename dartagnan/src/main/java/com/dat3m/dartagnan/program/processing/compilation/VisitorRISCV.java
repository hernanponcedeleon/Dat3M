package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.google.common.base.Verify.verify;

//FIXME: Some compilations generate simple load/store operations with memory orderings, however,
// it seems that RISCV does not support mo's on arbitrary memory operations (only on LL/SC and AMOs).
class VisitorRISCV extends VisitorBase<EventFactory.RISCV> {
    // Some language memory models (e.g. RC11) are non-dependency tracking and might need a
    // strong version of no-OOTA, thus we need to strength the compilation. None of the usual paper
    // "Repairing Sequential Consistency in C/C++11"
    // "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
    // talk about compilation to RISCV, but since it is closer to ARMv8 than Power
    // we use the same scheme as AMRv8
    private final boolean useRC11Scheme;

    protected VisitorRISCV(EventFactory events, boolean useRC11Scheme) {
        super(events.withRISCV());
        this.useRC11Scheme = useRC11Scheme;
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        RMWStoreExclusive store = eventFactory.newRMWStoreConditional(e.getAddress(), e.getMemValue(), e.getMo());

        return eventSequence(
                store,
                eventFactory.newExecutionStatusWithDependencyTracking(e.getResultRegister(), store)
        );
    }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
    public List<Event> visitInitLock(InitLock e) {
        return eventSequence(
                eventFactory.newRWWFence(),
                eventFactory.newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitLock(Lock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Register dummy = e.getFunction().newRegister(type);
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can use
        // assumes. With this we miss a ctrl dependency, but this does not matter
        // because of the fence.
        return eventSequence(
                eventFactory.newRMWLoadExclusive(dummy, e.getAddress()),
                eventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                eventFactory.newRMWStoreExclusive(e.getAddress(), one, true),
                eventFactory.newRRWFence()
        );
    }

    @Override
    public List<Event> visitUnlock(Unlock e) {
        return eventSequence(
                eventFactory.newRWWFence(),
                eventFactory.newStore(e.getAddress(), expressions.makeZero((IntegerType) e.getAccessType()))
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? eventFactory.newRWRWFence() : null;
        boolean doBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo);
        Event optionalBarrierAfter = doBarrierAfter ? eventFactory.newRRWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                eventFactory.newLoad(e.getResultRegister(), e.getAddress()),
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        String mo = e.getMo();
        boolean doBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme;
        Event optionalBarrierBefore = doBarrierBefore ? eventFactory.newRWWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                eventFactory.newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = Tag.RISCV.extractLoadMoFromCMo(mo);
        String moStore = Tag.RISCV.extractStoreMoFromCMo(mo);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store =
                eventFactory.newRMWStoreConditional(address, e.getValue(), moStore, true);
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
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = Tag.RISCV.extractLoadMoFromCMo(mo);
        String moStore = Tag.RISCV.extractStoreMoFromCMo(mo);

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(type);
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreConditional(address, dummyReg, moStore, true);
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
        String loadMo = Tag.RISCV.extractLoadMoFromCMo(mo);
        String storeMo = Tag.RISCV.extractStoreMoFromCMo(mo);
        Expression expectedValue = e.getExpectedValue();

        Local casCmpResult = eventFactory.newLocal(resultRegister, expressions.makeEQ(oldValueRegister, expectedValue));
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJumpUnless(resultRegister, casEnd);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(oldValueRegister, address, loadMo);
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, e.getStoreValue(), true, storeMo);

        //TODO: We only do strong CAS here?
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
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_ACQUIRE -> eventFactory.newRRWFence();
            case Tag.C11.MO_RELEASE -> eventFactory.newRWWFence();
            case Tag.C11.MO_ACQUIRE_RELEASE -> eventFactory.newTsoFence();
            case Tag.C11.MO_SC -> eventFactory.newRWRWFence();
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
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        Expression value = e.getStoreValue();
        String mo = e.getMo();
        String moLoad = Tag.RISCV.extractLoadMoFromCMo(mo);
        String moStore = Tag.RISCV.extractStoreMoFromCMo(mo);
        Expression expectedAddr = e.getAddressOfExpected();
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
        Store storeValue = eventFactory.newRMWStoreConditional(address, value, moStore, e.isStrong());
        Register statusReg = e.getFunction().newRegister("status(" + e.getGlobalId() + ")", type);
        // We normally make the following two events optional.
        // Here we make them mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, storeValue);
        Local updateCasCmpResult = eventFactory.newLocal(booleanResultRegister, expressions.makeNot(statusReg));
        return eventSequence(
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
                casEnd,
                castResult
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moLoad = Tag.RISCV.extractLoadMoFromCMo(mo);
        String moStore = Tag.RISCV.extractStoreMoFromCMo(mo);

        Expression modifiedValue = expressions.makeBinary(resultRegister, e.getOperator(), e.getOperand());
        Register dummyReg = e.getFunction().newRegister(type);
        Local localOp = eventFactory.newLocal(dummyReg, modifiedValue);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreConditional(address, dummyReg, moStore, true);
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
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? eventFactory.newRWRWFence() : null;
        Event optionalBarrierAfter =
                Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                eventFactory.newLoad(e.getResultRegister(), e.getAddress()),
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme ?
                eventFactory.newRWWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                eventFactory.newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_ACQUIRE -> eventFactory.newRRWFence();
            case Tag.C11.MO_RELEASE -> eventFactory.newRWWFence();
            case Tag.C11.MO_ACQUIRE_RELEASE -> eventFactory.newTsoFence();
            case Tag.C11.MO_SC -> eventFactory.newRWRWFence();
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
        String moLoad = Tag.RISCV.extractLoadMoFromCMo(mo);
        String moStore = Tag.RISCV.extractStoreMoFromCMo(mo);

        Load load = eventFactory.newRMWLoadExclusiveWithMo(resultRegister, address, moLoad);
        Store store = eventFactory.newRMWStoreConditional(address, e.getValue(), moStore, true);
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
    // TODO: Many of the Linux-RMW compilations generate mo-less LL/SC instructions, though they do generated barriers.
    //  This contrasts with the compilation of C11 atomics which generate LL/SC with fitting mo.
    //  Is this mismatch intended?

    @Override
    public List<Event> visitLKMMLoad(LKMMLoad e) {
        String mo = e.getMo();
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                eventFactory.newLoad(e.getResultRegister(), e.getAddress()),
                optionalMemoryBarrier
        );

    }

    @Override
    public List<Event> visitLKMMStore(LKMMStore e) {
        String mo = e.getMo();
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newRWWFence() : null;

        return eventSequence(
                optionalMemoryBarrier,
                eventFactory.newStore(e.getAddress(), e.getMemValue())
        );

    }

    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getName()) {
            // smp_mb()
            case Tag.Linux.MO_MB,
                // https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
                // https://elixir.bootlin.com/linux/v5.18/source/arch/riscv/include/asm/barrier.h
                    Tag.Linux.BEFORE_ATOMIC, Tag.Linux.AFTER_ATOMIC -> eventFactory.newRWRWFence();
            // smp_rmb()
            case Tag.Linux.MO_RMB -> eventFactory.newRRFence();
            // smp_wmb()
            case Tag.Linux.MO_WMB -> eventFactory.newWWFence();
            // ##define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)
            // 		https://elixir.bootlin.com/linux/v6.1/source/arch/riscv/include/asm/barrier.h#L72
            // RISCV_FENCE(iorw,iorw) imposes ordering both on devices and memory
            // 		https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/barrier.h
            // Since the memory model says nothing about devices, we use RISCV_FENCE(rw,rw) which I think
            // gives the ordering we want wrt. memory
            case Tag.Linux.AFTER_SPINLOCK -> eventFactory.newRWRWFence();
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            // 		https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> eventFactory.newRWRWFence();
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default -> throw new UnsupportedOperationException(
                    String.format("Compilation of fence %s is not supported", e.getName()));
        };

        return eventSequence(
                optionalMemoryBarrier
        );
    }

    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moStore = mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "";

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        Label casEnd = eventFactory.newLabel("CAS_end");
        CondJump branchOnCasCmpResult = eventFactory.newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = eventFactory.newRMWLoadExclusive(dummy, address); // TODO: No mo on the load?
        Store store = eventFactory.newRMWStoreConditional(address, e.getStoreValue(), moStore, true);
        ExecutionStatus status = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?
        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newRWWFence() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                branchOnCasCmpResult,
                store,
                status,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter,
                casEnd,
                eventFactory.newLocal(resultRegister, dummy)
        );
    }

    // Following
    // https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
    // The linux kernel uses AMO instructions which we don't yet support
    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
        Store store = eventFactory.newRMWStoreConditional(address, e.getValue(), moStore, true);
        ExecutionStatus status = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                load,
                store,
                status,
                eventFactory.newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter
        );
    }

    // Following
    // https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
    // The linux kernel uses AMO instructions which we don't yet support
    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();
        String mo = e.getMo();
        IntegerType type = (IntegerType)e.getAccessType();

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        Expression storeValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());
        String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? Tag.RISCV.MO_ACQ : "";
        Load load = eventFactory.newRMWLoadExclusiveWithMo(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? Tag.RISCV.MO_ACQ_REL : "";
        Store store = eventFactory.newRMWStoreConditional(address, storeValue, moStore, true);
        ExecutionStatus status = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

        return eventSequence(
                load,
                store,
                status,
                fakeCtrlDep,
                label
        );
    }

    // The linux kernel uses AMO instructions which we don't yet support
    // The scheme is not described in
    // https://five-embeddev.com/riscv-isa-manual/latest/memory.html#sec:memory:porting
    // Since in VisitorArm8 this one is similar to visitRMWCmpXchg
    // we also make it scheme similar to the one of visitRMWCmpXchg in this class
    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moStore = mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "";

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        Expression modifiedValue = expressions.makeBinary(dummy, e.getOperator(), e.getOperand());

        Load load = eventFactory.newRMWLoadExclusive(dummy, address); // TODO: No mo on the load?
        Store store = eventFactory.newRMWStoreConditional(address, modifiedValue, moStore, true);
        ExecutionStatus status = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?
        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newRWWFence() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                store,
                status,
                eventFactory.newLocal(resultRegister, dummy),
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
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moStore = mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "";

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());

        Load load = eventFactory.newRMWLoadExclusive(dummy, address); // TODO: No mo on the load?
        Store store = eventFactory.newRMWStoreConditional(address, dummy, moStore, true);
        ExecutionStatus status = eventFactory.newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?
        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? eventFactory.newRWWFence() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                load,
                eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                status,
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
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();
        String moStore = mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "";

        Register regValue = e.getFunction().newRegister(type);

        Expression modifiedValue = expressions.makeADD(regValue, e.getOperand());
        Load load = eventFactory.newRMWLoadExclusive(regValue, address); // TODO: No mo on the load?
        Store store = eventFactory.newRMWStoreConditional(address, modifiedValue, moStore, true);

        // TODO: Why does this use a different fake dep (from the load) than the other RMW events (from the store)?
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(regValue, label);

        Register dummy = e.getFunction().newRegister(types.getBooleanType());
        Expression unless = e.getCmp();
        Label cauEnd = eventFactory.newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = eventFactory.newJumpUnless(dummy, cauEnd);
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

        return eventSequence(load,
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
        String moStore = mo.equals(Tag.Linux.MO_MB) ? Tag.RISCV.MO_REL : "";
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        Load load = eventFactory.newRMWLoadExclusive(dummy, address); // TODO: No mo on the load?
        Local localOp = eventFactory.newLocal(dummy, expressions.makeBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = eventFactory.newRMWStoreExclusiveWithMo(address, dummy, true, moStore);
        Local testOp = newAssignment(resultRegister, testResult);
        Label label = eventFactory.newLabel("FakeDep");
        Event fakeCtrlDep = eventFactory.newFakeCtrlDep(dummy, label);
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? eventFactory.newRWRWFence() :
                mo.equals(Tag.Linux.MO_ACQUIRE) ? eventFactory.newRRWFence() : null;

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

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Expression one = expressions.makeOne(type);
        Expression zero = expressions.makeZero(type);
        Register dummy = e.getFunction().newRegister(type);
        // From this "unofficial" source (there is no RISCV specific implementation in the kernel)
        // https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/spinlock.h
        // We replace AMO instructions with LL/SC
        return eventSequence(
                eventFactory.newRMWLoadExclusive(dummy, e.getLock()),
                eventFactory.newAssume(expressions.makeEQ(dummy, zero)),
                eventFactory.newRMWStoreExclusive(e.getLock(), one, true),
                eventFactory.newRRWFence()
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        return eventSequence(
                eventFactory.newRWWFence(),
                eventFactory.newStore(e.getAddress(), expressions.makeZero((IntegerType) e.getAccessType()))
        );
    }
}