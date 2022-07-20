package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;

import java.util.*;

public class RecursiveGroup {

    private final int id;
    private final List<RecursiveRelation> relations;

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

    public List<RecursiveRelation> getRelations() {
        return relations;
    }
}
