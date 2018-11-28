package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

import static dartagnan.utils.Utils.edge;

public class RelLoc extends BasicRelation {

    public RelLoc(){
        term = "loc";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            Collection<Event> events = program.getEventRepository().getEvents(EventRepository.MEMORY);
            for(Event e1 : events){
                for(Event e2 : events){
                    if(e1.getEId() != e2.getEId() && MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet) {
            BoolExpr rel = edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(
                    ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx)),
                    ctx.mkEq(((MemEvent)tuple.getFirst()).getAddressExpr(), ((MemEvent)tuple.getSecond()).getAddressExpr())
            )));
        }
        return enc;
    }
}
