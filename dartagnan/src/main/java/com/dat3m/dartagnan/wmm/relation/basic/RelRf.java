package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.*;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

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
        Map<MemEvent, List<BoolExpr>> edgeMap = new HashMap<>();
        Map<MemEvent, BoolExpr> memInitMap = new HashMap<>();

        for(Tuple tuple : maxTupleSet){
            MemEvent w = (MemEvent) tuple.getFirst();
            MemEvent r = (MemEvent) tuple.getSecond();
            BoolExpr edge = edge(term, w, r, ctx);
            BoolExpr sameAddress = ctx.mkEq(w.getMemAddressExpr(), r.getMemAddressExpr());
            BoolExpr sameValue = ctx.mkEq(w.getMemValueExpr(), r.getMemValueExpr());

            edgeMap.putIfAbsent(r, new ArrayList<>());
            edgeMap.get(r).add(edge);
            if(w.is(EType.INIT)){
                memInitMap.put(r, ctx.mkOr(memInitMap.getOrDefault(r, ctx.mkFalse()), sameAddress));
            }
            enc = ctx.mkAnd(enc, ctx.mkImplies(edge, ctx.mkAnd(w.exec(), r.exec(), sameAddress, sameValue)));
        }

        for(MemEvent r : edgeMap.keySet()){
            BoolExpr forceEdge = settings.getFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF)
                    ? encodeExactlyOneSeq(r.getCId(), edgeMap.get(r))
                    : encodeExactlyOneNaive(edgeMap.get(r));

            if(settings.getFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY)){
                enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(r.exec(), memInitMap.get(r)), forceEdge));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkImplies(r.exec(), forceEdge));
            }
        }
        return enc;
    }

    private BoolExpr encodeExactlyOneNaive(List<BoolExpr> edges){
        BoolExpr enc = ctx.mkFalse();
        for(BoolExpr thisEdge : edges){
            BoolExpr clause = ctx.mkTrue();
            for(BoolExpr otherEdge : edges){
                if(!thisEdge.equals(otherEdge)){
                    clause = ctx.mkAnd(clause, ctx.mkNot(otherEdge));
                }
            }
            enc = ctx.mkOr(enc, ctx.mkAnd(thisEdge, ctx.mkAnd(clause)));
        }
        return enc;
    }

    private BoolExpr encodeExactlyOneSeq(int readId, List<BoolExpr> edges){
        BoolExpr lastSeqVar = mkSeqVar(readId, 0);
        BoolExpr newSeqVar = lastSeqVar;
        BoolExpr enc = ctx.mkEq(lastSeqVar, edges.get(0));

        for(int i = 1; i < edges.size(); i++){
            newSeqVar = mkSeqVar(readId, i);
            enc = ctx.mkAnd(enc,
                    ctx.mkEq(newSeqVar, ctx.mkOr(lastSeqVar, edges.get(i))),
                    ctx.mkNot(ctx.mkAnd(edges.get(i), lastSeqVar)));
            lastSeqVar = newSeqVar;
        }

        return ctx.mkAnd(enc, ctx.mkOr(newSeqVar, edges.get(edges.size() - 1)));
    }

    private BoolExpr mkSeqVar(int readId, int i) {
        return (BoolExpr) ctx.mkConst("s(" + term + ",E" + readId + "," + i + ")", ctx.mkBoolSort());
    }
}
