package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.MemEvent;
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
        forceDoEncode = true;
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

        for(Tuple tuple : maxTupleSet){
            BoolExpr rel = edge("rf", tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(
                    ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx)),
                    ctx.mkEq(((MemEvent)tuple.getFirst()).getAddressExpr(), ((MemEvent)tuple.getSecond()).getAddressExpr())
            )));
        }

        for(Event e : program.getEventRepository().getEvents(EventRepository.LOAD)){
            Load r = (Load)e;
            Set<BoolExpr> rfPairs = new HashSet<>();

            for(Tuple t : maxTupleSet.getBySecond(r)){
                MemEvent w = (MemEvent) t.getFirst();
                rfPairs.add(edge("rf", w, r, ctx));
                enc = ctx.mkAnd(enc, ctx.mkImplies(
                        edge("rf", w, r, ctx),
                        ctx.mkEq(w.getValueExpr(), r.getValueExpr())
                ));
            }
            enc = ctx.mkAnd(enc, ctx.mkImplies(r.executes(ctx), encodeEO(rfPairs)));
        }
        return enc;
    }

    private BoolExpr encodeEO(Set<BoolExpr> set) {
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
