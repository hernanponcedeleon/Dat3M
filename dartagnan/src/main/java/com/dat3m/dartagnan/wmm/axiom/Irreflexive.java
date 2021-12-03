package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
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
		return new TupleSet();
	}

	@Override
	public TupleSet getDisabledSet() {
		TupleSet set = new TupleSet();
		rel.getMinTupleSet().stream().filter(Tuple::isLoop).forEach(set::add);
		return set;
	}

	@Override
	public BooleanFormula consistent(SolverContext ctx) {
		return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
	}

    @Override
    public String toString() {
        return "irreflexive " + rel.getName();
    }
}