package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

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
        return ctx.mkTrue();
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
            for(Event e1 : events){
                for(Event e2 : events){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
        }
        return maxTupleSet;
    }
}
