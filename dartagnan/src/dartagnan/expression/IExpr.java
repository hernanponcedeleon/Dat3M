package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return ctx.mkGt(toZ3Int(e, ctx), ctx.mkInt(0));
	}

    @Override
    public abstract IExpr clone();

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return getIntValue(e, ctx, model) > 0;
    }
}
