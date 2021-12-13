package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom {

    public Irreflexive(Relation rel) {
        super(rel);
    }

	@Override
	public TupleSet getEncodeTupleSet(){
		//NOTE if applyDisableSet was called, this axiom is embedded into rel and its descendants
		return new TupleSet(Sets.difference(Sets.filter(rel.getMaxTupleSet(), Tuple::isLoop), rel.getDisableTupleSet()));
	}

	@Override
	public boolean applyDisableSet() {
		TupleSet set = new TupleSet();
		rel.getMaxTupleSet().stream().filter(Tuple::isLoop).forEach(set::add);
		return rel.disable(set);
	}

	@Override
	public BooleanFormula consistent(SolverContext ctx) {
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
		//NOTE if applyDisableSet was called, the reflexive difference is empty
		for(Tuple t : Sets.difference(rel.getEncodeTupleSet(), rel.getDisableTupleSet())) {
			//NOTE t might be encoded by another axiom
			if(t.isLoop()) {
				enc = bmgr.and(enc, bmgr.not(rel.getSMTVar(t, ctx)));
			}
		}
		return enc;
	}

    @Override
    public String toString() {
        return "irreflexive " + rel.getName();
    }
}