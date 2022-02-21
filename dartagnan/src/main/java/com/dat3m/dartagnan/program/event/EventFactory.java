package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.aarch64.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.linux.cond.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class EventFactory {

    // Static class
    private EventFactory() {}

    // =============================================================================================
    // ========================================= Utility ===========================================
    // =============================================================================================

    public static List<Event> eventSequence(Event... events) {
        return Arrays.stream(events).filter(Objects::nonNull).collect(Collectors.toList());
    }


    // =============================================================================================
    // ======================================= DAT3m events ========================================
    // =============================================================================================

    // ------------------------------------------ Memory events ------------------------------------------

    public static Load newLoad(Register register, IExpr address, String mo, int cLine) {
        Load load = new Load(register, address, mo);
        load.setCLine(cLine);
        return load;
    }

    public static Load newLoad(Register register, IExpr address, String mo) {
        return newLoad(register, address, mo, -1);
    }

    public static Store newStore(IExpr address, ExprInterface value, String mo, int cLine) {
        Store store = new Store(address, value, mo);
        store.setCLine(cLine);
        return store;
    }

    public static Store newStore(IExpr address, ExprInterface value, String mo) {
        return newStore(address, value, mo, -1);
    }

    public static Fence newFence(String name) {
        return new Fence(name);
    }

    public static Fence newFenceOpt(String name, String opt) {
        Fence fence = new Fence(name + "." + opt);
        fence.addFilters(name);
    	return fence;
    }

    public static Init newInit(MemoryObject base, int offset) {
        return new Init(base,offset);
    }

    // ------------------------------------------ Local events ------------------------------------------

    public static Cmp newCompare(IExpr left, IExpr right) {
        return new Cmp(left, right);
    }

    public static Skip newSkip() {
        return new Skip();
    }

    public static FunCall newFunctionCall(String funName, int cLine) {
        FunCall funCall = new FunCall(funName);
        funCall.setCLine(cLine);
        return funCall;
    }

    public static FunRet newFunctionReturn(String funName, int cLine) {
        FunRet funRet = new FunRet(funName);
        funRet.setCLine(cLine);
        return funRet;
    }

    public static Local newLocal(Register register, ExprInterface expr, int cLine) {
        Local local = new Local(register, expr);
        local.setCLine(cLine);
        return local;
    }

    public static Local newLocal(Register register, ExprInterface expr) {
        return newLocal(register, expr, -1);
    }

    public static Label newLabel(String name) {
        return new Label(name);
    }

    public static CondJump newJump(BExpr cond, Label target) {
        return new CondJump(cond, target);
    }

    public static CondJump newJumpUnless(ExprInterface cond, Label target) {
        return newJump(new BExprUn(BOpUn.NOT, cond), target);
    }

    public static IfAsJump newIfJump(BExpr expr, Label label, Label end) {
        return new IfAsJump(expr, label, end);
    }

    public static IfAsJump newIfJumpUnless(ExprInterface expr, Label label, Label end) {
        return newIfJump(new BExprUn(BOpUn.NOT, expr), label, end);
    }

    public static CondJump newGoto(Label target) {
        return newJump(BConst.TRUE, target);
    }

    public static CondJump newFakeCtrlDep(Register reg, Label target) {
        return newJump(new Atom(reg, COpBin.EQ, reg), target);
    }

    public static Assume newAssume(ExprInterface expr) {
        return new Assume(expr);
    }

    // ------------------------------------------ RMW events ------------------------------------------

    public static Load newRMWLoad(Register reg, IExpr address, String mo) {
        Load load = newLoad(reg, address, mo);
        load.addFilters(Tag.RMW);
        return load;
    }

    public static RMWStore newRMWStore(Load loadEvent, IExpr address, ExprInterface value, String mo) {
        return new RMWStore(loadEvent, address, value, mo);
    }

    public static Load newRMWLoadExclusive(Register reg, IExpr address, String mo) {
        Load load = new Load(reg, address, mo);
        load.addFilters(Tag.RMW, Tag.EXCL);
        return load;
    }

    public static RMWStoreExclusive newRMWStoreExclusive(IExpr address, ExprInterface value, String mo, boolean isStrong) {
        return new RMWStoreExclusive(address, value, mo, isStrong);
    }

    public static RMWStoreExclusive newRMWStoreExclusive(IExpr address, ExprInterface value, String mo) {
        return newRMWStoreExclusive(address, value, mo, false);
    }

    public static ExecutionStatus newExecutionStatus(Register register, Event event) {
        return new ExecutionStatus(register, event);
    }


    // =============================================================================================
    // ========================================== Pthread ==========================================
    // =============================================================================================

    public static class Pthread {
        private Pthread() {}

        public static Create newCreate(Register pthread_t, String routine, MemoryObject address, int cLine) {
            Create create = new Create(pthread_t, routine, address);
            create.setCLine(cLine);
            return create;
        }

        public static End newEnd(MemoryObject address){
            return new End(address);
        }

        public static InitLock newInitLock(String name, IExpr address, IExpr value) {
            return new InitLock(name, address, value);
        }

        public static Join newJoin(Register pthread_t, Register reg, MemoryObject address, Label label) {
            return new Join(pthread_t, reg, address, label);
        }

        public static Lock newLock(String name, IExpr address, Register reg, Label label) {
            return new Lock(name, address, reg, label);
        }

        public static Start newStart(Register reg, MemoryObject address, Label label) {
            return new Start(reg, address, label);
        }

        public static Unlock newUnlock(String name, IExpr address, Register reg, Label label) {
            return new Unlock(name, address, reg, label);
        }
    }

    // =============================================================================================
    // ========================================== Atomics ==========================================
    // =============================================================================================

    public static class Atomic {
        private Atomic() {}

        public static AtomicCmpXchg newCompareExchange(Register register, IExpr address, IExpr expectedAddr, IExpr desiredValue, String mo, boolean isStrong) {
            return new AtomicCmpXchg(register, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public static AtomicCmpXchg newCompareExchange(Register register, IExpr address, IExpr expectedAddr, IExpr desiredValue, String mo) {
            return newCompareExchange(register, address, expectedAddr, desiredValue, mo, false);
        }

        public static AtomicFetchOp newFetchOp(Register register, IExpr address, IExpr value, IOpBin op, String mo) {
            return new AtomicFetchOp(register, address, value, op, mo);
        }

        public static AtomicFetchOp newFADD(Register register, IExpr address, IExpr value, String mo) {
            return newFetchOp(register, address, value, IOpBin.PLUS, mo);
        }

        public static AtomicFetchOp newIncrement(Register register, IExpr address, String mo) {
            return newFetchOp(register, address, IValue.ONE, IOpBin.PLUS, mo);
        }

        public static AtomicLoad newLoad(Register register, IExpr address, String mo) {
            return new AtomicLoad(register, address, mo);
        }

        public static AtomicStore newStore(IExpr address, ExprInterface value, String mo) {
            return new AtomicStore(address, value, mo);
        }

        public static AtomicThreadFence newFence(String mo) {
            return new AtomicThreadFence(mo);
        }

        public static AtomicXchg newExchange(Register register, IExpr address, IExpr value, String mo) {
            return new AtomicXchg(register, address, value, mo);
        }

        public static Dat3mCAS newDat3mCAS(Register register, IExpr address, IExpr expected, IExpr value, String mo) {
            return new Dat3mCAS(register, address, expected, value, mo);
        }
    }

    // =============================================================================================
    // ========================================== Svcomp ===========================================
    // =============================================================================================

    public static class Svcomp {
        private Svcomp() {}

        public static BeginAtomic newBeginAtomic() {
            return new BeginAtomic();
        }

        public static EndAtomic newEndAtomic(BeginAtomic begin) {
            return new EndAtomic(begin);
        }
    }


    // =============================================================================================
    // ============================================ ARM ============================================
    // =============================================================================================

    public static class AArch64 {
        private AArch64() {}

        public static StoreExclusive newExclusiveStore(Register register, IExpr address, ExprInterface value, String mo) {
            return new StoreExclusive(register, address, value, mo);
        }

        public static class DMB {
            private DMB() {}

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
            private DSB() {}

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
                return new Fence ("DSB.ISHLD");
            }
        }

    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================
    public static class Linux {
        private Linux() {}

        public static RMWReadCondCmp newRMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
            return new RMWReadCondCmp(reg, cmp, address, atomic);
        }

        public static RMWReadCondUnless newRMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String mo) {
            return new RMWReadCondUnless(reg, cmp, address, mo);
        }

        public static RMWStoreCond newRMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String mo) {
            return new RMWStoreCond(loadEvent, address, value, mo);
        }

        public static RMWAddUnless newRMWAddUnless(IExpr address, Register register, ExprInterface cmp, IExpr value) {
            return new RMWAddUnless(address, register, cmp, value);
        }

        public static RMWCmpXchg newRMWCompareExchange(IExpr address, Register register, ExprInterface cmp, IExpr value, String mo) {
            return new RMWCmpXchg(address, register, cmp, value, mo);
        }

        public static RMWFetchOp newRMWFetchOp(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
            return new RMWFetchOp(address, register, value, op, mo);
        }

        public static RMWOp newRMWOp(IExpr address, Register register, IExpr value, IOpBin op) {
            return new RMWOp(address, register, value, op);
        }

        public static RMWOpAndTest newRMWOpAndTest(IExpr address, Register register, IExpr value, IOpBin op) {
            return new RMWOpAndTest(address, register, value, op);
        }

        public static RMWOpReturn newRMWOpReturn(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
            return new RMWOpReturn(address, register, value, op, mo);
        }

        public static RMWXchg newRMWExchange(IExpr address, Register register, IExpr value, String mo) {
            return new RMWXchg(address, register, value, mo);
        }

        public static FenceCond newConditionalBarrier(RMWReadCond loadEvent, String name) {
            return new FenceCond(loadEvent, name);
        }

        public static Fence newMemoryBarrier() {
            return newFence("Mb");
        }

        public static Fence newConditionalMemoryBarrier(RMWReadCond loadEvent) {
            return newConditionalBarrier(loadEvent, "Mb");
        }

    }


    // =============================================================================================
    // ============================================ X86 ============================================
    // =============================================================================================
    public static class X86 {
        private X86() {}

        public static Xchg newExchange(MemoryObject address, Register register) {
            return new Xchg(address, register);
        }

        public static Fence newMemoryFence() {
            return newFence(MFENCE);
        }
    }


    // =============================================================================================
    // =========================================== LISA ============================================
    // =============================================================================================
    public static class LISA {
        private LISA() {}

        public static RMW newRMW(IExpr address, Register register, IExpr value, String mo) {
            return new RMW(address, register, value, mo);
        }
    }


    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================
    public static class Power {
        private Power() {}

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
