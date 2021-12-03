package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.Collections;
import java.util.List;
import java.util.Set;

import org.sosy_lab.java_smt.api.SolverContext;

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
	public void collect(Set<?super Relation> result) {
		if(result.add(this)) {
			r1.collect(result);
		}
	}

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        if(recursiveGroupId > 0){
            throw new RuntimeException("Recursion is not implemented for " + this.getClass().getName());
        }
    }
}