package com.dat3m.dartagnan.wmm.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.*;

public class RecursiveGroup {

    private final int id;
    private final List<RecursiveRelation> relations;
    private int encodeIterations = 0;

    public RecursiveGroup(int id, Collection<RecursiveRelation> relations){
        for(RecursiveRelation relation : relations){
            relation.setDoRecurse();
            relation.setRecursiveGroupId(id);
        }
        this.relations = new ArrayList<>(relations);
        this.id = id;
    }

    public int getId(){
        return id;
    }

    public void setDoRecurse(){
        for(RecursiveRelation relation : relations){
            relation.setDoRecurse();
        }
    }

    public BoolExpr encode(Context ctx){
        BoolExpr enc = ctx.mkTrue();
        for(int i = 0; i < encodeIterations; i++){
            for(RecursiveRelation relation : relations){
                relation.setDoRecurse();
                enc = ctx.mkAnd(enc, relation.encodeIteration(id, i, ctx));
            }
        }

        for(RecursiveRelation relation : relations){
            enc = ctx.mkAnd(enc, relation.encodeFinalIteration(encodeIterations - 1, ctx));
        }

        return enc;
    }

    public void initMaxTupleSets(){
        int iterationCounter = 0;
        boolean changed = true;

        while(changed){
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setDoRecurse();
                int oldSize = relation.getMaxTupleSet().size();
                if(oldSize != relation.getMaxTupleSetRecursive().size()){
                    changed = true;
                }
            }
            iterationCounter++;
        }
        // iterationCounter + zero iteration + 1
        encodeIterations = iterationCounter + 2;
    }

    public void initMinTupleSets(){
        int iterationCounter = 0;
        boolean changed = true;

        while(changed){
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setDoRecurse();
                int oldSize = relation.getMinTupleSet().size();
                if(oldSize != relation.getMinTupleSetRecursive().size()){
                    changed = true;
                }
            }
            iterationCounter++;
        }
        // iterationCounter + zero iteration + 1
        encodeIterations = iterationCounter + 2;
    }

    public void updateEncodeTupleSets(){
        Map<Relation, Integer> encodeSetSizes = new HashMap<>();
        for(Relation relation : relations){
            encodeSetSizes.put(relation, 0);
        }

        boolean changed = true;
        while(changed){
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setDoRecurse();
                relation.addEncodeTupleSet(relation.getEncodeTupleSet());
                int newSize = relation.getEncodeTupleSet().size();
                if(newSize != encodeSetSizes.get(relation)){
                    encodeSetSizes.put(relation, newSize);
                    changed = true;
                }
            }
        }
    }
}
