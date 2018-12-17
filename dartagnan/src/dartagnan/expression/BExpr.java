package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.utils.MapSSA;

public abstract class BExpr implements ExprInterface {

    @Override
    public IntExpr toZ3Int(MapSSA map, Context ctx) {
        return (IntExpr) ctx.mkITE(toZ3Bool(map, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

	@Override
    public abstract BoolExpr toZ3Bool(MapSSA map, Context ctx);

    @Override
    public abstract BExpr clone();
}
