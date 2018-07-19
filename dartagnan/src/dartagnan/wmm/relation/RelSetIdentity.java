package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.Program;
import dartagnan.program.event.filter.FilterAbstract;

import java.util.Set;

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

    protected BoolExpr encode(Set<Event> events, Context ctx) throws Z3Exception {
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
