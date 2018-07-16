package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Event;

import java.util.Set;

import static dartagnan.utils.Utils.edge;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

    public Empty(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Event e1 : events){
            for(Event e2 : events){
                enc = ctx.mkAnd(enc, ctx.mkNot(edge(rel.getName(), e1, e2, ctx)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkNot(_consistent(events, ctx));
    }

    @Override
    protected String _toString() {
        return String.format("empty %s", rel.getName());
    }
}
