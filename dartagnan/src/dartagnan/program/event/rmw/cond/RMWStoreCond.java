package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.event.rmw.RMWStore;

public class RMWStoreCond extends RMWStore {

    public RMWStoreCond(RMWReadCond loadEvent, Location loc, ExprInterface val, String atomic) {
        super(loadEvent, loc, val, atomic);
    }

    public BoolExpr encodeCF(Context ctx) throws Z3Exception {
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), ((RMWReadCond)loadEvent).getCond()), executes(ctx));
    }
}
