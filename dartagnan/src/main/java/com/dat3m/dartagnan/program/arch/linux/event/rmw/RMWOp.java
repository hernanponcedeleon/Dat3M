package com.dat3m.dartagnan.program.arch.linux.event.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.Thread;

public class RMWOp extends RMWAbstract implements RegWriter, RegReaderData {

    private IOpBin op;

    public RMWOp(IExpr address, ExprInterface value, IOpBin op) {
        super(address, new Register(null), value, "Relaxed");
        this.op = op;
        addFilters(EType.NORETURN);
    }

    @Override
    public Thread compile(String target) {
        if(target.equals("sc")) {
            RMWLoad load = new RMWLoad(resultRegister, address, "Relaxed");
            RMWStore store = new RMWStore(load, address, new IExprBin(resultRegister, op, value), "Relaxed");

            compileBasic(load);
            compileBasic(store);
            load.addFilters(EType.NORETURN);

            return new Seq(load, store);
        }
        return super.compile(target);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "atomic_" + op.toLinuxName() + "(" + value + ", " + address + ")";
    }

    @Override
    public RMWOp clone() {
        if(clone == null){
            clone = new RMWOp(address.clone(), value.clone(), op);
            afterClone();
        }
        return (RMWOp)clone;
    }
}
