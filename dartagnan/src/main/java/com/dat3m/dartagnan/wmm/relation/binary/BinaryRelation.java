package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.Sets;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

import org.sosy_lab.java_smt.api.SolverContext;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    int lastEncodedIteration = -1;

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
	public void collect(Set<?super Relation> result) {
		if(result.add(this)) {
			r1.collect(result);
			r2.collect(result);
		}
	}

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        lastEncodedIteration = -1;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){ // Not valid for composition
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);
        activeSet.removeAll(getMinTupleSet());

        if(!activeSet.isEmpty()){
            r1.addEncodeTupleSet(activeSet);
            r2.addEncodeTupleSet(activeSet);
        }
    }
}
