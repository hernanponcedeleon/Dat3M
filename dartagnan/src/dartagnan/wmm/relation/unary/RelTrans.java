package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intCount;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    protected Map<Event, Set<Event>> transReachabilityMap;
    private TupleSet fullEncodeTupleSet;

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
    public void initialise(Program program, Context ctx, int encodingMode){
        super.initialise(program, ctx, encodingMode);
        transReachabilityMap = null;
        fullEncodeTupleSet = null;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            transReachabilityMap = makeTransitiveReachabilityMap(r1.getMaxTupleSet());
            maxTupleSet = new TupleSet();
            for(Event e1 : transReachabilityMap.keySet()){
                for(Event e2 : transReachabilityMap.get(e1)){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        if(encodeTupleSet.addAll(tuples)){
            r1.addEncodeTupleSet(getFullEncodeTupleSet(true));
        }
    }

    @Override
    protected BoolExpr encodeIdl() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        TupleSet fullEncodeSet = getFullEncodeTupleSet(false);

        for(Tuple tuple : fullEncodeSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Tuple tuple2 : fullEncodeSet.getByFirst(e1)){
                if (!tuple2.equals(tuple)) {
                    Event e3 = tuple2.getSecond();
                    if (transReachabilityMap.get(e3).contains(e2)) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(
                                edge(this.getName(), e1, e3, ctx),
                                edge(this.getName(), e3, e2, ctx),
                                ctx.mkGt(intCount(this.idlConcatName(), e1, e2, ctx), intCount(this.getName(), e1, e3, ctx)),
                                ctx.mkGt(intCount(this.idlConcatName(), e1, e2, ctx), intCount(this.getName(), e3, e2, ctx))));
                    }
                }
            }

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.idlConcatName(), e1, e2, ctx), orClause));

            orClause = ctx.mkFalse();
            for(Tuple tuple2 : fullEncodeSet.getByFirst(e1)){
                if (!tuple2.equals(tuple)) {
                    Event e3 = tuple2.getSecond();
                    if (transReachabilityMap.get(e3).contains(e2)) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(
                                edge(this.getName(), e1, e3, ctx),
                                edge(this.getName(), e3, e2, ctx)));
                    }
                }
            }

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.idlConcatName(), e1, e2, ctx), orClause));

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(), e1, e2, ctx), ctx.mkOr(
                    edge(r1.getName(), e1,e2, ctx),
                    ctx.mkAnd(edge(this.idlConcatName(), e1, e2, ctx), ctx.mkGt(intCount(this.getName(), e1, e2, ctx), intCount(this.idlConcatName(), e1, e2, ctx)))
            )));

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(),e1,e2, ctx), ctx.mkOr(
                    edge(r1.getName(), e1,e2, ctx),
                    edge(this.idlConcatName(), e1, e2, ctx)
            )));
        }

        return enc;
    }

    @Override
    protected BoolExpr encodeBasic() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        int iteration = 0;

        // Encode initial iteration
        Set<Tuple> currentTupleSet = new HashSet<>(r1.getEncodeTupleSet());
        for(Tuple tuple : currentTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx),
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
                        Utils.edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
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
                                Utils.edge(r1.getName() + "_" + iteration, e1, e3, ctx),
                                Utils.edge(r1.getName() + "_" + iteration, e3, e2, ctx)
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

                BoolExpr edge = Utils.edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx);
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
                    Utils.edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        return enc;
    }


    @Override
    protected BoolExpr encodeApprox() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        TupleSet encodeSet = getFullEncodeTupleSet(false);

        for(Tuple tuple : encodeSet){
            BoolExpr orClause = ctx.mkFalse();

            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            // Directly related via r1
            if(r1.getMaxTupleSet().contains(new Tuple(e1, e2))){
                orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
            }

            // Transitive relation
            for(Event e3 : transReachabilityMap.get(e1)){
                if(!e3.getEId().equals(e1.getEId()) && !e3.getEId().equals(e2.getEId()) && transReachabilityMap.get(e3).contains(e2)){
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx), Utils.edge(this.getName(), e3, e2, ctx)));
                }
            }

            if(Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(this.getName(), e1, e2, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), orClause));
            }
        }

        return enc;
    }

    private TupleSet getFullEncodeTupleSet(boolean forceUpdate){
        if(fullEncodeTupleSet == null || forceUpdate){
            fullEncodeTupleSet = new TupleSet();

            TupleSet processNow = new TupleSet();
            processNow.addAll(encodeTupleSet);
            processNow.retainAll(getMaxTupleSet());

            while(!processNow.isEmpty()){
                TupleSet processNext = new TupleSet();
                for(Tuple tuple : processNow){
                    fullEncodeTupleSet.add(tuple);
                    Event e1 = tuple.getFirst();
                    Event e2 = tuple.getSecond();

                    for(Event e3 : transReachabilityMap.get(e1)){
                        if(!e3.getEId().equals(e1.getEId())
                                && !e3.getEId().equals(e2.getEId())
                                && transReachabilityMap.get(e3).contains(e2)){
                            processNext.add(new Tuple(e1, e3));
                            processNext.add(new Tuple(e3, e2));
                        }
                    }
                }

                processNext.removeAll(fullEncodeTupleSet);
                processNow = processNext;
            }
        }
        return fullEncodeTupleSet;
    }

    private Map<Event, Set<Event>> makeTransitiveReachabilityMap(Set<Tuple> tuples){
        Map<Event, Set<Event>> map = new HashMap<>();

        for(Tuple tuple : tuples){
            map.putIfAbsent(tuple.getFirst(), new HashSet<>());
            map.putIfAbsent(tuple.getSecond(), new HashSet<>());
            Set<Event> events = map.get(tuple.getFirst());
            events.add(tuple.getSecond());
        }

        boolean changed = true;

        while (changed){
            changed = false;
            for(Event e1 : map.keySet()){
                Set<Event> newEls = new HashSet<>();
                for(Event e2 : map.get(e1)){
                    if(!(e1.getEId().equals(e2.getEId()))){
                        newEls.addAll(map.get(e2));
                    }
                }
                if(map.get(e1).addAll(newEls))
                    changed = true;
            }
        }

        return map;
    }

    private String idlConcatName(){
        return "(" + getName() + ";" + getName() + ")";
    }
}