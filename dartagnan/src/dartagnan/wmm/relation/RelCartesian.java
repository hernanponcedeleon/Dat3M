package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterAbstract;

import java.util.Set;

import static dartagnan.utils.Utils.edge;

public class RelCartesian extends Relation {

    protected FilterAbstract filter1;
    protected FilterAbstract filter2;

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

    public BoolExpr encode(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                if(filter1.filter(e1) && filter2.filter(e2)){
                    enc = ctx.mkAnd(enc, edge(name, e1, e2, ctx));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e1, e2, ctx)));
                }
            }
        }
        return enc;
    }

    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return encode(program.getEvents(), ctx);
    }

    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception{
        return this.encodeBasic(program, ctx);
    }

    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception{
        return this.encodeBasic(program, ctx);
    }

    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
        return null;
    }

    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception{
        return null;
    }
}
