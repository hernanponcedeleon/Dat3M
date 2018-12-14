package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.event.Fence;

public class FenceCond extends Fence {

    private RMWReadCond loadEvent;

    public FenceCond (RMWReadCond loadEvent, String name){
        super(name);
        this.loadEvent = loadEvent;
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), loadEvent.getCond()), executes(ctx));
    }

    @Override
    public FenceCond clone() {
        if(clone == null){
            clone = new FenceCond(loadEvent.clone(), name);
            afterClone();
        }
        return (FenceCond)clone;
    }
}
