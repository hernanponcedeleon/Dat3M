package com.dat3m.dartagnan.program.arch.linux.event.rmw;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.Thread;

public class RMWCmpXchg extends RMWAbstract implements RegWriter, RegReaderData {

    private ExprInterface cmp;

    public RMWCmpXchg(IExpr address, Register register, ExprInterface cmp, ExprInterface value, String atomic) {
        super(address, register, value, atomic);
        this.dataRegs = new ImmutableSet.Builder<Register>().addAll(value.getRegs()).addAll(cmp.getRegs()).build();
        this.cmp = cmp;
    }

    @Override
    public Thread compile(Arch target) {
        if(target == Arch.NONE) {
            Register dummy = (resultRegister == value || resultRegister == cmp) ? new Register(null, resultRegister.getThreadId()) : resultRegister;
            RMWReadCondCmp load = new RMWReadCondCmp(dummy, cmp, address, getLoadMO());
            RMWStoreCond store = new RMWStoreCond(load, address, value, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, store);
            result = copyFromDummyToResult(result, dummy);
            return insertCondFencesOnMb(result, load);
        }
        return super.compile(target);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + resultRegister + " := atomic_cmpxchg_" + atomicToText(atomic) + "(" + address + ", " + cmp + ", " + value + ")";
    }

    @Override
    public RMWCmpXchg clone() {
        if(clone == null){
            clone = new RMWCmpXchg(address, resultRegister, cmp, value, atomic);
            afterClone();
        }
        return (RMWCmpXchg)clone;
    }
}
