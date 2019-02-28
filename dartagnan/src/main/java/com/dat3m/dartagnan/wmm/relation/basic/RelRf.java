package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.*;

import static com.dat3m.dartagnan.utils.Utils.edge;

public class RelRf extends Relation {

    public RelRf(){
        term = "rf";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            List<Event> eventsLoad = program.getCache().getEvents(FilterBasic.get(EType.READ));
            List<Event> eventsInit = program.getCache().getEvents(FilterBasic.get(EType.INIT));
            List<Event> eventsStore = program.getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(EType.WRITE),
                    FilterBasic.get(EType.INIT)
            ));

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
        Map<MemEvent, List<BoolExpr>> rfMap = new HashMap<>();

        for(Tuple tuple : maxTupleSet){
            MemEvent w = (MemEvent) tuple.getFirst();
            MemEvent r = (MemEvent) tuple.getSecond();
            BoolExpr rel = edge("rf", w, r, ctx);
            rfMap.putIfAbsent(r, new ArrayList<>());
            rfMap.get(r).add(rel);

            enc = ctx.mkAnd(enc, ctx.mkImplies(rel, ctx.mkAnd(
                    ctx.mkAnd(w.executes(ctx), r.executes(ctx)),
                    ctx.mkAnd(
                            ctx.mkEq(w.getMemAddressExpr(), r.getMemAddressExpr()),
                            ctx.mkEq(w.getMemValueExpr(), r.getMemValueExpr())
                    )
            )));
        }

        for(MemEvent r : rfMap.keySet()){
            enc = ctx.mkAnd(enc, ctx.mkImplies(r.executes(ctx), encodeEO(r.getCId(), rfMap.get(r))));
        }

        return enc;
    }

    private BoolExpr encodeEO(int readId, List<BoolExpr> set){
        int num = set.size();

        BoolExpr enc = ctx.mkEq(mkL(readId, 0), ctx.mkFalse());
        enc = ctx.mkAnd(enc, ctx.mkNot(ctx.mkAnd(set.get(0), mkL(readId, 0))));
        BoolExpr atLeastOne = set.get(0);

        for(int i = 1; i < num; i++){
            enc = ctx.mkAnd(enc, ctx.mkEq(mkL(readId, i), ctx.mkOr(mkL(readId, i - 1), set.get(i - 1))));
            enc = ctx.mkAnd(enc, ctx.mkNot(ctx.mkAnd(set.get(i), mkL(readId, i))));
            atLeastOne = ctx.mkOr(atLeastOne, set.get(i));
        }
        return ctx.mkAnd(enc, atLeastOne);
    }

    private BoolExpr mkL(int readId, int i) {
        return (BoolExpr) ctx.mkConst("l(" + readId + "," + i + ")", ctx.mkBoolSort());
    }
}
