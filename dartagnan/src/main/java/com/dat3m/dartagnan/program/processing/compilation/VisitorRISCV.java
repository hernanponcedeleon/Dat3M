package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.RISCV.*;
import static com.google.common.base.Verify.verify;

//FIXME: Some compilations generate simple load/store operations with memory orderings, however,
// it seems that RISCV does not support mo's on arbitrary memory operations (only on LL/SC and AMOs).
class VisitorRISCV extends VisitorBase {
    // Some language memory models (e.g. RC11) are non-dependency tracking and might need a
    // strong version of no-OOTA, thus we need to strength the compilation. None of the usual paper
    // "Repairing Sequential Consistency in C/C++11"
    // "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
    // talk about compilation to RISCV, but since it is closer to ARMv8 than Power
    // we use the same scheme as AMRv8
    private final boolean useRC11Scheme;

    protected VisitorRISCV(boolean useRC11Scheme) {
        this.useRC11Scheme = useRC11Scheme;
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        Store store = newCoreStoreConditional(e.getAddress(), e.getMemValue(), false, e.getMo());

        return eventSequence(
                store,
                newExecutionStatusWithDependencyTracking(e.getResultRegister(), store)
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? newRWRWFence() : null;
        Event optionalBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? newRRWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                newLoad(e.getResultRegister(), e.getAddress()),
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme
                ? newRWWFence()
                : null;

        return eventSequence(
                optionalBarrierBefore,
                newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newCoreLoadReserved(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreConditional(address, e.getValue(), true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                store
        );
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Type type = resultRegister.getType();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(type);
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newCoreLoadReserved(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreConditional(address, dummyReg, true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store
        );
    }

    @Override
    protected List<Event> newLlvmCmpXchg(Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        verify(success.getType() instanceof BooleanType, "Non-boolean success register.");

        Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        Load load = newCoreLoadReserved(oldValue, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreConditional(address, newValue, strong, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                strong ? null : newExecutionStatus(success, store),
                strong ? null : newLocal(success, expressions.makeNot(success)),
                casEnd
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_ACQUIRE         -> newRRWFence();
            case Tag.C11.MO_RELEASE         -> newRWWFence();
            case Tag.C11.MO_ACQUIRE_RELEASE -> newTsoFence();
            case Tag.C11.MO_SC              -> newRWRWFence();
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
        Expression expectedAddr = e.getAddressOfExpected();
        Register booleanResultRegister = type instanceof BooleanType ? resultRegister :
                e.getFunction().newRegister(types.getBooleanType());
        Register regExpected = e.getFunction().newRegister(type);
        Register regValue = e.getFunction().newRegister(type);

        Load loadExpected = newLoad(regExpected, expectedAddr);
        Store storeExpected = newStore(expectedAddr, regValue);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(booleanResultRegister, expressions.makeEQ(regValue, regExpected));
        CondJump branchOnCasCmpResult = newJumpUnless(booleanResultRegister, casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newCoreLoadReserved(regValue, address, extractLoadMoFromCMo(mo));
        Store storeValue = newCoreStoreConditional(address, value, e.isStrong(), extractStoreMoFromCMo(mo));
        Register statusReg = e.getFunction().newRegister("status(" + e.getLocalId() + ")", types.getBooleanType());
        // We normally make the following two events optional.
        // Here we make them mandatory to guarantee correct dependencies.
        ExecutionStatus execStatus = newExecutionStatusWithDependencyTracking(statusReg, storeValue);
        Local updateCasCmpResult = newLocal(booleanResultRegister, expressions.makeNot(statusReg));
        Local castResult = type instanceof BooleanType ? null :
                newLocal(resultRegister, expressions.makeCast(booleanResultRegister, type));
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

        Register dummyReg = e.getFunction().newRegister(type);
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newCoreLoadReserved(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreConditional(address, dummyReg, true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) ? newRWRWFence() : null;
        Event optionalBarrierAfter = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_ACQUIRE.equals(mo) ? newRRWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                newLoad(e.getResultRegister(), e.getAddress()),
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        String mo = e.getMo();
        Event optionalBarrierBefore = Tag.C11.MO_SC.equals(mo) || Tag.C11.MO_RELEASE.equals(mo) || useRC11Scheme ? newRWWFence() : null;

        return eventSequence(
                optionalBarrierBefore,
                newStore(e.getAddress(), e.getMemValue())
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_ACQUIRE         -> newRRWFence();
            case Tag.C11.MO_RELEASE         -> newRWWFence();
            case Tag.C11.MO_ACQUIRE_RELEASE -> newTsoFence();
            case Tag.C11.MO_SC              -> newRWRWFence();
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

        Load load = newCoreLoadReserved(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreConditional(address, e.getValue(), true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
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
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? newRRWFence() : null;

        return eventSequence(
                newLoad(e.getResultRegister(), e.getAddress()),
                optionalMemoryBarrier
        );

    }

    @Override
    public List<Event> visitLKMMStore(LKMMStore e) {
        String mo = e.getMo();

        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? newRWWFence() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newRWRWFence() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                newStore(e.getAddress(), e.getMemValue()),
                optionalMemoryBarrierAfter
        );

    }

    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getMo()) {
            // smp_mb()
            // https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
            // https://elixir.bootlin.com/linux/v5.18/source/arch/riscv/include/asm/barrier.h
            case Tag.Linux.MO_MB,
                 Tag.Linux.BEFORE_ATOMIC,
                 Tag.Linux.AFTER_ATOMIC -> newRWRWFence();
            // smp_rmb()
            case Tag.Linux.MO_RMB -> newRRFence();
            // smp_wmb()
            case Tag.Linux.MO_WMB -> newWWFence();
            // ##define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)
            // 		https://elixir.bootlin.com/linux/v6.1/source/arch/riscv/include/asm/barrier.h#L72
            // RISCV_FENCE(iorw,iorw) imposes ordering both on devices and memory
            // 		https://github.com/westerndigitalcorporation/RISC-V-Linux/blob/master/linux/arch/riscv/include/asm/barrier.h
            // Since the memory model says nothing about devices, we use RISCV_FENCE(rw,rw) which I think
            // gives the ordering we want wrt. memory
            case Tag.Linux.AFTER_SPINLOCK -> newRWRWFence();
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            // 		https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> newRWRWFence();
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default ->
                    throw new UnsupportedOperationException("Compilation of fence " + e.getMo() + " is not supported");
        };

        return eventSequence(
                optionalMemoryBarrier
        );
    }

    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = newCoreLoadReserved(dummy, address, ""); // TODO: No mo on the load?
        String moStore = mo.equals(Tag.Linux.MO_MB) ? MO_REL : "";
        Store store = newCoreStoreConditional(address, e.getStoreValue(), true, moStore);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

        return eventSequence(
                optionalMemoryBarrierBefore(mo),
                load,
                branchOnCasCmpResult,
                store,
                status,
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter(mo),
                casEnd,
                newLocal(resultRegister, dummy)
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
        String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? MO_ACQ : "";
        Load load = newCoreLoadReserved(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? MO_ACQ_REL : "";
        Store store = newCoreStoreConditional(address, e.getValue(), true, moStore);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

        return eventSequence(
                load,
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter(mo)
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
        Expression storeValue = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());
        String moLoad = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_ACQUIRE) ? MO_ACQ : "";
        Load load = newCoreLoadReserved(dummy, address, moLoad);
        String moStore = mo.equals(Tag.Linux.MO_MB) || mo.equals(Tag.Linux.MO_RELEASE) ? MO_ACQ_REL : "";
        Store store = newCoreStoreConditional(address, storeValue, true, moStore);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

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

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());
        Expression value = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());

        Load load = newCoreLoadReserved(dummy, address, ""); // TODO: No mo on the load?
        String moStore = mo.equals(Tag.Linux.MO_MB) ? MO_REL : "";
        Store store = newCoreStoreConditional(address, value, true, moStore);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

        return eventSequence(
                optionalMemoryBarrierBefore(mo),
                load,
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter(mo)
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

        Register dummy = e.getFunction().newRegister(type);
        Register statusReg = e.getFunction().newRegister(types.getBooleanType());

        Load load = newCoreLoadReserved(dummy, address, ""); // TODO: No mo on the load?
        String moStore = mo.equals(Tag.Linux.MO_MB) ? MO_REL : "";
        Store store = newCoreStoreConditional(address, dummy, true, moStore);
        ExecutionStatus status = newExecutionStatusWithDependencyTracking(statusReg, store);
        Label label = newLabel("FakeDep");
        Event fakeCtrlDep = newJump(statusReg, label); // TODO: Do we really need a fakedep from the store?

        return eventSequence(
                optionalMemoryBarrierBefore(mo),
                load,
                newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                status,
                newLocal(resultRegister, dummy),
                fakeCtrlDep,
                label,
                optionalMemoryBarrierAfter(mo)
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

        Register regValue = e.getFunction().newRegister(type);
        Expression value = expressions.makeAdd(regValue, e.getOperand());

        Load load = newCoreLoadReserved(regValue, address, ""); // TODO: No mo on the load?
        String moStore = mo.equals(Tag.Linux.MO_MB) ? MO_REL : "";
        Store store = newCoreStoreConditional(address, value, true, moStore);

        // TODO: Why does this use a different fake dep (from the load) than the other RMW events (from the store)?
        List<Event> fakeCtrlDep = newFakeCtrlDep(regValue);

        Register dummy = e.getFunction().newRegister(types.getBooleanType());
        Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJumpUnless(dummy, cauEnd);

        return eventSequence(
                load,
                newLocal(dummy, expressions.makeNEQ(regValue, unless)),
                branchOnCauCmpResult,
                store,
                fakeCtrlDep,
                optionalMemoryBarrierAfter(mo),
                cauEnd,
                newLocal(resultRegister, expressions.makeCast(dummy, resultRegister.getType()))
        );
    }

    // The implementation is arch_${atomic}_op_return(i, v) == 0;
    //     https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/sub_and_test
    //     https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/inc_and_test
    //     https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/dec_and_test
    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        // TODO: No mo on the load?
        String storeMo = mo.equals(Tag.Linux.MO_MB) ? MO_REL : "";

        Load load = newCoreLoadReserved(dummy, address, "");
        Local localOp = newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = newCoreStoreConditional(address, dummy, true, storeMo);
        Local testOp = newLocal(resultRegister, expressions.makeCast(testResult, resultRegister.getType()));

        return eventSequence(
                load,
                localOp,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(mo),
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
                newCoreLoadReserved(dummy, e.getLock(), ""),
                newAssume(expressions.makeEQ(dummy, zero)),
                newCoreStoreConditional(e.getLock(), one, true, ""),
                newRRWFence()
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        return eventSequence(
                newRWWFence(),
                newStore(e.getAddress(), expressions.makeZero((IntegerType)e.getAccessType()))
        );
    }

    private Event optionalMemoryBarrierBefore(String mo) {
        return switch (mo) {
            case Tag.Linux.MO_RELEASE -> newRWWFence();
            default -> null;
        };
    }

    private Event optionalMemoryBarrierAfter(String mo) {
        return switch (mo) {
            case Tag.Linux.MO_MB -> newRWRWFence();
            case Tag.Linux.MO_ACQUIRE -> newRRWFence();
            default -> null;
        };
    }

    private Load newCoreLoadReserved(Register value, Expression address, String mo) {
        return newRMWLoadExclusiveWithMo(value, address, mo);
    }

    private Store newCoreStoreConditional(Expression address, Expression value, boolean strong, String mo) {
        Store store = newRMWStoreExclusiveWithMo(address, value, strong, true, mo);
        store.addTags(STCOND);
        return store;
    }

    //TODO The following methods must return core events.
    // The respective methods in EventFactory fit now, but may produce compilable barriers in the future.

    private Event newRRFence() {
        return RISCV.newFence("r.r");
    }

    private Event newRRWFence() {
        return RISCV.newFence("r.rw");
    }

    private Event newRWWFence() {
        return RISCV.newFence("rw.w");
    }

    private Event newRWRWFence() {
        return RISCV.newFence("rw.rw");
    }

    private Event newWWFence() {
        return RISCV.newFence("w.w");
    }

    private Event newTsoFence() {
        return RISCV.newFence("tso");
    }
}