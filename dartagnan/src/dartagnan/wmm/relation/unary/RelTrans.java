package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;
import dartagnan.wmm.relation.utils.TupleSet;

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
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
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
    public TupleSet getMaxTupleSetRecursive(){
        if(containsRec && maxTupleSet != null){
            throw new RuntimeException("Method getMaxTupleSetRecursive is not implemented for " + this.getClass().getName());
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        encodeTupleSet.addAll(tuples);
        TupleSet r1NewSet = new TupleSet();
        Set<Tuple> currentSet = new HashSet<>(encodeTupleSet);

        while(true){
            Set<Tuple> newSet = new HashSet<>();

            for(Tuple tuple1 : currentSet){
                Event e1 = tuple1.getFirst();
                Event e2 = tuple1.getSecond();

                for(Tuple tuple2 : r1.getMaxTupleSet().getByFirst(e1)){
                    if(tuple2.getSecond().getEId().equals(e2.getEId())){
                        r1NewSet.add(tuple2);
                    } else if(reachabilityMap.get(tuple2.getSecond()).contains(e2)){
                        newSet.add(new Tuple(e1, tuple2.getSecond()));
                        newSet.add(new Tuple(tuple2.getSecond(), e2));
                        r1NewSet.add(tuple2);
                    }
                }
            }

            newSet.removeAll(currentSet);
            currentSet = newSet;
            if(currentSet.isEmpty()){
                break;
            }
        }

        r1.addEncodeTupleSet(r1NewSet);
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        int iteration = 0;

        // Encode initial iteration
        Set<Tuple> currentTupleSet = new HashSet<>(r1.getEncodeTupleSet());
        for(Tuple tuple : currentTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(r1.getName() + iteration, tuple.getFirst(), tuple.getSecond(), ctx),
                    Utils.edge(r1.getName(), tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        while(true){
            Map<Tuple, Set<BoolExpr>> currentTupleMap = new HashMap<>();
            Set<Tuple> newTupleSet = new HashSet<>();

            // Original tuples from the previous iteration
            for(Tuple tuple : currentTupleSet){
                currentTupleMap.putIfAbsent(tuple, new HashSet<>());
                currentTupleMap.get(tuple).add(
                        Utils.edge(r1.getName() + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
                );
            }

            // Combine tuples from the previous iteration
            for(Tuple tuple1 : currentTupleSet){
                Event e1 = tuple1.getFirst();
                Event e3 = tuple1.getSecond();
                for(Tuple tuple2 : currentTupleSet){
                    if(e3.getEId().equals(tuple2.getFirst().getEId())){
                        Event e2 = tuple2.getSecond();
                        Tuple newTuple = new Tuple(e1, e2);
                        currentTupleMap.putIfAbsent(newTuple, new HashSet<>());
                        currentTupleMap.get(newTuple).add(ctx.mkAnd(
                                Utils.edge(r1.getName() + iteration, e1, e3, ctx),
                                Utils.edge(r1.getName() + iteration, e3, e2, ctx)
                        ));

                        if(!newTuple.getFirst().getEId().equals(newTuple.getSecond().getEId())){
                            newTupleSet.add(newTuple);
                        }
                    }
                }
            }

            iteration++;

            // Encode this iteration
            for(Tuple tuple : currentTupleMap.keySet()){
                BoolExpr orClause = ctx.mkFalse();
                for(BoolExpr expr : currentTupleMap.get(tuple)){
                    orClause = ctx.mkOr(orClause, expr);
                }

                BoolExpr edge = Utils.edge(r1.getName() + iteration, tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkEq(edge, orClause));
            }

            if(!currentTupleSet.addAll(newTupleSet)){
                break;
            }
        }

        // Encode that transitive relation equals the relation at the last iteration
        for(Tuple tuple : encodeTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx),
                    Utils.edge(r1.getName() + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        return enc;
    }


    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

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
                        if(!allEncoded.contains(new Tuple(e1, e3))){
                            encodeNext.add(new Tuple(e1, e3));
                        }
                        if(!allEncoded.contains(new Tuple(e3, e2))){
                            encodeNext.add(new Tuple(e3, e2));
                        }
                    }
                }

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