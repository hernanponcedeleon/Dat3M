package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.utils.ClonableWithMemorisation;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class RMWReadCondUnless extends RMWReadCond implements ClonableWithMemorisation {

    private RMWReadCondUnless clone;

    public RMWReadCondUnless(Register reg, ExprInterface cmp, Location loc, String atomic) {
        super(reg, cmp, loc, atomic);
    }

    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
        Pair<BoolExpr, MapSSA> result = super.encodeDF(map, ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
        return result;
    }

    public RMWReadCondUnless clone() {
        if(clone == null){
            Register newReg = reg.clone();
            Location newLoc = loc.clone();
            ExprInterface newCmp = cmp.clone();
            clone = new RMWReadCondUnless(newReg, newCmp, newLoc, atomic);
            clone.setCondLevel(condLevel);
            clone.setHLId(getHLId());
            clone.setUnfCopy(getUnfCopy());
        }
        return clone;
    }
}
