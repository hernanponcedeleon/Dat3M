package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;

public class RMWStoreCond extends RMWStore implements RegReaderData {

    public RMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String atomic) {
        super(loadEvent, address, value, atomic);
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), ((RMWReadCond)loadEvent).getCond()), executes(ctx));
    }

    @Override
    public RMWStoreCond clone() {
        if(clone == null){
            clone = new RMWStoreCond((RMWReadCond)loadEvent.clone(), address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (RMWStoreCond)clone;
    }
}
