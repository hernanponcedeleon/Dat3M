package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Fence;

public class FenceCond extends Fence {

    private RMWReadCond loadEvent;

    public FenceCond (RMWReadCond loadEvent, String name){
        super(name);
        this.loadEvent = loadEvent;
    }

    public FenceCond (RMWReadCond loadEvent, String name, int condLevel){
        super(name, condLevel);
        this.loadEvent = loadEvent;
    }

    public FenceCond(RMWReadCond loadEvent, String name, int condLevel, String atomic){
        super(name, condLevel, atomic);
        this.loadEvent = loadEvent;
    }

    public BoolExpr encodeCF(Context ctx) throws Z3Exception {
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), loadEvent.getCond()), executes(ctx));
    }

    public FenceCond clone() {
        return new FenceCond(loadEvent.clone(), name, condLevel, atomic);
    }
}
