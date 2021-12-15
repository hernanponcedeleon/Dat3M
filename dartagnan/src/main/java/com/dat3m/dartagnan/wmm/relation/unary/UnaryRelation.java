package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.Collections;
import java.util.List;

import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.SolverContext;

/**
 *
 * @author Florian Furbach
 */
public abstract class UnaryRelation extends Relation {

    protected Relation r1;
	private int r1MinTupleCount = 0;
	private int r1DisableTupleCount = 0;

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
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
		r1MinTupleCount = 0;
		r1DisableTupleCount = 0;
        if(recursiveGroupId > 0){
            throw new RuntimeException("Recursion is not implemented for " + this.getClass().getName());
        }
    }

	/**
	 * Checks whether there are new minimal tuples to process.
	 * Also marks the new tuples as processed.
	 * @return
	 * Collection containing at least those minimal tuples that were not yet processed.
	 */
	protected final TupleSet r1NewMinTupleSet() {
		//assume that min is monotone
		int c = r1.getMinTupleSet().size();
		assert r1MinTupleCount <= c;
		if(r1MinTupleCount == c) {
			return new TupleSet();
		}
		r1MinTupleCount = c;
		return r1.getMinTupleSet();
	}

	/**
	 * Checks whether there are new disabled tuples to process.
	 * Also marks the new tuples as processed.
	 * @return
	 * Collection containing at least those disabled tuples that were not yet processed.
	 */
	protected final TupleSet r1NewDisableTupleSet() {
		//assume that disable is monotone
		int c = r1.getDisableTupleSet().size();
		assert r1DisableTupleCount <= c;
		if(r1DisableTupleCount == c) {
			return new TupleSet();
		}
		r1DisableTupleCount = c;
		return r1.getDisableTupleSet();
	}
}