package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;

import java.util.Collection;

import static dartagnan.utils.Utils.edge;

public class RelSetIdentity extends Relation {

    protected FilterAbstract filter;

    public RelSetIdentity(FilterAbstract filter, String name, String term) {
        super(name, term);
        this.filter = filter;
    }

    public RelSetIdentity(FilterAbstract filter, String term) {
        this(filter, "[" + filter.toString() + "]", term);
    }

    public RelSetIdentity(FilterAbstract filter) {
        this(filter,"[" + filter.toString() + "]");
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e : events) {
            if(filter.filter(e)){
                enc = ctx.mkAnd(enc, edge(this.getName(), e, e, ctx));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkNot(edge(this.getName(), e, e, ctx)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }
}
