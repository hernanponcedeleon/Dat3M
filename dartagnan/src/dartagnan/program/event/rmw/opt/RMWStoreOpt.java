package dartagnan.program.event.rmw.opt;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.memory.Location;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class RMWStoreOpt extends RMWStore implements RegReaderData {

    public RMWStoreOpt(RMWLoad loadEvent, Location location, ExprInterface value, String atomic){
        super(loadEvent, location, value, atomic);
    }

    @Override
    public void beforeClone(){
        clone = null;
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkImplies(ctx.mkNot(ctx.mkBoolConst(cfVar())), ctx.mkNot(executes(ctx)));
    }

    @Override
    public RMWStoreOpt clone() {
        if(clone == null){
            RMWLoad newLoad = loadEvent != null ? loadEvent.clone() : null;
            clone = new RMWStoreOpt(newLoad, loc.clone(), value.clone(), atomic);
            afterClone();
        }
        return (RMWStoreOpt)clone;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        // TODO: Enforce same location for load and store events
        Pair<BoolExpr, MapSSA> result = super.encodeDF(map, ctx);
        if(loadEvent == null){
            BoolExpr enc = ctx.mkAnd(result.getFirst(), ctx.mkNot(executes(ctx)));
            result = new Pair<>(enc, result.getSecond());
        }
        return result;
    }
}
