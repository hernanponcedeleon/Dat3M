package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.cond.RMWReadCondCmp;
import dartagnan.program.event.rmw.cond.RMWStoreCond;

public class RMWCmpXchg extends RMWAbstract {

    private ExprInterface cmp;

    public RMWCmpXchg(Location location, Register register, ExprInterface cmp, ExprInterface value, String atomic) {
        super(location, register, value, atomic);
        this.cmp = cmp;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = (reg == value || reg == cmp) ? new Register(null) : reg;
            RMWReadCondCmp load = new RMWReadCondCmp(dummy, cmp, loc, getLoadMO());
            RMWStoreCond store = new RMWStoreCond(load, loc, value, getStoreMO());

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, store);
            result = copyFromDummyToResult(result, dummy);
            return insertCondFencesOnMb(result, load);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_cmpxchg_" + atomicToText(atomic) + "(" + loc + ", " + cmp + "," + value + ")";
    }

    @Override
    public RMWCmpXchg clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        ExprInterface newCmp = reg == cmp ? newReg : ((value == cmp) ? newValue : value.clone());
        RMWCmpXchg newOp = new RMWCmpXchg(newLoc, newReg, newCmp, newValue, atomic);
        newOp.setCondLevel(condLevel);
        newOp.memId = memId;
        newOp.setUnfCopy(getUnfCopy());
        return newOp;
    }
}
