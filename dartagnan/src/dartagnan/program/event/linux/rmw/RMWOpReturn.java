package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Collections;

public class RMWOpReturn extends RMWAbstract {

    private String op;

    public RMWOpReturn(Location location, Register register, ExprInterface value, String op, String atomic) {
        super(location, register, value, atomic);
        this.op = op;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            Load load = new Load(dummy, loc, getLoadMO());
            Local local = new Local(reg, new AExpr(dummy, op, value));
            RMWStore store = new RMWStore(load, loc, reg, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(local, store));
            return insertFencesOnMb(result);
        }
        return super.compile(target, ctrl, leading);
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  "))
                + reg + " := atomic_" + opToText(op) + "_return" + atomicToText(atomic) + "(" + value + ", " + loc + ")";
    }

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
