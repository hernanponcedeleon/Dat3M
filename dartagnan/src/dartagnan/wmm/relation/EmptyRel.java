package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.wmm.EncodingsCAT;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class EmptyRel extends Relation {

    public EmptyRel() {
        super("0");
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), events, ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }

    @Override
    protected BoolExpr encodePredicateBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }

    @Override
    protected BoolExpr encodePredicateApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }
}
