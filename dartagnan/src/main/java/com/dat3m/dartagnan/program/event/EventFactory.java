package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.core.annotations.FunRet;
import com.dat3m.dartagnan.program.event.core.annotations.StringAnnotation;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.event.lang.svcomp.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class EventFactory {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    // Static class
    private EventFactory() {
    }

    // =============================================================================================
    // ========================================= Utility ===========================================
    // =============================================================================================

    public static List<Event> eventSequence(Event... events) {
        return eventSequence(Arrays.asList(events));
    }

    public static List<Event> eventSequence(Collection<? extends Event> events) {
        return events.stream().filter(Objects::nonNull).collect(Collectors.toList());
    }

    public static List<Event> eventSequence(Object... events) {
        List<Event> retVal = new ArrayList<>();
        for (Object obj : events) {
            if (obj == null) {
                continue;
            }
            if (obj instanceof AbstractEvent) {
                retVal.add((Event) obj);
            } else if (obj instanceof Collection<?>) {
                retVal.addAll((Collection<? extends Event>) obj);
            } else {
                throw new IllegalArgumentException("Cannot parse " + obj.getClass() + " as event.");
            }
        }
        return retVal;
    }


    // =============================================================================================
    // ======================================= DAT3m events ========================================
    // =============================================================================================

    // ------------------------------------------ Memory events ------------------------------------------

    public static Load newLoad(Register register, Expression address, String mo) {
        return new Load(register, address, mo);
    }

    public static Store newStore(Expression address, Expression value, String mo) {
        return new Store(address, value, mo);
    }

    public static Fence newFence(String name) {
        return new Fence(name);
    }

    public static Fence newFenceOpt(String name, String opt) {
        Fence fence = new Fence(name + "." + opt);
        fence.addTags(name);
        return fence;
    }

    public static Init newInit(MemoryObject base, int offset) {
        IValue offsetExpression = expressions.makeValue(BigInteger.valueOf(offset), base.getType());
        return new Init(base, offset, expressions.makeADD(base, offsetExpression));
    }

    // ------------------------------------------ Local events ------------------------------------------

    public static Skip newSkip() {
        return new Skip();
    }

    public static FunCall newFunctionCall(String funName) {
        return new FunCall(funName);
    }

    public static FunRet newFunctionReturn(String funName) {
        return new FunRet(funName);
    }

    public static StringAnnotation newStringAnnotation(String annotation) {
        return new StringAnnotation(annotation);
    }

    public static Local newLocal(Register register, Expression expr) {
        return new Local(register, expr);
    }

    public static Label newLabel(String name) {
        return new Label(name);
    }

    public static CondJump newJump(Expression cond, Label target) {
        return new CondJump(cond, target);
    }

    public static CondJump newJumpUnless(Expression cond, Label target) {
        if (cond instanceof BConst constant && constant.isFalse()) {
            return newGoto(target);
        }
        return new CondJump(expressions.makeNot(cond), target);
    }

    public static IfAsJump newIfJump(Expression expr, Label label, Label end) {
        return new IfAsJump(expr, label, end);
    }

    public static IfAsJump newIfJumpUnless(Expression expr, Label label, Label end) {
        return newIfJump(expressions.makeNot(expr), label, end);
    }

    public static CondJump newGoto(Label target) {
        return newJump(expressions.makeTrue(), target);
    }

    public static CondJump newFakeCtrlDep(Register reg, Label target) {
        CondJump jump = newJump(expressions.makeEQ(reg, reg), target);
        jump.addTags(Tag.NOOPT);
        return jump;
    }

    public static Assume newAssume(Expression expr) {
        return new Assume(expr);
    }

    // ------------------------------------------ RMW events ------------------------------------------

    public static Load newRMWLoad(Register reg, Expression address, String mo) {
        Load load = newLoad(reg, address, mo);
        load.addTags(Tag.RMW);
        return load;
    }

    public static RMWStore newRMWStore(Load loadEvent, Expression address, Expression value, String mo) {
        return new RMWStore(loadEvent, address, value, mo);
    }

    public static Load newRMWLoadExclusive(Register reg, Expression address, String mo) {
        Load load = new Load(reg, address, mo);
        load.addTags(Tag.RMW, Tag.EXCL);
        return load;
    }

    public static RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, String mo, boolean isStrong) {
        return new RMWStoreExclusive(address, value, mo, isStrong, false);
    }

    public static RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, String mo) {
        return newRMWStoreExclusive(address, value, mo, false);
    }

    public static ExecutionStatus newExecutionStatus(Register register, Event event) {
        return new ExecutionStatus(register, event, false);
    }

    public static ExecutionStatus newExecutionStatusWithDependencyTracking(Register register, Event event) {
        return new ExecutionStatus(register, event, true);
    }

    // =============================================================================================
    // ========================================== Common ===========================================
    // =============================================================================================

    /*
        "Common" contains events that are shared between different architectures, yet are no core events.
     */
    public static class Common {
        private Common() {
        }

        public static StoreExclusive newExclusiveStore(Register register, Expression address, Expression value, String mo) {
            return new StoreExclusive(register, address, value, mo);
        }
    }

    // =============================================================================================
    // ========================================== Pthread ==========================================
    // =============================================================================================

    public static class Pthread {
        private Pthread() {
        }

        public static Create newCreate(Expression address, String routine) {
            return new Create(address, routine);
        }

        public static End newEnd(Expression address) {
            return new End(address);
        }

        public static InitLock newInitLock(String name, Expression address, Expression value) {
            return new InitLock(name, address, value);
        }

        public static Join newJoin(Register reg, Expression expr) {
            return new Join(reg, expr);
        }

        public static Lock newLock(String name, Expression address, Register reg) {
            return new Lock(name, address, reg);
        }

        public static Start newStart(Register reg, Expression address, Event creationEvent) {
            return new Start(reg, address, creationEvent);
        }

        public static Unlock newUnlock(String name, Expression address, Register reg) {
            return new Unlock(name, address, reg);
        }
    }

    // =============================================================================================
    // ========================================== Atomics ==========================================
    // =============================================================================================

    public static class Atomic {
        private Atomic() {
        }

        public static AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr, Expression desiredValue, String mo, boolean isStrong) {
            return new AtomicCmpXchg(register, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public static AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr, Expression desiredValue, String mo) {
            return newCompareExchange(register, address, expectedAddr, desiredValue, mo, false);
        }

        public static AtomicFetchOp newFetchOp(Register register, Expression address, Expression value, IOpBin op, String mo) {
            return new AtomicFetchOp(register, address, value, op, mo);
        }

        public static AtomicFetchOp newFADD(Register register, Expression address, Expression value, String mo) {
            return newFetchOp(register, address, value, IOpBin.PLUS, mo);
        }

        public static AtomicFetchOp newIncrement(Register register, Expression address, String mo) {
            return newFetchOp(register, address, expressions.makeOne(register.getType()), IOpBin.PLUS, mo);
        }

        public static AtomicLoad newLoad(Register register, Expression address, String mo) {
            return new AtomicLoad(register, address, mo);
        }

        public static AtomicStore newStore(Expression address, Expression value, String mo) {
            return new AtomicStore(address, value, mo);
        }

        public static AtomicThreadFence newFence(String mo) {
            return new AtomicThreadFence(mo);
        }

        public static AtomicXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new AtomicXchg(register, address, value, mo);
        }
    }
    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    public static class Llvm {
        private Llvm() {
        }

        public static LlvmLoad newLoad(Register register, Expression address, String mo) {
            return new LlvmLoad(register, address, mo);
        }

        public static LlvmStore newStore(Expression address, Expression value, String mo) {
            return new LlvmStore(address, value, mo);
        }

        public static LlvmXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new LlvmXchg(register, address, value, mo);
        }

        public static LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address, Expression expectedAddr, Expression desiredValue, String mo, boolean isStrong) {
            return new LlvmCmpXchg(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public static LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address, Expression expectedAddr, Expression desiredValue, String mo) {
            return newCompareExchange(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, false);
        }

        public static LlvmRMW newRMW(Register register, Expression address, Expression value, IOpBin op, String mo) {
            return new LlvmRMW(register, address, value, op, mo);
        }

        public static LlvmFence newFence(String mo) {
            return new LlvmFence(mo);
        }

    }

    // =============================================================================================
    // ========================================= Standard ==========================================
    // =============================================================================================

    public static class Std {
        private Std() { }

        public static Malloc newMalloc(Register resultReg, Expression sizeExpr) {
            return new Malloc(resultReg, sizeExpr);
        }
    }

    // =============================================================================================
    // ========================================== Svcomp ===========================================
    // =============================================================================================

    public static class Svcomp {
        private Svcomp() {
        }

        public static BeginAtomic newBeginAtomic() {
            return new BeginAtomic();
        }

        public static EndAtomic newEndAtomic(BeginAtomic begin) {
            return new EndAtomic(begin);
        }

        public static LoopBegin newLoopBegin() {
            return new LoopBegin();
        }

        public static SpinStart newSpinStart() {
            return new SpinStart();
        }

        public static SpinEnd newSpinEnd() {
            return new SpinEnd();
        }

        public static LoopBound newLoopBound(int bound) {
            return new LoopBound(bound);
        }
    }

    // =============================================================================================
    // ============================================ ARM ============================================
    // =============================================================================================

    public static class AArch64 {
        private AArch64() {
        }

        public static class DMB {
            private DMB() {
            }

            public static Fence newBarrier() {
                return newSYBarrier(); // Default barrier
            }

            public static Fence newSYBarrier() {
                return new Fence("DMB.SY");
            }

            public static Fence newISHBarrier() {
                return new Fence("DMB.ISH");
            }
        }

        public static class DSB {
            private DSB() {
            }

            public static Fence newBarrier() {
                return newSYBarrier(); // Default barrier
            }

            public static Fence newSYBarrier() {
                return new Fence("DSB.SY");
            }

            public static Fence newISHBarrier() {
                return new Fence("DSB.ISH");
            }

            public static Fence newISHLDBarrier() {
                return new Fence("DSB.ISHLD");
            }

            public static Fence newISHSTBarrier() {
                return new Fence("DMB.ISHST");
            }

        }

    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================
    public static class Linux {
        private Linux() {
        }

        public static LKMMLoad newLKMMLoad(Register reg, Expression address, String mo) {
            return new LKMMLoad(reg, address, mo);
        }

        public static LKMMStore newLKMMStore(Expression address, Expression value, String mo) {
            return new LKMMStore(address, value, mo);
        }

        public static RMWAddUnless newRMWAddUnless(Expression address, Register register, Expression cmp, Expression value) {
            return new RMWAddUnless(address, register, cmp, value);
        }

        public static RMWCmpXchg newRMWCompareExchange(Expression address, Register register, Expression cmp, Expression value, String mo) {
            return new RMWCmpXchg(address, register, cmp, value, mo);
        }

        public static RMWFetchOp newRMWFetchOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new RMWFetchOp(address, register, value, op, mo);
        }

        public static RMWOp newRMWOp(Expression address, Register register, Expression value, IOpBin op) {
            return new RMWOp(address, register, value, op);
        }

        public static RMWOpAndTest newRMWOpAndTest(Expression address, Register register, Expression value, IOpBin op) {
            return new RMWOpAndTest(address, register, value, op);
        }

        public static RMWOpReturn newRMWOpReturn(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new RMWOpReturn(address, register, value, op, mo);
        }

        public static RMWXchg newRMWExchange(Expression address, Register register, Expression value, String mo) {
            return new RMWXchg(address, register, value, mo);
        }

        public static Fence newMemoryBarrier() {
            return new LKMMFence(Tag.Linux.MO_MB);
        }

        public static Fence newLKMMFence(String name) {
            return new LKMMFence(name);
        }

        public static LKMMLockRead newLockRead(Register register, Expression address) {
            return new LKMMLockRead(register, address);
        }

        public static LKMMLockWrite newLockWrite(Load lockRead, Expression address) {
            return new LKMMLockWrite(lockRead, address);
        }

        public static LKMMLock newLock(Expression address) {
            return new LKMMLock(address);
        }

        public static LKMMUnlock newUnlock(Expression address) {
            return new LKMMUnlock(address);
        }

        public static SrcuSync newSrcuSync(Expression address) {
            return new SrcuSync(address);
        }

    }


    // =============================================================================================
    // ============================================ X86 ============================================
    // =============================================================================================
    public static class X86 {
        private X86() {
        }

        public static Xchg newExchange(MemoryObject address, Register register) {
            return new Xchg(address, register);
        }

        public static Fence newMemoryFence() {
            return newFence(MFENCE);
        }
    }


    // =============================================================================================
    // =========================================== RISCV ===========================================
    // =============================================================================================
    public static class RISCV {
        private RISCV() {
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo, boolean isStrong) {
            RMWStoreExclusive store = new RMWStoreExclusive(address, value, mo, isStrong, true);
            store.addTags(Tag.RISCV.STCOND);
            return store;
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo) {
            return RISCV.newRMWStoreConditional(address, value, mo, false);
        }

        public static Fence newRRFence() {
            return new Fence("Fence.r.r");
        }

        public static Fence newRWFence() {
            return new Fence("Fence.r.w");
        }

        public static Fence newRRWFence() {
            return new Fence("Fence.r.rw");
        }

        public static Fence newWRFence() {
            return new Fence("Fence.w.r");
        }

        public static Fence newWWFence() {
            return new Fence("Fence.w.w");
        }

        public static Fence newWRWFence() {
            return new Fence("Fence.w.rw");
        }

        public static Fence newRWRFence() {
            return new Fence("Fence.rw.r");
        }

        public static Fence newRWWFence() {
            return new Fence("Fence.rw.w");
        }

        public static Fence newRWRWFence() {
            return new Fence("Fence.rw.rw");
        }

        public static Fence newTsoFence() {
            return new Fence("Fence.tso");
        }

    }

    // =============================================================================================
    // =========================================== LISA ============================================
    // =============================================================================================
    public static class LISA {
        private LISA() {
        }

        public static RMW newRMW(Expression address, Register register, Expression value, String mo) {
            return new RMW(address, register, value, mo);
        }
    }


    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================
    public static class Power {
        private Power() {
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo, boolean isStrong) {
            return new RMWStoreExclusive(address, value, mo, isStrong, true);
        }

        public static Fence newISyncBarrier() {
            return newFence(ISYNC);
        }

        public static Fence newSyncBarrier() {
            return newFence(SYNC);
        }

        public static Fence newLwSyncBarrier() {
            return newFence(LWSYNC);
        }
    }

}
