package dartagnan.wmm.relation.utils;

import dartagnan.wmm.relation.RecursiveRelation;
import dartagnan.wmm.relation.Relation;

import java.util.*;

public class RecursiveGroup {

    private List<RecursiveRelation> relations;

    public RecursiveGroup(Collection<RecursiveRelation> relations){
        this.relations = new ArrayList<>(relations);
    }

    public void initMaxTupleSets(){
        boolean changed = true;
        while(changed){
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setIsActive();
                int oldSize = relation.getMaxTupleSet().size();
                if(oldSize != relation.getMaxTupleSetRecursive().size()){
                    changed = true;
                }
            }
        }
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
                relation.updateEncodeTupleSet();
                int newSize = relation.getEncodeTupleSet().size();
                if(newSize != encodeSetSizes.get(relation)){
                    encodeSetSizes.put(relation, newSize);
                    changed = true;
                }
            }
        }
    }

}
