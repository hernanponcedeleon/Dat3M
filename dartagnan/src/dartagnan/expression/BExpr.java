package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.utils.MapSSA;

public abstract class BExpr implements ExprInterface {

	@Override
	public abstract BoolExpr toZ3(MapSSA map, Context ctx);

	@Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
	    return toZ3(map, ctx);
    }

    public abstract BExpr clone();

    @Override
    public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
        return ctx.mkOr(
                ctx.mkAnd((BoolExpr) value, ctx.mkEq(target, ctx.mkInt(1))),
                ctx.mkAnd(ctx.mkNot((BoolExpr) value), ctx.mkEq(target, ctx.mkInt(0)))
        );
    }
}
