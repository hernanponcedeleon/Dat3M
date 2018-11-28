package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.event.MemEvent;
import dartagnan.program.memory.Location;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.*;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

public class RelRf extends Relation {

    public RelRf(){
        term = "rf";
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
            Collection<Event> eventsInit = program.getEventRepository().getEvents(EventRepository.INIT);
            Collection<Event> eventsStore = program.getEventRepository().getEvents(EventRepository.STORE);
            Collection<Event> eventsLoad = program.getEventRepository().getEvents(EventRepository.LOAD);

            for(Event e1 : eventsInit){
                for(Event e2 : eventsLoad){
                    if(MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent) e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsLoad){
                    if(MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent) e2)){
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
                BoolExpr rel = edge("rf", tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(
                        ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx)),
                        ctx.mkEq(((MemEvent)tuple.getFirst()).getAddressExpr(), ((MemEvent)tuple.getSecond()).getAddressExpr())
                )));
            }

            BoolExpr dfEnc = ctx.mkTrue();
            Map<Location, List<MemEvent>> stores = new HashMap<>();
            Map<Location, List<MemEvent>> loads = new HashMap<>();

            for(Tuple tuple : maxTupleSet){
                MemEvent store = (MemEvent) tuple.getFirst();
                for(Location location : store.getMaxLocationSet()){
                    stores.putIfAbsent(location, new ArrayList<>());
                    stores.get(location).add(store);
                }

                MemEvent load = (MemEvent) tuple.getSecond();
                for(Location location : load.getMaxLocationSet()){
                    loads.putIfAbsent(location, new ArrayList<>());
                    loads.get(location).add(load);
                }
            }

            for(Location location : loads.keySet()){
                for(MemEvent r : loads.get(location)){
                    Set<BoolExpr> rfPairs = new HashSet<>();
                    for(MemEvent w : stores.get(location)) {
                        rfPairs.add(edge("rf", w, r, ctx));
                        dfEnc = ctx.mkAnd(dfEnc, ctx.mkImplies(
                                edge("rf", w, r, ctx),
                                ctx.mkEq(w.getSsaLoc(location), r.getSsaLoc(location))
                        ));
                    }
                    enc = ctx.mkAnd(enc, ctx.mkImplies(
                            ctx.mkAnd(r.executes(ctx), ctx.mkEq(r.getAddressExpr(), location.getAddress().toZ3(ctx))),
                            encodeEO(rfPairs)
                    ));
                }
            }
            enc = ctx.mkAnd(enc, dfEnc);
        }

        return enc;
    }

    private BoolExpr encodeEO(Collection<BoolExpr> set) {
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
