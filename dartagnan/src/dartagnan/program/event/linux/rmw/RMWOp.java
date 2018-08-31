package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Load;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Collections;

public class RMWOp extends RMWAbstract {

    private String op;

    public RMWOp(Location location, ExprInterface value, String op) {
        super(location, new Register(null), value, "_rx");
        this.op = op;
        addFilters(FilterUtils.EVENT_TYPE_RMW_NORETURN);
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Load load = new Load(reg, loc, "_rx");
            RMWStore store = new RMWStore(load, loc, new AExpr(reg, op, value), "_rx");

            compileBasic(load);
            compileBasic(store);
            load.addFilters(FilterUtils.EVENT_TYPE_RMW_NORETURN);
            store.addFilters(FilterUtils.EVENT_TYPE_RMW_NORETURN);

            return new Seq(load, store);
        }
        return super.compile(target, ctrl, leading);
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  "))
                + "atomic_" + opToText(op) + "(" + value + ", " + loc + ")";
    }

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
