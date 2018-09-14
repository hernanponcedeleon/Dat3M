package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Location;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;
import dartagnan.wmm.relation.utils.TupleSet;

import java.util.Collection;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intVar;
import static dartagnan.wmm.Encodings.satTO;

public class RelCo extends Relation {

    public RelCo(){
        term = "co";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            Collection<Event> eventsStore = program.getEventRepository().getEvents(EventRepository.EVENT_STORE);
            Collection<Event> eventsInit = program.getEventRepository().getEvents(EventRepository.EVENT_INIT);

            for(Event e1 : eventsInit){
                for(Event e2 : eventsStore){
                    if(e1.getLoc() == e2.getLoc()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsStore){
                    if(!e1.getEId().equals(e2.getEId()) && e1.getLoc() == e2.getLoc()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        if(!encodeTupleSet.isEmpty()){
            for(Tuple tuple : maxTupleSet){
                BoolExpr rel = edge("co", tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx))));
            }

            EventRepository eventRepository = program.getEventRepository();
            for(Event e : eventRepository.getEvents(EventRepository.EVENT_INIT)) {
                enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(1)));
            }

            Collection<Event> eventsStoreInit = eventRepository.getEvents(EventRepository.EVENT_INIT | EventRepository.EVENT_STORE);
            Collection<Location> locations = eventsStoreInit.stream().map(e -> e.getLoc()).collect(Collectors.toSet());

            for(Location loc : locations) {
                Collection<Event> eventsStoreInitByLocation = eventsStoreInit.stream().filter(e -> e.getLoc() == loc).collect(Collectors.toSet());
                enc = ctx.mkAnd(enc, satTO("co", eventsStoreInitByLocation, ctx));
                for(Event w1 : eventsStoreInitByLocation){
                    BoolExpr lastCoOrder = w1.executes(ctx);
                    for(Event w2 : eventsStoreInitByLocation){
                        lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(edge("co", w1, w2, ctx)));
                    }
                    enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(w1.getLoc().getLastValueExpr(ctx), ((MemEvent) w1).ssaLoc)));
                }
            }
        }

        return enc;
    }
}
