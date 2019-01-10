package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.*;

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
                    ctx.mkEq(((MemEvent)tuple.getFirst()).getMemAddressExpr(), ((MemEvent)tuple.getSecond()).getMemAddressExpr())
            )));
        }

        for(Event e : program.getEventRepository().getEvents(EventRepository.LOAD)){
            Load r = (Load)e;
            List<BoolExpr> rfPairs = new ArrayList<>();

            for(Tuple t : maxTupleSet.getBySecond(r)){
                MemEvent w = (MemEvent) t.getFirst();
                rfPairs.add(edge("rf", w, r, ctx));
                enc = ctx.mkAnd(enc, ctx.mkImplies(
                        edge("rf", w, r, ctx),
                        ctx.mkEq(w.getMemValueExpr(), r.getMemValueExpr())
                ));
            }
            enc = ctx.mkAnd(enc, ctx.mkImplies(r.executes(ctx), encodeEO(e.getEId(), rfPairs)));
        }
        return enc;
    }

    private BoolExpr encodeEO(int readEid, List<BoolExpr> set){
        int num = set.size();

        BoolExpr enc = ctx.mkEq(mkL(readEid, 0), ctx.mkFalse());
        enc = ctx.mkAnd(enc, ctx.mkNot(ctx.mkAnd(set.get(0), mkL(readEid, 0))));
        BoolExpr atLeastOne = set.get(0);

        for(int i = 1; i < num; i++){
            enc = ctx.mkAnd(enc, ctx.mkEq(mkL(readEid, i), ctx.mkOr(mkL(readEid, i - 1), set.get(i - 1))));
            enc = ctx.mkAnd(enc, ctx.mkNot(ctx.mkAnd(set.get(i), mkL(readEid, i))));
            atLeastOne = ctx.mkOr(atLeastOne, set.get(i));
        }
        return ctx.mkAnd(enc, atLeastOne);
    }

    private BoolExpr mkL(int eid, int i) {
        return (BoolExpr) ctx.mkConst("l(" + eid + "," + i + ")", ctx.mkBoolSort());
    }
}
