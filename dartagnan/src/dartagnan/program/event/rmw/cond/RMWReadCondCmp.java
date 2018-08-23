package dartagnan.program.event.rmw.cond;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;

public class RMWReadCondCmp extends RMWReadCond {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, Location loc, String atomic) {
        super(reg, cmp, loc, atomic);
    }

    public RMWReadCondCmp clone() {
        Register newReg = reg.clone();
        Location newLoc = loc.clone();
        ExprInterface newCmp = cmp.clone();
        RMWReadCondCmp newLoad = new RMWReadCondCmp(newReg, newCmp, newLoc, atomic);
        newLoad.condLevel = condLevel;
        newLoad.setHLId(getHLId());
        newLoad.setUnfCopy(getUnfCopy());
        return newLoad;
    }
}
