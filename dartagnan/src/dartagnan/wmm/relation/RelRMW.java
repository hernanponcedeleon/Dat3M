package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.utils.Utils;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

public class RelRMW extends Relation {

    public RelRMW(){
        term = "rmw";
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> rmwWrites = events.stream().filter(e -> e instanceof RMWStore).collect(Collectors.toSet());
        if(!rmwWrites.isEmpty()){
            for(Event w : rmwWrites){
                Load r = ((RMWStore)w).getLoadEvent();
                enc = ctx.mkAnd(enc, ctx.mkEq(r.executes(ctx), w.executes(ctx)));
                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("rf", w, r, ctx)));
                enc = ctx.mkAnd(enc, Utils.edge("rmw", r, w, ctx));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }
}
