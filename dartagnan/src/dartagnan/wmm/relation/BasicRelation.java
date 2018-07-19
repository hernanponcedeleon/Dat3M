package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class BasicRelation extends Relation {

    public BasicRelation(String name) {
        super(name);
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }
}
