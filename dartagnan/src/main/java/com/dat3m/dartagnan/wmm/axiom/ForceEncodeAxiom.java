package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

/*
    This is a fake axiom that forces a relation to get encoded!
 */
public class ForceEncodeAxiom extends Axiom {
    public ForceEncodeAxiom(Relation rel) {
        super(rel);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        return rel.getMaxTupleSet();
    }

    @Override
    public BooleanFormula consistent(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

    @Override
    public String toString() {
        return "forceEncode " + rel.getName();
    }
}
