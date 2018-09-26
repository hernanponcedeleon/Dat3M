package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AConst;
import dartagnan.expression.AExpr;
import dartagnan.expression.Atom;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Collections;

public class RMWOpAndTest extends RMWAbstract {

    private String op;

    public RMWOpAndTest(Location location, Register register, ExprInterface value, String op) {
        super(location, register, value, "_mb");
        this.op = op;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWLoad load = new RMWLoad(dummy, loc, "_rx");
            Local local1 = new Local(dummy, new AExpr(dummy, op, value));
            RMWStore store = new RMWStore(load, loc, dummy, "_rx");
            Local local2 = new Local(reg, new Atom(dummy, "==", new AConst(0)));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(local1, new Seq(store, local2)));
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  "))
                + reg + " := atomic_" + opToText(op) + "_and_test(" + value + ", " + loc + ")";
    }

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
