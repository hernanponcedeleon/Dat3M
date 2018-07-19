package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;
import dartagnan.utils.Utils;

import java.util.Collection;

public class RelCartesian extends Relation {

    private FilterAbstract filter1;
    private FilterAbstract filter2;

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name, String term) {
        super(name, term);
        this.filter1 = filter1;
        this.filter2 = filter2;
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2, String name) {
        this(filter1, filter2, name, filter1.toString() + "*" + filter2.toString());
    }

    public RelCartesian(FilterAbstract filter1, FilterAbstract filter2) {
        this(filter1, filter2, filter1.toString() + "*" + filter2.toString());
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                if(filter1.filter(e1) && filter2.filter(e2)){
                    enc = ctx.mkAnd(enc, Utils.edge(name, e1, e2, ctx));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(name, e1, e2, ctx)));
                }
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }
}
