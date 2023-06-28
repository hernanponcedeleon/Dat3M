package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.LISARMW;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXFenceWithId;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.core.annotations.FunRet;
import com.dat3m.dartagnan.program.event.core.annotations.StringAnnotation;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectVoidFunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
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
            if (obj instanceof Event) {
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

    public static Load newLoad(Register register, Expression address) {
        return new Load(register, address);
    }

    public static Load newLoadWithMo(Register register, Expression address, String mo) {
        Load load = newLoad(register, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public static Store newStore(Expression address, Expression value) {
        return new Store(address, value);
    }

    public static Store newStoreWithMo(Expression address, Expression value, String mo) {
        Store store = newStore(address, value);
        store.setMemoryOrder(mo);
        return store;
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
        //TODO: We simplify here because virtual aliasing currently fails when pointer arithmetic is involved
        // meaning that <addr> and <addr + 0> are treated differently.
        final Expression address = offset == 0 ? base :
                expressions.makeADD(base, expressions.makeValue(BigInteger.valueOf(offset), base.getType()));
        return new Init(base, offset, address);
    }

    public static DirectValueFunctionCall newValueFunctionCall(Register resultRegister, Function function, List<Expression> arguments) {
        return new DirectValueFunctionCall(resultRegister, function, arguments);
    }

    public static DirectVoidFunctionCall newVoidFunctionCall(Function function, List<Expression> arguments) {
        return new DirectVoidFunctionCall(function, arguments);
    }

    public static Return newFunctionReturn(Expression returnExpression) {
        return new Return(returnExpression);
    }

    public static AbortIf newAbortIf(Expression condition) {
        return new AbortIf(condition);
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
        if (cond instanceof BConst constant && !constant.getValue()) {
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

    public static Load newRMWLoad(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW);
        return load;
    }

    public static Load newRMWLoadWithMo(Register reg, Expression address, String mo) {
        Load load = newLoadWithMo(reg, address, mo);
        load.addTags(Tag.RMW);
        return load;
    }

    public static RMWStore newRMWStore(Load loadEvent, Expression address, Expression value) {
        return new RMWStore(loadEvent, address, value);
    }

    public static RMWStore newRMWStoreWithMo(Load loadEvent, Expression address, Expression value, String mo) {
        RMWStore store = newRMWStore(loadEvent, address, value);
        store.setMemoryOrder(mo);
        return store;
    }

    public static Load newRMWLoadExclusive(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW, Tag.EXCL);
        return load;
    }

    public static Load newRMWLoadExclusiveWithMo(Register reg, Expression address, String mo) {
        Load load = newRMWLoadExclusive(reg, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public static RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, boolean isStrong) {
        return new RMWStoreExclusive(address, value, isStrong, false);
    }

    public static RMWStoreExclusive newRMWStoreExclusiveWithMo(Expression address, Expression value, boolean isStrong, String mo) {
        RMWStoreExclusive store = newRMWStoreExclusive(address, value, isStrong);
        store.setMemoryOrder(mo);
        return store;
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
            return new AtomicFetchOp(register, address, op, value, mo);
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
            return new LlvmRMW(register, address, op, value, mo);
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

        public static LKMMAddUnless newRMWAddUnless(Expression address, Register register, Expression cmp, Expression value) {
            return new LKMMAddUnless(register, address, value, cmp);
        }

        public static LKMMCmpXchg newRMWCompareExchange(Expression address, Register register, Expression cmp, Expression value, String mo) {
            return new LKMMCmpXchg(register, address, cmp, value, mo);
        }

        public static LKMMFetchOp newRMWFetchOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new LKMMFetchOp(register, address, op, value, mo);
        }

        public static LKMMOpNoReturn newRMWOp(Expression address, Expression value, IOpBin op) {
            return new LKMMOpNoReturn(address, op, value);
        }

        public static LKMMOpAndTest newRMWOpAndTest(Expression address, Register register, Expression value, IOpBin op) {
            return new LKMMOpAndTest(register, address, op, value);
        }

        public static LKMMOpReturn newRMWOpReturn(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new LKMMOpReturn(register, address, op, value, mo);
        }

        public static LKMMXchg newRMWExchange(Expression address, Register register, Expression value, String mo) {
            return new LKMMXchg(register, address, value, mo);
        }

        public static LKMMFence newMemoryBarrier() {
            return new LKMMFence(Tag.Linux.MO_MB);
        }

        public static LKMMFence newLKMMFence(String name) {
            return new LKMMFence(name);
        }

        public static LKMMLock newLock(Expression address) {
            return new LKMMLock(address);
        }

        public static LKMMUnlock newUnlock(Expression address) {
            return new LKMMUnlock(address);
        }

        public static GenericMemoryEvent newSrcuSync(Expression address) {
            GenericMemoryEvent srcuSync = new GenericMemoryEvent(address, "synchronize_srcu");
            srcuSync.addTags(Tag.Linux.SRCU_SYNC);
            return srcuSync;
        }

    }


    // =============================================================================================
    // ============================================ X86 ============================================
    // =============================================================================================
    public static class X86 {
        private X86() {
        }

        public static TSOXchg newExchange(MemoryObject address, Register register) {
            return new TSOXchg(address, register);
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
            RMWStoreExclusive store = new RMWStoreExclusive(address, value, isStrong, true);
            store.addTags(Tag.RISCV.STCOND);
            store.setMemoryOrder(mo);
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

        public static LISARMW newRMW(Expression address, Register register, Expression value, String mo) {
            return new LISARMW(register, address, value, mo);
        }
    }


    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================
    public static class Power {
        private Power() {
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, boolean isStrong) {
            return new RMWStoreExclusive(address, value, isStrong, true);
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

    // =============================================================================================
    // ============================================ PTX ============================================
    // =============================================================================================
    public static class PTX {
        private PTX() {}

        public static PTXAtomOp newAtomOp(Expression address, Register register, Expression value,
                                          IOpBin op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for atom.
            PTXAtomOp atom = new PTXAtomOp(register, address, op, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static PTXRedOp newRedOp(Expression address, Expression value,
                                        IOpBin op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for red.
            PTXRedOp red = new PTXRedOp(address, value, op, mo);
            red.addTags(scope);
            return red;
        }

        public static PTXFenceWithId newFenceWithId(String name, Expression fenceId) {
            return new PTXFenceWithId(name, fenceId);
        }
    }

}