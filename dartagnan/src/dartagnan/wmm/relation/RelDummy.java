package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class RelDummy extends Relation {
    
    public RelDummy(String name) {
        super(name);
        containsRec = true;
    }

    @Override
    public BoolExpr encode(Program program, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        return encodeBasic(program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY), ctx);
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }
}
