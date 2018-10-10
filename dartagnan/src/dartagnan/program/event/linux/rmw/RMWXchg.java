package dartagnan.program.event.linux.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Collections;

public class RMWXchg extends RMWAbstract {

    public RMWXchg(Location location, Register register, ExprInterface value, String atomic) {
        super(location, register, value, atomic);
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = reg == value ? new Register(null) : reg;
            RMWLoad load = new RMWLoad(dummy, loc, getLoadMO());
            RMWStore store = new RMWStore(load, loc, value, getStoreMO());

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
                + reg + " := atomic_xchg" + atomicToText(atomic) + "(" + loc + ", " + value + ")";
    }

    public RMWXchg clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        ExprInterface newValue = reg == value ? newReg : value.clone();
        RMWXchg newXchg = new RMWXchg(newLoc, newReg, newValue, atomic);
        newXchg.setCondLevel(condLevel);
        newXchg.memId = memId;
        newXchg.setUnfCopy(getUnfCopy());
        return newXchg;
    }
}
