package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.op.AOpBin;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

public class RMWOpReturn extends RMWAbstract implements RegWriter, RegReaderData {

    private AOpBin op;

    public RMWOpReturn(Location location, Register register, ExprInterface value, AOpBin op, String atomic) {
        super(location, register, value, atomic);
        this.op = op;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWLoad load = new RMWLoad(dummy, loc, getLoadMO());
            Local local = new Local(reg, new AExpr(dummy, op, value));
            RMWStore store = new RMWStore(load, loc, reg, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(local, store));
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_" + op.toLinuxName() + "_return" + atomicToText(atomic) + "(" + value + ", " + loc + ")";
    }

    @Override
    public RMWOpReturn clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        RMWOpReturn newOpReturn = new RMWOpReturn(newLoc, newReg, newValue, op, atomic);
        newOpReturn.setCondLevel(condLevel);
        newOpReturn.memId = memId;
        newOpReturn.setUnfCopy(getUnfCopy());
        return newOpReturn;
    }
}
