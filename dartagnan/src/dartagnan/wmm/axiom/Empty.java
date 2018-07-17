package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.relation.Relation;

import java.util.Set;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

    public Empty(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(rel.getName(), events, ctx);
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
