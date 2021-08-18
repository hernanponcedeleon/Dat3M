package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.*;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

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

    public BooleanFormula encode(SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        for(int i = 0; i < encodeIterations; i++){
            for(RecursiveRelation relation : relations){
                relation.setDoRecurse();
                enc = bmgr.and(enc, relation.encodeIteration(id, i, ctx));
            }
        }

        for(RecursiveRelation relation : relations){
            enc = bmgr.and(enc, relation.encodeFinalIteration(encodeIterations - 1, ctx));
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
