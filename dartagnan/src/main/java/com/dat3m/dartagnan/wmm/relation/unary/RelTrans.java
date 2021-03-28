package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intCount;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    Map<Event, Set<Event>> transitiveReachabilityMap;
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
    public void initialise(VerificationTask task, Context ctx){
        super.initialise(task, ctx);
        fullEncodeTupleSet = new TupleSet();
        transitiveReachabilityMap = null;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            //TODO: complete this
            BranchEquivalence eq = task.getBranchEquivalence();
            minTupleSet = new TupleSet(r1.getMinTupleSet());
            boolean changed;
            int size = minTupleSet.size();
            do {
                minTupleSet.addAll(minTupleSet.postComposition(r1.getMinTupleSet(),
                        (t1, t2) -> t1.getSecond().cfImpliesExec() && eq.isImplied(t1.getFirst(), t1.getSecond()) || eq.isImplied(t2.getSecond(), t1.getSecond())));
                changed = minTupleSet.size() != size;
                size = minTupleSet.size();

            } while (changed);
            removeMutuallyExclusiveTuples(minTupleSet);
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            transitiveReachabilityMap = r1.getMaxTupleSet().transMap();
            maxTupleSet = new TupleSet();
            for(Event e1 : transitiveReachabilityMap.keySet()){
                for(Event e2 : transitiveReachabilityMap.get(e1)){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);

        TupleSet fullActiveSet = getFullEncodeTupleSet(activeSet);
        if(fullEncodeTupleSet.addAll(fullActiveSet)){
            r1.addEncodeTupleSet(fullActiveSet);
        }
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        TupleSet minSet = getMinTupleSet();
        TupleSet r1Max = r1.getMaxTupleSet();
        for(Tuple tuple : fullEncodeTupleSet){
            if (minSet.contains(tuple)) {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }

            BoolExpr orClause = ctx.mkFalse();
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            if(r1Max.contains(tuple)){
                orClause = ctx.mkOr(orClause, r1.getSMTVar(tuple, ctx));
            }


            for(Tuple t : r1Max.getByFirst(e1)){
                Event e3 = t.getSecond();
                if(e3.getCId() != e1.getCId() && e3.getCId() != e2.getCId() && transitiveReachabilityMap.get(e3).contains(e2)){
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(r1.getSMTVar(t, ctx), this.getSMTVar(e3, e2, ctx)));
                }
            }

            if(Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, this.getSMTVar(tuple, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), orClause));
            }
        }

        return enc;
    }

    @Override
    protected BoolExpr encodeIDL(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : fullEncodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Tuple tuple2 : fullEncodeTupleSet.getByFirst(e1)){
                if (!tuple2.equals(tuple)) {
                    Event e3 = tuple2.getSecond();
                    if (transitiveReachabilityMap.get(e3).contains(e2)) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(
                                this.getSMTVar(e1, e3, ctx),
                                this.getSMTVar(e3, e2, ctx),
                                ctx.mkGt(intCount(this.idlConcatName(), e1, e2, ctx), intCount(this.getName(), e1, e3, ctx)),
                                ctx.mkGt(intCount(this.idlConcatName(), e1, e2, ctx), intCount(this.getName(), e3, e2, ctx))));
                    }
                }
            }

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.idlConcatName(), e1, e2, ctx), orClause));

            orClause = ctx.mkFalse();
            for(Tuple tuple2 : fullEncodeTupleSet.getByFirst(e1)){
                if (!tuple2.equals(tuple)) {
                    Event e3 = tuple2.getSecond();
                    if (transitiveReachabilityMap.get(e3).contains(e2)) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(
                                this.getSMTVar(e1, e3, ctx),
                                this.getSMTVar(e3, e2, ctx)));
                    }
                }
            }

            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.idlConcatName(), e1, e2, ctx), orClause));

            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), ctx.mkOr(
                    r1.getSMTVar(tuple, ctx),
                    ctx.mkAnd(edge(this.idlConcatName(), e1, e2, ctx), ctx.mkGt(intCount(this.getName(), e1, e2, ctx), intCount(this.idlConcatName(), e1, e2, ctx)))
            )));

            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), ctx.mkOr(
                    r1.getSMTVar(tuple, ctx),
                    edge(this.idlConcatName(), e1, e2, ctx)
            )));
        }

        return enc;
    }

    @Override
    protected BoolExpr encodeLFP(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        int iteration = 0;

        // Encode initial iteration
        Set<Tuple> currentTupleSet = new HashSet<>(r1.getEncodeTupleSet());
        for(Tuple tuple : currentTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx),
                    edge(r1.getName(), tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        while(true){
            Map<Tuple, Set<BoolExpr>> currentTupleMap = new HashMap<>();
            Set<Tuple> newTupleSet = new HashSet<>();

            // Original tuples from the previous iteration
            for(Tuple tuple : currentTupleSet){
                currentTupleMap.putIfAbsent(tuple, new HashSet<>());
                currentTupleMap.get(tuple).add(
                        edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
                );
            }

            // Combine tuples from the previous iteration
            for(Tuple tuple1 : currentTupleSet){
                Event e1 = tuple1.getFirst();
                Event e3 = tuple1.getSecond();
                for(Tuple tuple2 : currentTupleSet){
                    if(e3.getCId() == tuple2.getFirst().getCId()){
                        Event e2 = tuple2.getSecond();
                        Tuple newTuple = new Tuple(e1, e2);
                        currentTupleMap.putIfAbsent(newTuple, new HashSet<>());
                        currentTupleMap.get(newTuple).add(ctx.mkAnd(
                                edge(r1.getName() + "_" + iteration, e1, e3, ctx),
                                edge(r1.getName() + "_" + iteration, e3, e2, ctx)
                        ));

                        if(newTuple.getFirst().getCId() != newTuple.getSecond().getCId()){
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

                BoolExpr edge = edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx);
                enc = ctx.mkAnd(enc, ctx.mkEq(edge, orClause));
            }

            if(!currentTupleSet.addAll(newTupleSet)){
                break;
            }
        }

        // Encode that transitive relation equals the relation at the last iteration
        for(Tuple tuple : encodeTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx),
                    edge(r1.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        return enc;
    }

    private TupleSet getFullEncodeTupleSet(TupleSet tuples){
        TupleSet processNow = new TupleSet(Sets.intersection(tuples, getMaxTupleSet()));
        TupleSet result = new TupleSet();

        while(!processNow.isEmpty()) {
            TupleSet processNext = new TupleSet();
            result.addAll(processNow);

            for (Tuple tuple : processNow) {
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                for (Tuple t : r1.getMaxTupleSet().getByFirst(e1)) {
                    Event e3 = t.getSecond();
                    if (e3.getCId() != e1.getCId() && e3.getCId() != e2.getCId() &&
                            transitiveReachabilityMap.get(e3).contains(e2)) {
                        result.add(new Tuple(e1, e3));
                        processNext.add(new Tuple(e3, e2));
                    }
                }

            }
            processNext.removeAll(result);
            processNow = processNext;
        }

        return result;
    }

    private String idlConcatName(){
        return "(" + getName() + ";" + getName() + ")";
    }
}