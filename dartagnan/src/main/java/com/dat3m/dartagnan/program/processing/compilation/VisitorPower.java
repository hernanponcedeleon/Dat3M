package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
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
    // ========================================= Common ============================================
    // =============================================================================================

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        Store store = newRMWStoreExclusiveWithMo(e.getAddress(), e.getMemValue(), true, false, e.getMo());

        return eventSequence(
                store,
                newExecutionStatus(e.getResultRegister(), store)
        );
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        Register resultRegister = e.getResultRegister();

        Event optionalBarrierBefore = e.getMo().equals(C11.MO_SC) && leadingSync() ? newSync() : null;
        Load load = newLoad(resultRegister, e.getAddress());
        final boolean doCtrlDependency = switch (e.getMo()) {
            case C11.MO_SC -> leadingSync();
            case C11.MO_ACQUIRE -> true;
            case C11.MO_RELAXED -> useRC11Scheme;
            default -> false;
        };
        return eventSequence(
                optionalBarrierBefore,
                load,
                doCtrlDependency ? newFakeCtrlDep(resultRegister) : null,
                optionalBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        Store store = newStore(e.getAddress(), e.getMemValue());
        Event optionalBarrierAfter = e.getMo().equals(C11.MO_SC) && !leadingSync() ? newSync() : null;
        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                store,
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        // Power does not have mo tags, thus we use null
        Load load = newCoreLoadReserved(resultRegister, address);
        Store store = newCoreStoreConditional(address, e.getValue(), true);

        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                load,
                newFakeCtrlDep(resultRegister),
                store,
                optionalBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        // Power does not have mo tags, thus we use null
        Load load = newCoreLoadReserved(resultRegister, address);
        Store store = newCoreStoreConditional(address, dummyReg, true);
        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store,
                optionalBarrierAfter(e.getMo())
        );
    }

    @Override
    protected List<Event> newLlvmCmpXchg(Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        verify(success.getType() instanceof BooleanType, "Non-boolean success register.");

        Local casCmpResult = newLocal(success, expressions.makeEQ(oldValue, expected));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJumpUnless(success, casEnd);

        Load load = newCoreLoadReserved(oldValue, address);
        Store store = newCoreStoreConditional(address, newValue, strong);

        return eventSequence(
                optionalBarrierBefore(mo),
                load,
                casCmpResult,
                branchOnCasCmpResult,
                store,
                strong ? null : newAssignExecutionStatus(success, store),
                casEnd,
                optionalBarrierAfter(mo)
        );
    }

    @Override
    public List<Event> visitLlvmFence(LlvmFence e) {
        String mo = e.getMo();
        Event fence = mo.equals(Tag.C11.MO_SC) ? newSync() : newLwSync();

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
        Load loadValue = newCoreLoadReserved(regValue, address);
        Store storeValue = newCoreStoreConditional(address, value, e.isStrong());
        return eventSequence(
                optionalBarrierBefore(e.getMo()),
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
                optionalBarrierAfter(e.getMo()),
                castResult
        );
    }

    @Override
    public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummyReg = e.getFunction().newRegister(resultRegister.getType());
        Local localOp = newLocal(dummyReg, expressions.makeIntBinary(resultRegister, e.getOperator(), e.getOperand()));

        Load load = newCoreLoadReserved(resultRegister, address);
        Store store = newCoreStoreConditional(address, dummyReg, true);

        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                load,
                newFakeCtrlDep(resultRegister),
                localOp,
                store,
                optionalBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitAtomicLoad(AtomicLoad e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        Event optionalBarrierBefore = mo.equals(C11.MO_SC) && leadingSync() ? newSync() : null;
        Load load = newLoad(resultRegister, address);
        final boolean doCtrlDependency = switch (mo) {
            case C11.MO_SC -> leadingSync();
            case C11.MO_ACQUIRE -> true;
            case C11.MO_RELAXED -> useRC11Scheme;
            default -> false;
        };

        return eventSequence(
                optionalBarrierBefore,
                load,
                doCtrlDependency ? newFakeCtrlDep(resultRegister) : null,
                optionalBarrierAfter(mo)
        );
    }

    @Override
    public List<Event> visitAtomicStore(AtomicStore e) {
        Expression value = e.getMemValue();
        Expression address = e.getAddress();

        Store store = newStore(address, value);
        Event optionalBarrierAfter = e.getMo().equals(C11.MO_SC) && !leadingSync() ? newSync() : null;

        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                store,
                optionalBarrierAfter
        );
    }

    @Override
    public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        String mo = e.getMo();
        Event fence = mo.equals(Tag.C11.MO_SC) ? newSync() : newLwSync();

        return eventSequence(
                fence
        );
    }

    @Override
    public List<Event> visitAtomicXchg(AtomicXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Load load = newCoreLoadReserved(resultRegister, address);
        Store store = newCoreStoreConditional(address, e.getValue(), true);

        return eventSequence(
                optionalBarrierBefore(e.getMo()),
                load,
                newFakeCtrlDep(resultRegister),
                store,
                optionalBarrierAfter(e.getMo())
        );
    }

    private Event optionalBarrierBefore(String mo) {
        return switch (mo) {
            case C11.MO_SC -> leadingSync() ? newSync() : newLwSync();
            case C11.MO_RELEASE, C11.MO_ACQUIRE_RELEASE -> newLwSync();
            default -> null;
        };
    }

    private Event optionalBarrierAfter(String mo) {
        // Academics papers (e.g. https://plv.mpi-sws.org/imm/paper.pdf) say an isync barrier is enough
        // However, power compilers in godbolt.org use a lwsync.
        // We stick to the literature to potentially find bugs in what researchers claim.
        return switch (mo) {
            case C11.MO_SC -> leadingSync() ? newISync() : newSync();
            case C11.MO_ACQUIRE, C11.MO_ACQUIRE_RELEASE -> newISync();
            default -> null;
        };
    }

    // =============================================================================================
    // =========================================== LKMM ============================================
    // =============================================================================================

    // Following
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMLoad(LKMMLoad e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        String mo = e.getMo();

        // Power does not have mo tags, thus we use the empty string
        Load load = newLoad(resultRegister, address);
        Event optionalMemoryBarrier = mo.equals(Tag.Linux.MO_ACQUIRE) ? newLwSync() : null;

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
        Event optionalMemoryBarrierBefore = mo.equals(Tag.Linux.MO_RELEASE) ? newLwSync() : null;
        Event optionalMemoryBarrierAfter = mo.equals(Tag.Linux.MO_MB) ? newSync() : null;

        return eventSequence(
                optionalMemoryBarrierBefore,
                store,
                optionalMemoryBarrierAfter
        );
    }

    // Following
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    @Override
    public List<Event> visitLKMMFence(LKMMFence e) {
        Event optionalMemoryBarrier = switch (e.getMo()) {
            case Tag.Linux.MO_MB,
                 Tag.Linux.MO_RMB,
                 Tag.Linux.MO_WMB,
                 Tag.Linux.BEFORE_ATOMIC,
                 Tag.Linux.AFTER_ATOMIC     -> newSync();
            // #define smp_mb__after_spinlock()	smp_mb()
            //      https://elixir.bootlin.com/linux/v6.1/source/arch/powerpc/include/asm/spinlock.h#L14
            case Tag.Linux.AFTER_SPINLOCK   -> newSync();
            // #define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
            //      https://elixir.bootlin.com/linux/v6.1/source/include/linux/rcupdate.h#L1008
            // It seem to be only used for RCU related stuff in the kernel so it makes sense
            // it is defined in that header file
            case Tag.Linux.AFTER_UNLOCK_LOCK -> newSync();
            // https://elixir.bootlin.com/linux/v6.1/source/include/linux/compiler.h#L86
            case Tag.Linux.BARRIER -> null;
            default ->
                    throw new UnsupportedOperationException("Compilation of fence " + e.getMo() + " is not supported");
        };

        return eventSequence(
                optionalMemoryBarrier
        );
    }

    // =============================================================================================
    //                                    GENERAL COMMENTS
    // =============================================================================================
    // Methods with no suffix (e.g. atomic_xchg), which are those having MO_MB in our case,
    // are surrounded by a __atomic_pre_full_fence() or __atomic_post_full_fence()
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/fence
    // which in turn are smp_mb__before_atomic and smp_mb__after_atomic
    //      https://elixir.bootlin.com/linux/v5.18/source/include/linux/atomic.h
    // which in turn are __smp_mb()
    //      https://elixir.bootlin.com/linux/v5.18/source/include/asm-generic/barrier.h
    // which in turn is just a sync
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/barrier.h
    //
    // Methods with acquire or release as a suffix
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/acquire
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/release
    // which result in a isync (acquire) or lwsync (release)
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/atomic.h
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/synch.h
    //
    // Most compilations have this snippet
    // 1:   ldarx   %0,0,%2
    //      stdcx   %3,0,%2
    // bne  1b
    // Since we compile after unrolling, and our encoding enforces that the RMW pair is successful,
    // we just need the final iteration of the control dependency, thus we use a newFakeCtrlDep.
    // =============================================================================================

    @Override
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getResultRegister().getType());
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(expressions.makeNEQ(dummy, e.getExpectedValue()), casEnd);

        Load load = newCoreLoadReserved(dummy, address);
        Store store = newCoreStoreConditional(address, e.getStoreValue(), true);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                branchOnCasCmpResult,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo()),
                casEnd,
                newLocal(resultRegister, dummy)
        );
    }

    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newCoreLoadReserved(dummy, address);
        Store store = newCoreStoreConditional(address, e.getValue(), true);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression storeValue = expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand());
        // Power does not have mo tags, thus we use the empty string
        Load load = newCoreLoadReserved(dummy, address);
        Store store = newCoreStoreConditional(address, storeValue, true);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newCoreLoadReserved(dummy, address);
        Store store = newCoreStoreConditional(address, dummy, true);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand())),
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo())
        );
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();

        Register dummy = e.getFunction().newRegister(resultRegister.getType());
        Load load = newCoreLoadReserved(dummy, address);
        Store store = newCoreStoreConditional(address, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()), true);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                store,
                newLocal(resultRegister, dummy),
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo())
        );
    }

    // The implementation relies on arch_atomic_fetch_add_unless
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/add_unless
    // which uses a sub at the end to return the value before the operation
    //      https://elixir.bootlin.com/linux/v5.18/source/arch/powerpc/include/asm/atomic.h
    // Since RMWAddUnless does not care about any returned value, we don't need the final sub
    @Override
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Type type = resultRegister.getType();

        Register regValue = e.getFunction().newRegister(type);
        // Power does not have mo tags, thus we use the empty string
        Load load = newCoreLoadReserved(regValue, address);
        Store store = newCoreStoreConditional(address, expressions.makeAdd(regValue, e.getOperand()), true);

        Register dummy = e.getFunction().newRegister(types.getBooleanType());
        Expression unless = e.getCmp();
        Label cauEnd = newLabel("CAddU_end");
        CondJump branchOnCauCmpResult = newJumpUnless(dummy, cauEnd);

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                newLocal(dummy, expressions.makeNEQ(regValue, unless)),
                branchOnCauCmpResult,
                store,
                newFakeCtrlDep(regValue),
                optionalMemoryBarrierAfter(e.getMo()),
                cauEnd,
                newLocal(resultRegister, expressions.makeCast(dummy, resultRegister.getType()))
        );
    }

    // The implementation is arch_${atomic}_op_return(i, v) == 0;
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/sub_and_test
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/inc_and_test
    //      https://elixir.bootlin.com/linux/v5.18/source/scripts/atomic/fallbacks/dec_and_test
    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        Register resultRegister = e.getResultRegister();
        Expression address = e.getAddress();
        Register dummy = e.getFunction().newRegister(e.getAccessType());
        Expression testResult = expressions.makeNot(expressions.makeBooleanCast(dummy));

        Load load = newCoreLoadReserved(dummy, address);
        Local localOp = newLocal(dummy, expressions.makeIntBinary(dummy, e.getOperator(), e.getOperand()));
        Store store = newCoreStoreConditional(address, dummy, true);
        Local testOp = newLocal(resultRegister, expressions.makeCast(testResult, resultRegister.getType()));

        return eventSequence(
                optionalMemoryBarrierBefore(e.getMo()),
                load,
                localOp,
                store,
                newFakeCtrlDep(dummy),
                optionalMemoryBarrierAfter(e.getMo()),
                testOp
        );
    }

    @Override
    public List<Event> visitLKMMLock(LKMMLock e) {
        IntegerType type = (IntegerType)e.getAccessType();
        Expression zero = expressions.makeZero(type);
        Expression one = expressions.makeOne(type);
        Register dummy = e.getFunction().newRegister(type);
        // Spinlock events are guaranteed to succeed, i.e. we can use assumes
        return eventSequence(
                newCoreLoadReserved(dummy, e.getLock()),
                newAssume(expressions.makeEQ(dummy, zero)),
                newCoreStoreConditional(e.getLock(), one, true),
                // Fake dependency to guarantee acquire semantics
                newFakeCtrlDep(dummy),
                newISync()
        );
    }

    @Override
    public List<Event> visitLKMMUnlock(LKMMUnlock e) {
        return eventSequence(
                newLwSync(),
                newStore(e.getAddress(), expressions.makeZero((IntegerType)e.getAccessType()))
        );
    }

    private Event optionalMemoryBarrierBefore(String mo) {
        return switch (mo) {
            case Tag.Linux.MO_MB -> newSync();
            case Tag.Linux.MO_RELEASE -> newLwSync();
            default -> null;
        };
    }

    private Event optionalMemoryBarrierAfter(String mo) {
        return switch (mo) {
            case Tag.Linux.MO_MB -> newSync();
            case Tag.Linux.MO_ACQUIRE -> newISync();
            default -> null;
        };
    }

    private List<Event> newAssignExecutionStatus(Register register, Event store) {
        final Register status = register.getFunction().newUniqueRegister("status", types.getBooleanType());
        return List.of(
                newExecutionStatus(status, store),
                newLocal(register, expressions.makeNot(status))
        );
    }

    private Load newCoreLoadReserved(Register value, Expression address) {
        return newRMWLoadExclusive(value, address);
    }

    private Store newCoreStoreConditional(Expression address, Expression value, boolean strong) {
        return newRMWStoreExclusive(address, value, strong, true);
    }

    private Event newISync() {
        return Power.newBarrier("isync");
    }

    private Event newLwSync() {
        return Power.newBarrier("lwsync");
    }

    private Event newSync() {
        return Power.newBarrier("sync");
    }

    public enum PowerScheme {
        LEADING_SYNC, TRAILING_SYNC
    }

    private boolean leadingSync() {
        return cToPowerScheme.equals(PowerScheme.LEADING_SYNC);
    }
}