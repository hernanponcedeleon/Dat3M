package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AConst;
import dartagnan.expression.AExpr;
import dartagnan.expression.Atom;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.op.AOpBin;
import dartagnan.expression.op.COpBin;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;


public class RMWOpAndTest extends RMWAbstract implements RegWriter, RegReaderData {

    private AOpBin op;

    public RMWOpAndTest(Location location, Register register, ExprInterface value, AOpBin op) {
        super(location, register, value, "Mb");
        this.op = op;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWLoad load = new RMWLoad(dummy, loc, "Relaxed");
            Local local1 = new Local(dummy, new AExpr(dummy, op, value));
            RMWStore store = new RMWStore(load, loc, dummy, "Relaxed");
            Local local2 = new Local(reg, new Atom(dummy, COpBin.EQ, new AConst(0)));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(local1, new Seq(store, local2)));
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_" + op.toLinuxName() + "_and_test(" + value + ", " + loc + ")";
    }

    @Override
    public RMWOpAndTest clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        RMWOpAndTest newOpReturn = new RMWOpAndTest(newLoc, newReg, newValue, op);
        newOpReturn.setCondLevel(condLevel);
        newOpReturn.memId = memId;
        newOpReturn.setUnfCopy(getUnfCopy());
        return newOpReturn;
    }
}
