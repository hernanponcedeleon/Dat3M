package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Collections;

public class RMWFetchOp extends RMWAbstract {

    private String op;

    public RMWFetchOp(Location location, Register register, ExprInterface value, String op, String atomic) {
        super(location, register, value, atomic);
        this.op = op;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoad load = new RMWLoad(dummy, loc, getLoadMO());
            RMWStore store = new RMWStore(load, loc, new AExpr(dummy, op, value), getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, store);
            result = copyFromDummyToResult(result, dummy);
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  "))
                + reg + " := atomic_fetch_" + opToText(op) + atomicToText(atomic) + "(" + value + ", " + loc + ")";
    }

    public RMWFetchOp clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        RMWFetchOp newOp = new RMWFetchOp(newLoc, newReg, newValue, op, atomic);
        newOp.setCondLevel(condLevel);
        newOp.memId = memId;
        newOp.setUnfCopy(getUnfCopy());
        return newOp;
    }
}