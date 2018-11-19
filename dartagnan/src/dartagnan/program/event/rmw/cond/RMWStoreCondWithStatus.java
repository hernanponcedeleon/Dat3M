package dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;

public class RMWStoreCondWithStatus extends RMWStore implements RegReaderData {

    private RMWStoreCondWithStatus clone;

    public RMWStoreCondWithStatus(RMWLoad loadEvent, Location location, ExprInterface value, String atomic){
        super(loadEvent, location, value, atomic);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "status = (" + loc + " := " + value + ")";
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
            clone = new RMWStoreCondWithStatus(loadEvent.clone(), loc.clone(), value.clone(), atomic);
            clone.condLevel = condLevel;
            clone.setHLId(getHLId());
            clone.setUnfCopy(getUnfCopy());
        }
        return clone;
    }
}
