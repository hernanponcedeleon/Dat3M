package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.memory.Location;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.*;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intVar;

public class RelCo extends Relation {

    public RelCo(){
        term = "co";
    }

    @Override
    public void initialise(Program program, Context ctx, int encodingMode){
        super.initialise(program, ctx, encodingMode);
        encodeTupleSet.addAll(getMaxTupleSet());
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            Collection<Event> eventsStore = program.getEventRepository().getEvents(EventRepository.STORE);
            Collection<Event> eventsInit = program.getEventRepository().getEvents(EventRepository.INIT);

            for(Event e1 : eventsInit){
                for(Event e2 : eventsStore){
                    if(MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsStore){
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

        if(!maxTupleSet.isEmpty()){
            for(Tuple tuple : maxTupleSet){
                BoolExpr rel = edge("co", tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(
                        ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx)),
                        ctx.mkEq(((MemEvent)tuple.getFirst()).getAddressExpr(ctx), ((MemEvent)tuple.getSecond()).getAddressExpr(ctx))
                )));
            }

            EventRepository eventRepository = program.getEventRepository();
            for(Event e : eventRepository.getEvents(EventRepository.INIT)) {
                enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(1)));
            }

            Map<Location, List<MemEvent>> stores = new HashMap<>();
            for(Event e : eventRepository.getEvents(EventRepository.STORE | EventRepository.INIT)){
                for(Location location : ((MemEvent)e).getMaximumLocationSet()){
                    stores.putIfAbsent(location, new ArrayList<>());
                    stores.get(location).add((MemEvent)e);
                }
            }

            for(Location location : stores.keySet()){
                List<MemEvent> events = stores.get(location);
                enc = ctx.mkAnd(enc, satTO(events));
                for(Event w1 : events){
                    BoolExpr lastCoOrder = ctx.mkAnd(w1.executes(ctx), ctx.mkEq(((MemEvent)w1).getAddressExpr(ctx), location.getAddress().toZ3(ctx)));
                    for(Event w2 : events){
                        lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(edge("co", w1, w2, ctx)));
                    }
                    enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(location.getLastValueExpr(ctx), ((MemEvent) w1).getSsaLoc(location))));
                }
            }
        }
        return enc;
    }

    private BoolExpr satTO(Collection<MemEvent> events) {
        BoolExpr enc = ctx.mkTrue();
        String name = getName();

        for(Event e1 : events) {
            enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e1, e1, ctx)));
            enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkAnd(
                    ctx.mkGt(Utils.intVar(name, e1, ctx), ctx.mkInt(0)),
                    ctx.mkLe(Utils.intVar(name, e1, ctx), ctx.mkInt(events.size()))
            )));
            for(Event e2 : events) {
                if(e1 != e2) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(edge(name, e1, e2, ctx),
                            ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))));

                    enc = ctx.mkAnd(enc, ctx.mkImplies(
                            ctx.mkAnd(
                                ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
                                ctx.mkEq(((MemEvent)e1).getAddressExpr(ctx), ((MemEvent)e2).getAddressExpr(ctx))
                            ),
                            ctx.mkAnd(
                                    ctx.mkImplies(ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx)), edge(name, e1, e2, ctx)),
                                    ctx.mkAnd(
                                            ctx.mkNot(ctx.mkEq(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))),
                                            ctx.mkOr(edge(name, e1, e2, ctx), edge(name, e2, e1, ctx))
                                    )
                            )
                    ));
                }
            }
        }
        return enc;
    }
}
