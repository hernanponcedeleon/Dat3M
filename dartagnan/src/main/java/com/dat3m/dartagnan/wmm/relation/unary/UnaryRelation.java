package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.wmm.relation.Relation;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collections;
import java.util.List;

/**
 *
 * @author Florian Furbach
 */
public abstract class UnaryRelation extends Relation {

    protected Relation r1;

    UnaryRelation(Relation r1) {
        this.r1 = r1;
    }

    UnaryRelation(Relation r1, String name) {
        super(name);
        this.r1 = r1;
    }

    public Relation getInner() {
        return r1;
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.singletonList(r1);
    }

    @Override
    public int updateRecursiveGroupId(int parentId){
        if(recursiveGroupId == 0 || forceUpdateRecursiveGroupId){
            forceUpdateRecursiveGroupId = false;
            int r1Id = r1.updateRecursiveGroupId(parentId | recursiveGroupId);
            recursiveGroupId |= r1Id & parentId;
        }
        return recursiveGroupId;
    }

    @Override
    public void initializeEncoding(SolverContext ctx){
        super.initializeEncoding(ctx);
        if(recursiveGroupId > 0){
            throw new UnsupportedOperationException("Recursion is not implemented for " + this.getClass().getName());
        }
    }
}