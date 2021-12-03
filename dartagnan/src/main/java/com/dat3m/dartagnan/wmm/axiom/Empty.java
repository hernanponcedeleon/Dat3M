package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

	@Override
	public TupleSet getEncodeTupleSet(){
		return new TupleSet();
	}

	@Override
	public TupleSet getDisabledSet() {
		return new TupleSet(rel.getMaxTupleSet());
	}

	@Override
	public BooleanFormula consistent(SolverContext ctx) {
		return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
	}

    @Override
    public String toString() {
        return "empty " + rel.getName();
    }
}