package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;
	private int r1MinTupleCount;
	private int r2MinTupleCount;
	private int r1DisableTupleCount;
	private int r2DisableTupleCount;

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
	public void initialise(VerificationTask task, SolverContext ctx) {
		super.initialise(task, ctx);
		r1MinTupleCount = 0;
		r2MinTupleCount = 0;
		r1DisableTupleCount = 0;
		r2DisableTupleCount = 0;
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
    public void addEncodeTupleSet(TupleSet tuples){ // Not valid for composition
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);
        activeSet.removeAll(getMinTupleSet());

        if(!activeSet.isEmpty()){
            r1.addEncodeTupleSet(activeSet);
            r2.addEncodeTupleSet(activeSet);
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

	/**
	 * Checks whether there are new minimal tuples to process.
	 * Also marks the new tuples as processed.
	 * @return
	 * Collection containing at least those minimal tuples that were not yet processed.
	 */
	protected final TupleSet r2NewMinTupleSet() {
		//assume that min is monotone
		int c = r2.getMinTupleSet().size();
		assert r2MinTupleCount <= c;
		if(r2MinTupleCount == c) {
			return new TupleSet();
		}
		r2MinTupleCount = c;
		return r2.getMinTupleSet();
	}

	/**
	 * Checks whether there are new disabled tuples to process.
	 * Also marks the new tuples as processed.
	 * @return
	 * Collection containing at least those disabled tuples that were not yet processed.
	 */
	protected final TupleSet r2NewDisableTupleSet() {
		//assume that disable is monotone
		int c = r2.getDisableTupleSet().size();
		assert r2DisableTupleCount <= c;
		if(r2DisableTupleCount == c) {
			return new TupleSet();
		}
		r2DisableTupleCount = c;
		return r2.getDisableTupleSet();
	}
}
