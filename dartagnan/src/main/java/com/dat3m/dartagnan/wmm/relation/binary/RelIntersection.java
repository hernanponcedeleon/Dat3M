package com.dat3m.dartagnan.wmm.relation.binary;

import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RelIntersection extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "&" + r2.getName() + ")";
    }

    public RelIntersection(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelIntersection(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet(Sets.intersection(r1.getMaxTupleSet(), r2.getMaxTupleSet()));
        }
        return maxTupleSet;
    }

	@Override
	public void fetchMinTupleSet() {
		r1.fetchMinTupleSet();
		r2.fetchMinTupleSet();
		minTupleSet.addAll(Sets.union(
			Sets.intersection(r1NewMinTupleSet(),r2.getMinTupleSet()),
			Sets.intersection(r2NewMinTupleSet(),r1.getMinTupleSet())));
		disableTupleSet.addAll(Sets.union(r1NewDisableTupleSet(),r2NewDisableTupleSet()));
	}

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(Sets.intersection(r1.getMaxTupleSetRecursive(), r2.getMaxTupleSetRecursive()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

	@Override
	public boolean disable(TupleSet t) {
		super.disable(t);
		if(t.isEmpty()) {
			return false;
		}
		return continueDisableTupleSet();
	}

	@Override
	public boolean continueDisableTupleSet() {
		//TODO manage disabled tuples with support
		return continueDisableTupleSet(disableTupleSet);
	}

	private boolean continueDisableTupleSet(TupleSet t) {
		TupleSet t1 = new TupleSet();
		t1.addAll(t);
		t1.retainAll(r2.getMinTupleSet());
		boolean b = r1.disable(t1);
		TupleSet t2 = new TupleSet();
		t2.addAll(t);
		t2.retainAll(r1.getMinTupleSet());
		return r2.disable(t2) || b;
	}

	@Override
	public void initEncodeTupleSet() {
		TupleSet set = new TupleSet();
		set.addAll(Sets.difference(disableTupleSet,Sets.union(r1.getDisableTupleSet(),r2.getDisableTupleSet())));
		if(!set.isEmpty()) {
			addEncodeTupleSet(set);
		}
	}

    @Override
    public BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        TupleSet min = getMinTupleSet();
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }
            BooleanFormula opt1 = r1.getSMTVar(tuple, ctx);
            BooleanFormula opt2 = r2.getSMTVar(tuple, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), bmgr.and(opt1, opt2)));
        }
        return enc;
    }
}