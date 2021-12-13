package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

	@Override
	public TupleSet getEncodeTupleSet(){
		//NOTE if applyDisableSet was invoked, this axiom is embedded into rel and its descendants
		return new TupleSet(Sets.difference(rel.getMaxTupleSet(), rel.getDisableTupleSet()));
	}

	@Override
	public boolean applyDisableSet() {
		//NOTE modifiable copy for disable(TupleSet)
		return rel.disable(new TupleSet(rel.getMaxTupleSet()));
	}

	@Override
	public BooleanFormula consistent(SolverContext ctx) {
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
		//NOTE if applyDisableSet was invoked, the difference is empty
		for(Tuple t : Sets.difference(rel.getEncodeTupleSet(),rel.getDisableTupleSet())) {
			enc = bmgr.and(enc, bmgr.not(rel.getSMTVar(t, ctx)));
		}
		return enc;
	}

    @Override
    public String toString() {
        return "empty " + rel.getName();
    }
}