package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        return rel.getMaxTupleSet();
    }

	@Override
	public TupleSet getDisabledSet() {
		return new TupleSet(rel.getMaxTupleSet());
	}

    @Override
    public BooleanFormula consistent(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            enc = bmgr.and(enc, bmgr.not(rel.getSMTVar(tuple, ctx)));
        }
        return enc;
    }

    @Override
    public String toString() {
        return "empty " + rel.getName();
    }
}