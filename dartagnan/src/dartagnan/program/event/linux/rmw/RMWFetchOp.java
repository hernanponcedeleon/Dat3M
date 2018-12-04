package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.op.AOpBin;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWFetchOp extends RMWAbstract implements RegWriter, RegReaderData {

    private AOpBin op;

    public RMWFetchOp(AExpr address, Register register, ExprInterface value, AOpBin op, String atomic) {
        super(address, register, value, atomic);
        this.op = op;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoad load = new RMWLoad(dummy, address, getLoadMO());
            RMWStore store = new RMWStore(load, address, new AExpr(dummy, op, value), getStoreMO());

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
        return nTimesCondLevel() + reg + " := atomic_fetch_" + op.toLinuxName() + atomicToText(atomic) + "(" + value + ", memory[" + address + "])";
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