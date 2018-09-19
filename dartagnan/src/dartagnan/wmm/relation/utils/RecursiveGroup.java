package dartagnan.wmm.relation.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.wmm.relation.RecursiveRelation;
import dartagnan.wmm.relation.Relation;

import java.util.*;

public class RecursiveGroup {

    private final int id;
    private List<RecursiveRelation> relations;
    private int encodeIterations = 0;

    public RecursiveGroup(int id, Collection<RecursiveRelation> relations){
        for(Relation relation : relations){
            relation.setRecursiveGroupId(id);
        }
        this.relations = new ArrayList<>(relations);
        this.id = id;
    }

    public int getId(){
        return id;
    }

    public BoolExpr encode(Context ctx){
        BoolExpr enc = ctx.mkTrue();
        for(int i = 0; i < encodeIterations; i++){
            for(Relation relation : relations){
                enc = ctx.mkAnd(enc, relation.encodeIteration(id, ctx, i));
            }
        }

        for(Relation relation : relations){
            enc = ctx.mkAnd(enc, relation.encodeFinalIteration(id, ctx, encodeIterations - 1));
        }

        //System.out.println(enc);

        return enc;
    }

    public void initMaxTupleSets(){
        boolean changed = true;
        int i = 0;
        while(changed){
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setIsActive();
                int oldSize = relation.getMaxTupleSet().size();
                if(oldSize != relation.getMaxTupleSetRecursive().size()){
                    changed = true;
                }
            }
            i++;
        }
    }

    public void updateEncodeTupleSets(){
        Map<Relation, Integer> encodeSetSizes = new HashMap<>();
        for(Relation relation : relations){
            encodeSetSizes.put(relation, 0);
        }

        boolean changed = true;
        while(changed){
            encodeIterations++;
            changed = false;
            for(RecursiveRelation relation : relations){
                relation.setIsActive();
                relation.addEncodeTupleSet(relation.getEncodeTupleSet());
                //relation.updateEncodeTupleSet();
                int newSize = relation.getEncodeTupleSet().size();
                if(newSize != encodeSetSizes.get(relation)){
                    encodeSetSizes.put(relation, newSize);
                    changed = true;
                }
            }
        }

        // TODO: Precise number
        encodeIterations += 3;
    }
}
