package com.dat3m.dartagnan.wmm.relation.derived;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import org.apache.logging.log4j.util.Strings;

import java.util.ArrayList;
import java.util.List;

public class RelIntersectionNary extends DerivedRelation {

    private final List<Relation> relations;

    public static String makeTerm(List<Relation> rels){
        return "(" + Strings.join(rels, '&') + ")";
    }

    public RelIntersectionNary(List<Relation> rels) {
        relations = new ArrayList<>(rels);
        term = makeTerm(rels);
    }

    public RelIntersectionNary(List<Relation> rels, String name) {
        super(name);
        relations = new ArrayList<>(rels);
        term = makeTerm(rels);
    }

    @Override
    public List<Relation> getDependencies() {
        return relations;
    }


    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet(relations.get(0).getMinTupleSet());
            for (Relation rel : relations.subList(1, relations.size())) {
                minTupleSet.retainAll(rel.getMinTupleSet());
            }
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet(relations.get(0).getMaxTupleSet());
            for (Relation rel : relations.subList(1, relations.size())) {
                maxTupleSet.retainAll(rel.getMaxTupleSet());
            }
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(recursiveGroupId > 0 && minTupleSet != null){
            TupleSet added = new TupleSet(relations.get(0).getMinTupleSetRecursive());
            relations.subList(1, relations.size()).forEach(x -> added.retainAll(x.getMinTupleSetRecursive()));
            minTupleSet.addAll(added);
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            TupleSet added = new TupleSet(relations.get(0).getMaxTupleSetRecursive());
            relations.subList(1, relations.size()).forEach(x -> added.retainAll(x.getMaxTupleSetRecursive()));
            maxTupleSet.addAll(added);
        }
        return getMaxTupleSet();
    }


    @Override
    public void addEncodeTupleSet(TupleSet tuples) {
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);
        activeSet.removeAll(getMinTupleSet());

        if(!activeSet.isEmpty()){
            relations.forEach(rel -> rel.addEncodeTupleSet(activeSet));
        }
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        TupleSet min = getMinTupleSet();
        BoolExpr[] opts = new BoolExpr[relations.size()];
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }
            for (int i = 0; i < opts.length; i++) {
                opts[i] = relations.get(i).getSMTVar(tuple, ctx);
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), ctx.mkAnd(opts)));

        }
        return enc;
    }
}