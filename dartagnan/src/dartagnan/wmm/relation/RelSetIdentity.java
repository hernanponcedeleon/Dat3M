package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.program.utils.EventRepository;

import java.util.Collection;

import static dartagnan.utils.Utils.edge;

public class RelSetIdentity extends Relation {

    protected FilterAbstract filter;
    protected int eventMask = EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU;

    public RelSetIdentity(FilterAbstract filter) {
        this.filter = filter;
        term = "[" + filter + "]";
    }

    public RelSetIdentity(FilterAbstract filter, String name) {
        super(name);
        this.filter = filter;
        term = "[" + filter + "]";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            boolean match = filter.filter(e1);
            for (Event e2 : events){
                if(match && e1.getEId().equals(e2.getEId())){
                    enc = ctx.mkAnd(enc, edge(this.getName(), e1, e2, ctx));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge(this.getName(), e1, e2, ctx)));
                }
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }
}
