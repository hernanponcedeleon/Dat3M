package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.utils.MapSSA;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(MapSSA map, Context ctx) {
		return ctx.mkGt(toZ3Int(map, ctx), ctx.mkInt(0));
	}

    @Override
    public abstract IExpr clone();
}
