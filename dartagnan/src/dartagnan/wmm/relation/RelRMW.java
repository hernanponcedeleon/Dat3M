package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.rmw.RMWStore;

import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

public class RelRMW extends BasicRelation {

    public RelRMW(){
        super("rmw");
    }

    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> rmwWrites = program.getEvents().stream().filter(e -> e instanceof RMWStore).collect(Collectors.toSet());
        if(!rmwWrites.isEmpty()){
            for(Event w : rmwWrites){
                Load r = ((RMWStore)w).getLoadEvent();
                enc = ctx.mkAnd(enc, ctx.mkEq(r.executes(ctx), w.executes(ctx)));
                enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", w, r, ctx)));
                enc = ctx.mkAnd(enc, edge("rmw", r, w, ctx));
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        return encodeBasic(program, ctx);
    }
}
