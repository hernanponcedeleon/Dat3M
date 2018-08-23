package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class RMWReadCondUnless extends RMWReadCond{

    public RMWReadCondUnless(Register reg, ExprInterface cmp, Location loc, String atomic) {
        super(reg, cmp, loc, atomic);
    }

    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
        Pair<BoolExpr, MapSSA> result = super.encodeDF(map, ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
        return result;
    }

    public RMWReadCondUnless clone() {
        Register newReg = reg.clone();
        Location newLoc = loc.clone();
        ExprInterface newCmp = cmp.clone();
        RMWReadCondUnless newLoad = new RMWReadCondUnless(newReg, newCmp, newLoc, atomic);
        newLoad.condLevel = condLevel;
        newLoad.setHLId(getHLId());
        newLoad.setUnfCopy(getUnfCopy());
        return newLoad;
    }
}
