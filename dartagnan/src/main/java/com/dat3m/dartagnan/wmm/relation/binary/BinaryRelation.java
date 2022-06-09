package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    BinaryRelation(Relation r1, Relation r2) {
        this.r1 = r1;
        this.r2 = r2;
    }

    BinaryRelation(Relation r1, Relation r2, String name) {
        super(name);
        this.r1 = r1;
        this.r2 = r2;
    }

    public Relation getFirst() {
        return r1;
    }

    public Relation getSecond() {
        return r2;
    }

    @Override
    public List<Relation> getDependencies() {
        return Arrays.asList(r1 ,r2);
    }

    @Override
    public int updateRecursiveGroupId(int parentId){
        if(recursiveGroupId == 0 || forceUpdateRecursiveGroupId){
            forceUpdateRecursiveGroupId = false;
            int r1Id = r1.updateRecursiveGroupId(parentId | recursiveGroupId);
            int r2Id = r2.updateRecursiveGroupId(parentId | recursiveGroupId);
            recursiveGroupId |= (r1Id | r2Id) & parentId;
        }
        return recursiveGroupId;
    }

    @Override
    public void activate(Set<Tuple> tuples, WmmEncoder.Buffer buf) { // Not valid for composition
        buf.send(r1, tuples);
        buf.send(r2, tuples);
    }
}
