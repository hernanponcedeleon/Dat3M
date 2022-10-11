package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;

import java.util.*;

public class RecursiveGroup {

    private final List<RecursiveRelation> relations;

    public RecursiveGroup(Collection<RecursiveRelation> relations){
        for(RecursiveRelation relation : relations){
            relation.setDoRecurse();
        }
        this.relations = new ArrayList<>(relations);
    }

    public void setDoRecurse(){
        for(RecursiveRelation relation : relations){
            relation.setDoRecurse();
        }
    }

    public void initMaxTupleSets(){
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
        }
    }

    public void initMinTupleSets(){
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
        }
    }
}
