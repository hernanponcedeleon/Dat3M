package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.Atom;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.cond.RMWReadCondUnless;
import dartagnan.program.event.rmw.cond.RMWStoreCond;

public class RMWAddUnless extends RMWAbstract {
    private ExprInterface cmp;

    public RMWAddUnless(Location location, Register register, ExprInterface cmp, ExprInterface value) {
        super(location, register, value, "_mb");
        this.cmp = cmp;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWReadCondUnless load = new RMWReadCondUnless(dummy, cmp, loc, "_rx");
            RMWStoreCond store = new RMWStoreCond(load, loc, new AExpr(dummy, "+", value), "_rx");
            Local local = new Local(reg, new Atom(dummy, "!=", cmp));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(store, local));
            return insertCondFencesOnMb(result, load);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_add_unless" + "(" + loc + ", " + value + "," + cmp + ")";
    }

    @Override
    public RMWAddUnless clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        ExprInterface newCmp = reg == cmp ? newReg : ((value == cmp) ? newValue : value.clone());
        RMWAddUnless newOp = new RMWAddUnless(newLoc, newReg, newCmp, newValue);
        newOp.setCondLevel(condLevel);
        newOp.memId = memId;
        newOp.setUnfCopy(getUnfCopy());
        return newOp;
    }
}
