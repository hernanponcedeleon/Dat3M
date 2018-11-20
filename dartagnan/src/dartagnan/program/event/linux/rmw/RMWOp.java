package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.op.AOpBin;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.linux.EType;

public class RMWOp extends RMWAbstract implements RegWriter, RegReaderData {

    private AOpBin op;

    public RMWOp(Location location, ExprInterface value, AOpBin op) {
        super(location, new Register(null), value, "Relaxed");
        this.op = op;
        addFilters(EType.NORETURN);
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            RMWLoad load = new RMWLoad(reg, loc, "Relaxed");
            RMWStore store = new RMWStore(load, loc, new AExpr(reg, op, value), "Relaxed");

            compileBasic(load);
            compileBasic(store);
            load.addFilters(EType.NORETURN);

            return new Seq(load, store);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "atomic_" + op.toLinuxName() + "(" + value + ", " + loc + ")";
    }

    @Override
    public RMWOp clone() {
        Location newLoc = loc.clone();
        ExprInterface newValue = value.clone();
        RMWOp newOp = new RMWOp(newLoc, newValue, op);
        newOp.setCondLevel(condLevel);
        newOp.memId = memId;
        newOp.setUnfCopy(getUnfCopy());
        return newOp;
    }
}
