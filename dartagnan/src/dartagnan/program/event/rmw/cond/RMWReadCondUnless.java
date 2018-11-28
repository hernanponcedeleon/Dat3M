package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class RMWReadCondUnless extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, AExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        Pair<BoolExpr, MapSSA> result = super.encodeDF(map, ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
        return result;
    }

    @Override
    public RMWReadCondUnless clone() {
        if(clone == null){
            clone = new RMWReadCondUnless(reg.clone(), cmp.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWReadCondUnless)clone;
    }
}
