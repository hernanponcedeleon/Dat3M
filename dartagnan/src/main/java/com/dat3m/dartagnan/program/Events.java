package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.arch.aarch64.event.StoreExclusive;
import com.dat3m.dartagnan.program.arch.linux.event.*;
import com.dat3m.dartagnan.program.arch.linux.event.cond.*;
import com.dat3m.dartagnan.program.arch.tso.event.Xchg;
import com.dat3m.dartagnan.program.atomic.event.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.pthread.*;
import com.dat3m.dartagnan.program.event.rmw.*;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.svcomp.event.BeginAtomic;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;

import java.math.BigInteger;

public class Events {

    // Static class
    private Events() {}


    public static Local newLocal(Register register, ExprInterface expr, int cLine) {
        return new Local(register, expr, cLine);
    }

    public static Local newLocal(Register register, ExprInterface expr) {
        return newLocal(register, expr, -1);
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

    public static Fence newFence(String name) {
        return new Fence(name);
    }

    public static FenceOpt newFenceOpt(String name, String opt) {
        return new FenceOpt(name, opt);
    }

    public static Init newInit(IExpr address, IConst value) {
        return new Init(address, value);
    }

    public static Label newLabel(String name) {
        return new Label(name);
    }

    public static Load newLoad(Register register, IExpr address, String mo, int cLine) {
        return new Load(register, address, mo, cLine);
    }

    public static Load newLoad(Register register, IExpr address, String mo) {
        return newLoad(register, address, mo, -1);
    }

    public static Store newStore(IExpr address, ExprInterface value, String mo, int cLine) {
        return new Store(address, value, mo, cLine);
    }

    public static Store newStore(IExpr address, ExprInterface value, String mo) {
        return newStore(address, value, mo, -1);
    }

    public static Cmp newCompare(IExpr left, IExpr right) {
        return new Cmp(left, right);
    }

    public static Skip newSkip() {
        return new Skip();
    }

    public static FunCall newFunctionCall(String funName, int cLine) {
        return new FunCall(funName, cLine);
    }

    public static FunRet newFunctionReturn(String funName, int cLine) {
        return new FunRet(funName, cLine);
    }

    public static RMWLoad newRMWLoad(Register reg, IExpr address, String mo) {
        return new RMWLoad(reg, address, mo);
    }

    public static RMWStore newRMWStore(RMWLoad loadEvent, IExpr address, ExprInterface value, String mo) {
        return new RMWStore(loadEvent, address, value, mo);
    }

    public static RMWLoadExclusive newRMWLoadExclusive(Register reg, IExpr address, String mo) {
        return new RMWLoadExclusive(reg, address, mo);
    }

    public static RMWStoreExclusive newRMWStoreExclusive(IExpr address, ExprInterface value, String mo) {
        return new RMWStoreExclusive(address, value, mo);
    }

    public static RMWStoreExclusive newRMWStoreExclusive(IExpr address, ExprInterface value, String mo, boolean isStrong) {
        return new RMWStoreExclusive(address, value, mo, isStrong);
    }

    public static RMWStoreExclusiveStatus newRMWStoreExclusiveStatus(Register register, RMWStoreExclusive storeEvent) {
        return new RMWStoreExclusiveStatus(register, storeEvent);
    }


    public static class Pthread {
        private Pthread() {}

        public static Create newCreate(Register pthread_t, String routine, Address address, int cLine) {
            return new Create(pthread_t, routine, address, cLine);
        }

        public static End newEnd(Address address){
            return new End(address);
        }

        public static InitLock newInitLock(String name, IExpr address, IExpr value) {
            return new InitLock(name, address, value);
        }

        public static Join newJoin(Register pthread_t, Register reg, Address address, Label label) {
            return new Join(pthread_t, reg, address, label);
        }

        public static Lock newLock(String name, IExpr address, Register reg, Label label) {
            return new Lock(name, address, reg, label);
        }

        public static Start newStart(Register reg, Address address, Label label) {
            return new Start(reg, address, label);
        }

        public static Unlock newUnlock(String name, IExpr address, Register reg, Label label) {
            return new Unlock(name, address, reg, label);
        }
    }

    public static class Atomic {
        private Atomic() {}

        public static AtomicCmpXchg newCompareExchange(Register register, IExpr address, Register expected, ExprInterface value, String mo, boolean isStrong) {
            return new AtomicCmpXchg(register, address, expected, value, mo, isStrong);
        }

        public static AtomicCmpXchg newCompareExchange(Register register, IExpr address, Register expected, ExprInterface value, String mo) {
            return newCompareExchange(register, address, expected, value, mo, false);
        }

        public static AtomicFetchOp newFetchOp(Register register, IExpr address, ExprInterface value, IOpBin op, String mo) {
            return new AtomicFetchOp(register, address, value, op, mo);
        }

        public static AtomicFetchOp newFADD(Register register, IExpr address, ExprInterface value, String mo) {
            return newFetchOp(register, address, value, IOpBin.PLUS, mo);
        }

        public static AtomicFetchOp newIncrement(Register register, IExpr address, String mo) {
            return newFetchOp(register, address, new IConst(BigInteger.ONE, -1), IOpBin.PLUS, mo);
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

        public static AtomicXchg newExchange(Register register, IExpr address, ExprInterface value, String mo) {
            return new AtomicXchg(register, address, value, mo);
        }

        public static Dat3mCAS newDat3mCAS(Register register, IExpr address, IExpr expected, ExprInterface value, String mo) {
            return new Dat3mCAS(register, address, expected, value, mo);
        }
    }

    public static class Svcomp {
        private Svcomp() {}

        public static BeginAtomic newBeginAtomic() {
            return new BeginAtomic();
        }

        public static EndAtomic newEndAtomic(BeginAtomic begin) {
            return new EndAtomic(begin);
        }
    }


    private static class ArmCommon {
        private ArmCommon() {}

        public static StoreExclusive newExclusiveStore(Register register, IExpr address, ExprInterface value, String mo) {
            return new StoreExclusive(register, address, value, mo);
        }
    }

    public static class Arm extends ArmCommon {
        private Arm() {}

        public static Fence newISHBarrier() {
            return new Fence("Ish");
        }
    }

    public static class Arm8 extends ArmCommon {
        private Arm8() {}

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

    public static class Linux {
        private Linux() {}

        public static FenceCond newConditionalFence(RMWReadCond loadEvent, String name) {
            return new FenceCond(loadEvent, name);
        }

        public static RMWReadCondCmp newRMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
            return new RMWReadCondCmp(reg, cmp, address, atomic);
        }

        public static RMWReadCondUnless newRMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String mo) {
            return new RMWReadCondUnless(reg, cmp, address, mo);
        }

        public static RMWStoreCond newRMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String mo) {
            return new RMWStoreCond(loadEvent, address, value, mo);
        }

        public static RMWAddUnless newRMWAddUnless(IExpr address, Register register, ExprInterface cmp, ExprInterface value) {
            return new RMWAddUnless(address, register, cmp, value);
        }

        public static RMWCmpXchg newRMWCompareExchange(IExpr address, Register register, ExprInterface cmp, ExprInterface value, String mo) {
            return new RMWCmpXchg(address, register, cmp, value, mo);
        }

        public static RMWFetchOp newRMWFetchOp(IExpr address, Register register, ExprInterface value, IOpBin op, String mo) {
            return new RMWFetchOp(address, register, value, op, mo);
        }

        public static RMWOp newRMWOp(IExpr address, Register register, ExprInterface value, IOpBin op) {
            return new RMWOp(address, register, value, op);
        }

        public static RMWOpAndTest newRMWOpAndTest(IExpr address, Register register, ExprInterface value, IOpBin op) {
            return new RMWOpAndTest(address, register, value, op);
        }

        public static RMWOpReturn newRMWOpReturn(IExpr address, Register register, ExprInterface value, IOpBin op, String mo) {
            return new RMWOpReturn(address, register, value, op, mo);
        }

        public static RMWXchg newRMWExchange(IExpr address, Register register, ExprInterface value, String mo) {
            return new RMWXchg(address, register, value, mo);
        }

        public static Fence newMemoryBarrier() {
            return newFence("Mb");
        }

    }

    public static class X86 {
        private X86() {}

        public static Xchg newExchange(Address address, Register register) {
            return new Xchg(address, register);
        }

        public static Fence newMFence() {
            return newFence("Mfence");
        }
    }

    public static class Power {
        private Power() {}

        public static Fence newISyncBarrier() {
            return newFence("ISync");
        }

        public static Fence newSyncBarrier() {
            return newFence("Sync");
        }

        public static Fence newLwSyncBarrier() {
            return newFence("Lwsync");
        }
    }

}
