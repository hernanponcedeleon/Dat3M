package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

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
			for(RecursiveRelation r : relations) {
				r.getInner().fetchMinTupleSet();
			}
			for(RecursiveRelation r : relations) {
				changed |= r.getMinTupleSet().addAll(r.getInner().getMinTupleSet());
			}
        }
    }

	/**
	 * Continues disabling tuples until convergence for this group.
	 * @return
	 * Minimal tuples were detected.
	 */
	public boolean initDisableTupleSets() {
		boolean news = false;
		boolean changed = true;
		while(changed) {
			changed = false;
			for(RecursiveRelation r : relations) {
				r.setDoRecurse();
				changed = r.hasDisableTuples() || changed;
				news = r.disableRecursive() || news;
			}
		}
		return news;
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
