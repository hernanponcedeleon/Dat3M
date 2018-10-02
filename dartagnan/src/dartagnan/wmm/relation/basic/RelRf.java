package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Location;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

public class RelRf extends Relation {

    public RelRf(){
        term = "rf";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            Collection<Event> eventsInit = program.getEventRepository().getEvents(EventRepository.EVENT_INIT);
            Collection<Event> eventsStore = program.getEventRepository().getEvents(EventRepository.EVENT_STORE);
            Collection<Event> eventsLoad = program.getEventRepository().getEvents(EventRepository.EVENT_LOAD);

            for(Event e1 : eventsInit){
                for(Event e2 : eventsLoad){
                    if(e1.getLoc() == e2.getLoc()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsLoad){
                    if(e1.getLoc() == e2.getLoc()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        if(!encodeTupleSet.isEmpty()){
            for(Tuple tuple : maxTupleSet){
                BoolExpr rel = edge("rf", tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx))));
            }

            Collection<Event> eventsLoad = program.getEventRepository().getEvents(EventRepository.EVENT_LOAD);
            Collection<Event> eventsStoreInit = program.getEventRepository().getEvents(EventRepository.EVENT_INIT | EventRepository.EVENT_STORE);
            Collection<Location> locations = eventsLoad.stream().map(e -> e.getLoc()).collect(Collectors.toSet());

            for(Location loc : locations) {
                for(Event r : eventsLoad){
                    if(r.getLoc() == loc){
                        Set<BoolExpr> rfPairs = new HashSet<BoolExpr>();
                        for(Event w : eventsStoreInit) {
                            if(w.getLoc() == loc){
                                rfPairs.add(edge("rf", w, r, ctx));
                            }
                        }
                        enc = ctx.mkAnd(enc, ctx.mkImplies(r.executes(ctx), encodeEO(rfPairs)));
                    }
                }
            }
        }

        return enc;
    }

    private BoolExpr encodeEO(Collection<BoolExpr> set) throws Z3Exception {
        BoolExpr enc = ctx.mkFalse();
        for(BoolExpr exp : set) {
            BoolExpr thisYesOthersNot = exp;
            for(BoolExpr x : set.stream().filter(x -> x != exp).collect(Collectors.toSet())) {
                thisYesOthersNot = ctx.mkAnd(thisYesOthersNot, ctx.mkNot(x));
            }
            enc = ctx.mkOr(enc, thisYesOthersNot);
        }
        return enc;
    }
}
