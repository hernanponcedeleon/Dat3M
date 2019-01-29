package com.dat3m.dartagnan.program.event.linux.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.Thread;

public class RMWXchg extends RMWAbstract implements RegWriter, RegReaderData {

    public RMWXchg(IExpr address, Register register, ExprInterface value, String atomic) {
        super(address, register, value, atomic);
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = resultRegister == value ? new Register(null) : resultRegister;
            RMWLoad load = new RMWLoad(dummy, address, getLoadMO());
            RMWStore store = new RMWStore(load, address, value, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, store);
            result = copyFromDummyToResult(result, dummy);
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + resultRegister + " := atomic_xchg" + atomicToText(atomic) + "(" + address + ", " + value + ")";
    }

    @Override
    public RMWXchg clone() {
        if(clone == null){
            Register newReg = resultRegister.clone();
            ExprInterface newValue = resultRegister == value ? newReg : value.clone();
            clone = new RMWXchg(address.clone(), newReg, newValue, atomic);
            afterClone();
        }
        return (RMWXchg)clone;
    }
}
