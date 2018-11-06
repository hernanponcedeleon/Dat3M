package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;

public class RMWStoreCondWithStatus extends RMWStore {

    private RMWStoreCondWithStatus clone;

    public RMWStoreCondWithStatus(RMWLoad loadEvent, Location location, ExprInterface val, String atomic){
        super(loadEvent, location, val, atomic);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "status = (" + loc + " := " + val + ")";
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkImplies(ctx.mkNot(ctx.mkBoolConst(cfVar())), ctx.mkNot(executes(ctx)));
    }

    @Override
    public void beforeClone(){
        clone = null;
    }

    @Override
    public RMWStoreCondWithStatus clone() {
        if(clone == null){
            clone = new RMWStoreCondWithStatus(loadEvent.clone(), loc.clone(), val.clone(), atomic);
            clone.condLevel = condLevel;
            clone.setHLId(getHLId());
            clone.setUnfCopy(getUnfCopy());
        }
        return clone;
    }
}
