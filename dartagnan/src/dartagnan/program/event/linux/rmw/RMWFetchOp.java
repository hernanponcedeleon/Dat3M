package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.expression.IExprBin;
import dartagnan.expression.op.IOpBin;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWFetchOp extends RMWAbstract implements RegWriter, RegReaderData {

    private IOpBin op;

    public RMWFetchOp(IExpr address, Register register, ExprInterface value, IOpBin op, String atomic) {
        super(address, register, value, atomic);
        this.op = op;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoad load = new RMWLoad(dummy, address, getLoadMO());
            RMWStore store = new RMWStore(load, address, new IExprBin(dummy, op, value), getStoreMO());

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
        return nTimesCondLevel() + reg + " := atomic_fetch_" + op.toLinuxName() + atomicToText(atomic) + "(" + value + ", " + address + ")";
    }

    @Override
    public RMWFetchOp clone() {
        if(clone == null){
            Register newReg = reg.clone();
            ExprInterface newValue = reg == value ? newReg : value.clone();
            clone = new RMWFetchOp(address.clone(), newReg, newValue, op, atomic);
            afterClone();
        }
        return (RMWFetchOp)clone;
    }
}