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

public class RelUnionNary extends DerivedRelation {

    private final List<Relation> relations;

    public static String makeTerm(List<Relation> rels){
        return "(" + Strings.join(rels, '+') + ")";
    }

    public RelUnionNary(List<Relation> rels) {
        relations = new ArrayList<>(rels);
        term = makeTerm(rels);
    }

    public RelUnionNary(List<Relation> rels, String name) {
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
            minTupleSet = new TupleSet();
            relations.forEach(x -> minTupleSet.addAll(x.getMinTupleSet()));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            relations.forEach(x -> maxTupleSet.addAll(x.getMaxTupleSet()));
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(recursiveGroupId > 0 && minTupleSet != null){
            relations.forEach(x -> minTupleSet.addAll(x.getMinTupleSetRecursive()));
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            relations.forEach(x -> maxTupleSet.addAll(x.getMaxTupleSetRecursive()));
            return maxTupleSet;
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

            if (Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkOr(opts), this.getSMTVar(tuple, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), ctx.mkOr(opts)));
            }
        }
        return enc;
    }
}