package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;

/**
 *
 * @author Florian Furbach
 */
public class RelUnion extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "+" + r2.getName() + ")";
    }

    public RelUnion(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelUnion(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitUnion(this, r1, r2);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet(Sets.union(r1.getMinTupleSet(), r2.getMinTupleSet()));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet(Sets.union(r1.getMaxTupleSet(), r2.getMaxTupleSet()));
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(minTupleSet != null){
            minTupleSet.addAll(Sets.union(r1.getMinTupleSetRecursive(), r2.getMinTupleSetRecursive()));
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(maxTupleSet != null){
            maxTupleSet.addAll(Sets.union(r1.getMaxTupleSetRecursive(), r2.getMaxTupleSetRecursive()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }
}