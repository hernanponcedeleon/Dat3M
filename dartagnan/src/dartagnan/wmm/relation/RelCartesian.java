package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;

import java.util.Collection;

public class RelCartesian extends Relation {

    private FilterAbstract filter1;
    private FilterAbstract filter2;
    private int eventMask = EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE;

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2) {
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = "(" + filter1 + "*" + filter2 + ")";
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name) {
        super(name);
        this.filter1 = filter1;
        this.filter2 = filter2;
        this.term = "(" + filter1 + " * " + filter2 + ")";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                if(filter1.filter(e1) && filter2.filter(e2)){
                    enc = ctx.mkAnd(enc, Utils.edge(this.getName(), e1, e2, ctx));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));
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
