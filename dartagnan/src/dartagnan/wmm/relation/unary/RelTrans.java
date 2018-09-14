package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    private Map<Event, Set<Event>> reachabilityMap;

    public static String makeTerm(Relation r1){
        return r1.getName() + "^+";
    }

    public RelTrans(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTrans(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            reachabilityMap = new HashMap<>();
            for(Tuple tuple : r1.getMaxTupleSet()){
                reachabilityMap.putIfAbsent(tuple.getFirst(), new HashSet<>());
                reachabilityMap.putIfAbsent(tuple.getSecond(), new HashSet<>());
                Set<Event> events = reachabilityMap.get(tuple.getFirst());
                events.add(tuple.getSecond());
            }

            boolean changed;
            do {
                changed = false;
                for(Event e1 : reachabilityMap.keySet()){
                    Set<Event> newEls = new HashSet<>();
                    for(Event e2 : reachabilityMap.get(e1)){
                        if(!(e1.getEId().equals(e2.getEId()))){
                            newEls.addAll(reachabilityMap.get(e2));
                        }
                    }
                    if(reachabilityMap.get(e1).addAll(newEls))
                        changed = true;
                }
            } while (changed);

            for(Event e1 : reachabilityMap.keySet()){
                for(Event e2 : reachabilityMap.get(e1)){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    public Set<Tuple> getMaxTupleSetRecursive(){
        if(containsRec && maxTupleSet != null){
            throw new RuntimeException("Method getMaxTupleSetRecursive is not implemented for " + this.getClass().getName());
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);
        if(!activeSet.isEmpty()){
            // TODO: Implementation
            r1.addEncodeTupleSet(r1.getMaxTupleSet());
        }
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Map<Tuple, Set<BoolExpr>> encodeMap = new HashMap<>();

        for(Tuple tuple : encodeTupleSet){
            encodeMap.put(tuple, new HashSet<>());
        }

        Set<Tuple> currentSet = new HashSet<>(r1.getEncodeTupleSet());

        for(Tuple tuple : currentSet){
            BoolExpr currentEdge =  Utils.edge(r1.getName() + 0, tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(currentEdge, Utils.edge(r1.getName(), tuple.getFirst(), tuple.getSecond(), ctx)));
            if(encodeMap.containsKey(tuple)){
                encodeMap.get(tuple).add(currentEdge);
            }
        }

        int i = 0;
        while(true){

            int oldSize = currentSet.size();
            Map<Tuple, Set<BoolExpr>> tempMap = new HashMap<>();

            for(Tuple tuple : currentSet){
                tempMap.putIfAbsent(tuple, new HashSet<>());
                tempMap.get(tuple).add(
                        Utils.edge(r1.getName() + i, tuple.getFirst(), tuple.getSecond(), ctx)
                );
            }

            Set<Tuple> newSet = new HashSet<>();

            for(Tuple tuple1 : currentSet){
                Event e1 = tuple1.getFirst();
                Event e3 = tuple1.getSecond();
                for(Tuple tuple2 : currentSet){
                    if(e3.getEId().equals(tuple2.getFirst().getEId())){
                        Event e2 = tuple2.getSecond();
                        Tuple newTuple = new Tuple(e1, e2);
                        tempMap.putIfAbsent(newTuple, new HashSet<>());

                        tempMap.get(newTuple).add(ctx.mkAnd(
                                Utils.edge(r1.getName() + i, e1, e3, ctx),
                                Utils.edge(r1.getName() + i, e3, e2, ctx)
                        ));

                        if(!newTuple.getFirst().getEId().equals(newTuple.getSecond().getEId())){
                            newSet.add(newTuple);
                        }
                    }
                }
            }

            currentSet.addAll(newSet);

            for(Tuple tuple : tempMap.keySet()){
                BoolExpr orClause = ctx.mkFalse();
                for(BoolExpr expr : tempMap.get(tuple)){
                    orClause = ctx.mkOr(orClause, expr);
                }

                BoolExpr edge = Utils.edge(r1.getName() + (i + 1), tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkEq(edge, orClause));

                if(encodeMap.containsKey(tuple)){
                    encodeMap.get(tuple).add(edge);
                }
            }

            if(currentSet.size() == oldSize) break;

            i++;
        }

        for(Tuple tuple : encodeMap.keySet()){
            BoolExpr orClause = ctx.mkFalse();
            for(BoolExpr expr : encodeMap.get(tuple)){
                orClause = ctx.mkOr(orClause, expr);
            }

            BoolExpr edge = Utils.edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(edge, orClause));
        }

        return enc;
    }


    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        // TODO: Add necessary tuples to r1 for CloseApprox option
        //BoolExpr orClose1 = ctx.mkFalse();
        //BoolExpr orClose2 = ctx.mkFalse();

        Set<Tuple> allEncoded = new HashSet<>(encodeTupleSet);
        Set<Tuple> encodeNow = new HashSet<>(encodeTupleSet);

        while(true){
            Set<Tuple> encodeNext = new HashSet<>();

            for(Tuple tuple : encodeNow){
                BoolExpr orClause = ctx.mkFalse();
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();

                Set<Event> reachableEvents = reachabilityMap.get(e1);
                if(r1.getMaxTupleSet().contains(new Tuple(e1, e2))){
                    orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
                }

                for(Event e3 : reachableEvents){
                    if(!e3.getEId().equals(e1.getEId()) && !e3.getEId().equals(e2.getEId())){
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx), Utils.edge(this.getName(), e3, e2, ctx)));

                        //if(Relation.CloseApprox){
                        //    orclose1 = ctx.mkOr(orclose1, Utils.edge(r1.getName(), e1, e3, ctx));
                        //    orclose2 = ctx.mkOr(orclose2, Utils.edge(r1.getName(), e3, e2, ctx));
                        //}

                        if(!allEncoded.contains(new Tuple(e1, e3))){
                            encodeNext.add(new Tuple(e1, e3));
                        }
                        if(!allEncoded.contains(new Tuple(e3, e2))){
                            encodeNext.add(new Tuple(e3, e2));
                        }
                    }
                }

                //if(Relation.CloseApprox){
                //    enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(orclose1, orclose2)));
                //}

                if(Relation.PostFixApprox) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(this.getName(), e1, e2, ctx)));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), orClause));
                }
            }

            if(encodeNext.isEmpty())
                break;

            encodeNow.clear();
            encodeNow.addAll(encodeNext);
            allEncoded.addAll(encodeNext);
        }
        return enc;
    }
}