package com.dat3m.dartagnan.wmm.relation.binary;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.Sets;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RelMinus extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "\\" + r2.getName() + ")";
    }

    public RelMinus(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        if(r2.getRecursiveGroupId() > 0){
            throw new RuntimeException("Relation " + r2.getName() + " cannot be recursive since it occurs in a set minus.");
        }
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
			//FIXME the first min-iteration has not yet started, the result is not well-defined
            maxTupleSet = new TupleSet(Sets.difference(r1.getMaxTupleSet(), r2.getMinTupleSet()));
            r2.getMaxTupleSet();
        }
        return maxTupleSet;
    }

	@Override
	public void fetchMinTupleSet(){
		r1.fetchMinTupleSet();
		minTupleSet.addAll(Sets.difference(r1NewMinTupleSet(), r2.getMaxTupleSetRecursive()));
		disableTupleSet.addAll(Sets.intersection(r1NewDisableTupleSet(),maxTupleSet));
	}

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(Sets.difference(r1.getMaxTupleSetRecursive(), r2.getMinTupleSet()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

	@Override
	public boolean disable(TupleSet set) {
		super.disable(set);
		//NOTE if r2 detects disabled tuples, those are ignored for monotony purposes
		return r1.disable(new TupleSet(Sets.difference(set, r2.getMaxTupleSet())));
	}

	@Override
	public void initEncodeTupleSet() {
		encodeTupleSet.addAll(Sets.difference(disableTupleSet, r1.getDisableTupleSet()));
	}

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        TupleSet min = getMinTupleSet();
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }

            BooleanFormula opt1 = r1.getSMTVar(tuple, ctx);
            BooleanFormula opt2 = bmgr.not(r2.getSMTVar(tuple, ctx));
            if (Relation.PostFixApprox) {
                enc = bmgr.and(enc, bmgr.implication(bmgr.and(opt1, opt2), this.getSMTVar(tuple, ctx)));
            } else {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), bmgr.and(opt1, opt2)));
            }
        }
        return enc;
    }
}
