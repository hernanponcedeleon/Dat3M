package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.ARMv8.*;
import static com.google.common.base.Verify.verify;

class VisitorArm8 extends VisitorBase {

    // If the source WMM does not allow OOTA behaviors (e.g. RC11)
    // we need to strength the compilation following the paper
    // "Outlawing Ghosts: Avoiding Out-of-Thin-Air Results"
    private final boolean useRC11Scheme;

    protected VisitorArm8(boolean useRC11Scheme) {
        this.useRC11Scheme = useRC11Scheme;
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        Store store = newCoreStoreExclusive(e.getAddress(), e.getMemValue(), false, e.getMo());

        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
        );
    }

    @Override
    public List<Event> visitXchg(Xchg xchg) {
        final Register resultRegister = xchg.getResultRegister();
        final Expression address = xchg.getAddress();
        final String loadMo = xchg.hasTag(MO_ACQ) ? MO_ACQ : "";
        final String storeMo = xchg.hasTag(MO_REL) ? MO_REL : "";

        final Register dummy = xchg.getFunction().newRegister(resultRegister.getType());

        return eventSequence(
                propagateNoRet(xchg, newCoreLoadExclusive(dummy, address, loadMo)),
                newCoreStoreExclusive(address, xchg.getValue(), true, storeMo),
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitCas(CAS cas) {
        final Register resultRegister = cas.getResultRegister();
        final Expression address = cas.getAddress();

        final String loadMo = cas.hasTag(MO_ACQ) ? MO_ACQ : "";
        final String storeMo = cas.hasTag(MO_REL) ? MO_REL : "";

        final Register dummy = cas.getFunction().newRegister(resultRegister.getType());
        final Load load = propagateNoRet(cas, newRMWLoadWithMo(dummy, address, loadMo));
        final Store store = newRMWStoreWithMo(load, address, cas.getStoreValue(), storeMo);
        final Expression cmp = expressions.makeEQ(dummy, cas.getExpectedValue());
        final Label casEnd = newLabel("CAS_end");

        return eventSequence(
                load,
                newJumpUnless(cmp, casEnd),
                store,
                casEnd,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitRMWOp(RMWOp rmwOp) {
        Preconditions.checkArgument(!rmwOp.hasTag(MO_ACQ), "Unexpected MO_ACQ tag for RMWOp");

        final Expression address = rmwOp.getAddress();
        final String storeMo = rmwOp.hasTag(MO_REL) ? MO_REL : "";

        final Register dummy = rmwOp.getFunction().newRegister(rmwOp.getAccessType());
        final Load load = newRMWLoad(dummy, address);
        load.addTags(NO_RET);
        final Expression value = expressions.makeBinary(dummy, rmwOp.getOperator(), rmwOp.getOperand());

        return eventSequence(
                load,
                newRMWStoreWithMo(load, address, value, storeMo)
        );
    }

    @Override
    public List<Event> visitRMWFetchOp(RMWFetchOp rmwOp) {
        final Register resultRegister = rmwOp.getResultRegister();
        final Expression address = rmwOp.getAddress();
        final String loadMo = rmwOp.hasTag(MO_ACQ) ? MO_ACQ : "";
        final String storeMo = rmwOp.hasTag(MO_REL) ? MO_REL : "";

        final Register dummy = rmwOp.getFunction().newRegister(resultRegister.getType());
        final Load load = propagateNoRet(rmwOp, newRMWLoadWithMo(dummy, address, loadMo));
        final Expression value = expressions.makeBinary(dummy, rmwOp.getOperator(), rmwOp.getOperand());

        return eventSequence(
                propagateNoRet(rmwOp, load),
                newRMWStoreWithMo(load, address, value, storeMo),
                newLocal(resultRegister, dummy)
        );
    }

    private <T extends Load> T propagateNoRet(Event orig, T newEv) {
        if (orig.hasTag(NO_RET)) {
            newEv.addTags(NO_RET);
        }
        return newEv;
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        Load load = newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMoFromCMo(e.getMo()));

        return eventSequence(
                load
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        Store store = newStoreWithMo(e.getAddress(), e.getMemValue(), extractStoreMoFromCMo(e.getMo()));

        return eventSequence(
                store
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Load load = newCoreLoadExclusive(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreExclusive(address, e.getValue(), true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                store
        );
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newCoreLoadExclusive(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreExclusive(address, dummyReg, true, extractStoreMoFromCMo(mo));

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

        final Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        final Label casEnd = newLabel("CAS_end");
        final CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        final Load load = newCoreLoadExclusive(oldValue, address, extractLoadMoFromCMo(mo));
        final Store store = newCoreStoreExclusive(address, newValue, strong, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                strong ? null : newAssignExecutionStatus(success, store),
                casEnd
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_RELEASE, Tag.C11.MO_ACQUIRE_RELEASE, Tag.C11.MO_SC -> newDmbIsh();
            case Tag.C11.MO_ACQUIRE -> newDsbIshLd();
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
        Load loadValue = newCoreLoadExclusive(regValue, address, extractLoadMoFromCMo(mo));
        Store storeValue = newCoreStoreExclusive(address, value, e.isStrong(), extractStoreMoFromCMo(mo));
        return eventSequence(
                loadExpected,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                storeValue,
                e.isStrong() ? null : newAssignExecutionStatus(booleanResultRegister, storeValue),
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

        Load load = newCoreLoadExclusive(resultRegister, address, extractLoadMoFromCMo(mo));
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));
        Store store = newCoreStoreExclusive(address, dummyReg, true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
                newLoadWithMo(e.getResultRegister(), e.getAddress(), extractLoadMoFromCMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        return eventSequence(
                newStoreWithMo(e.getAddress(), e.getMemValue(), useRC11Scheme ? MO_REL : extractStoreMoFromCMo(e.getMo()))
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Event fence = switch (e.getMo()) {
            case Tag.C11.MO_RELEASE, Tag.C11.MO_ACQUIRE_RELEASE, Tag.C11.MO_SC -> newDmbIsh();
            case Tag.C11.MO_ACQUIRE -> newDsbIshLd();
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

        Load load = newCoreLoadExclusive(resultRegister, address, extractLoadMoFromCMo(mo));
        Store store = newCoreStoreExclusive(address, e.getValue(), true, extractStoreMoFromCMo(mo));

        return eventSequence(
                load,
                newFakeCtrlDep(resultRegister),
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

        Load load = newLoadWithMo(resultRegister, address, extractLoadMoFromLKMo(mo));

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

        Store store = newStoreWithMo(address, value, mo.equals(Tag.Linux.MO_RELEASE) ? MO_REL : "");
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_MB) ? newDsbIsh() : null;

        return eventSequence(
                store,
                optionalMemoryBarrier
        );
    }

    // Following
    //		https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getMo()) {
            // mb()
            case Tag.Linux.MO_MB -> newDsbIsh();
            // rmb()
            case Tag.Linux.MO_RMB -> newDsbIshLd();
            // wmb()
            case Tag.Linux.MO_WMB -> newDsbIshSt();
            // __smp_mb()
            // 		https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
            case Tag.Linux.BEFORE_ATOMIC,
                 Tag.Linux.AFTER_ATOMIC -> newDmbIsh();
            // #define smp_mb__after_spinlock()	smp_mb()
            //              https://elixir.bootlin.com/linux/v6.1/source/arch/arm64/include/asm/spinlock.h#L12
            case Tag.Linux.AFTER_SPINLOCK -> newDsbIsh();
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            //              https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> newDsbIsh();
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default -> throw new UnsupportedOperationException("Compilation of fence " + e.getMo() + " is not supported");
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

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        // The real scheme uses XOR instead of comparison, but both are semantically
        // equivalent and XOR harms performance substantially.
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = newCoreLoadExclusive(dummy, address, extractLoadMoFromLKMo(mo));
        Store store = newCoreStoreExclusive(address, e.getStoreValue(), true, extractStoreMoFromLKMo(mo));
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                branchOnCasCmpResult,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter,
                casEnd,
                newLocal(resultRegister, dummy)
        );
    }

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/cmpxchg.h#L21
    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newCoreLoadExclusive(dummy, address, extractLoadMoFromLKMo(mo));
        Store store = newCoreStoreExclusive(address, e.getValue(), true, extractStoreMoFromLKMo(mo));
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter
        );
    }

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L38
    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());
        Load load = newCoreLoadExclusive(dummy, address, "");
        Store store = newCoreStoreExclusive(address, storeValue, true, "");

        return eventSequence(
                load,
                store,
                newFakeCtrlDep(dummy)
        );
    }

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L56
    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newCoreLoadExclusive(dummy, address, extractLoadMoFromLKMo(mo));
        Store store = newCoreStoreExclusive(address, dummy, true, extractStoreMoFromLKMo(mo));
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter
        );
    }

    // Following
    // 		https://elixir.bootlin.com/linux/v5.18/source/arch/arm64/include/asm/atomic_ll_sc.h#L78
    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Expression value = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());
        Load load = newCoreLoadExclusive(dummy, address, extractLoadMoFromLKMo(mo));
        Store store = newCoreStoreExclusive(address, value, true, extractStoreMoFromLKMo(mo));
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
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
        Type type = resultRegister.getType();

        Register regValue = e.getFunction().newRegister(type);
        Expression value = expressions.makeAdd(regValue, e.getOperand());
        Load load = newCoreLoadExclusive(regValue, address, extractLoadMoFromLKMo(mo));
        Store store = newCoreStoreExclusive(address, value, true, extractStoreMoFromLKMo(mo));

        Register dummy = e.getFunction().newRegister(type);
        Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJumpUnless(expressions.makeBooleanCast(dummy), cauEnd);
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                newLocal(dummy, expressions.makeCast(expressions.makeNEQ(regValue, unless), dummy.getType())),
                branchOnCauCmpResult,
                store,
                newFakeCtrlDep(regValue),
                optionalMemoryBarrierAfter,
                cauEnd,
                newLocal(resultRegister, dummy)
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

        Load load = newCoreLoadExclusive(dummy, address, extractLoadMoFromLKMo(mo));
        Local localOp = newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = newCoreStoreExclusive(address, dummy, true, extractStoreMoFromLKMo(mo));
        Local testOp = newLocal(resultRegister, expressions.makeCast(testResult, resultRegister.getType()));
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newDmbIsh() : null;

        return eventSequence(
                load,
                localOp,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter,
                testOp
        );
    }

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
                newCoreLoadExclusive(dummy, e.getLock(), MO_ACQ),
                newAssume(expressions.makeEQ(dummy, zero)),
                newCoreStoreExclusive(e.getLock(), one, true, "")
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        Expression zero = expressions.makeZero((IntegerType)e.getAccessType());
        return eventSequence(
                newStoreWithMo(e.getAddress(), zero, MO_REL)
        );
    }

    private List<Event> newAssignExecutionStatus(Register register, Event store) {
        final Register status = register.getFunction().newUniqueRegister("status", types.getBooleanType());
        return List.of(
                newExecutionStatus(status, store),
                newLocal(register, expressions.makeNot(status))
        );
    }

    private Load newCoreLoadExclusive(Register value, Expression address, String mo) {
        return newRMWLoadExclusiveWithMo(value, address, mo);
    }

    private Store newCoreStoreExclusive(Expression address, Expression value, boolean strong, String mo) {
        return newRMWStoreExclusiveWithMo(address, value, strong, false, mo);
    }

    private Event newDmbIsh() {
        return AArch64.newBarrier("DMB", "ISH");
    }

    private Event newDsbIsh() {
        return AArch64.newBarrier("DSB", "ISH");
    }

    private Event newDsbIshLd() {
        return AArch64.newBarrier("DSB", "ISHLD");
    }

    private Event newDsbIshSt() {
        return AArch64.newBarrier("DSB", "ISHST");
    }
}