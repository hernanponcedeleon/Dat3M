package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;

import java.util.Collection;

public class RelRMW extends Relation {

    protected int eventMask = EventRepository.EVENT_RMW_STORE;

    public RelRMW(){
        term = "rmw";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(eventMask);
        BoolExpr enc = ctx.mkTrue();
        if(!events.isEmpty()){
            for(Event w : events){
                Load r = ((RMWStore)w).getLoadEvent();
                enc = ctx.mkAnd(enc, ctx.mkEq(r.executes(ctx), w.executes(ctx)));
                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge("rf", w, r, ctx)));
                enc = ctx.mkAnd(enc, Utils.edge("rmw", r, w, ctx));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }
}
