package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class NotEmpty extends Axiom {

    public NotEmpty(Relation rel) {
        super(rel);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        return rel.getMaxTupleSet();
    }

    // This axiom is encoded as a property rather than a filter over execution,
    // thus the we do not really filter anything (i.e. we trivially return true).
    @Override
    public BooleanFormula consistent(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

    @Override
    public BooleanFormula asProperty(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula axiomEncoding = bmgr.makeFalse();
        for(Tuple tuple : rel.getEncodeTupleSet()) {
            axiomEncoding = bmgr.or(axiomEncoding, rel.getSMTVar(tuple, ctx));
        }
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(extractionVariable(ctx), axiomEncoding);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(axiomEncoding) ? axiomEncoding : bmgr.and(extractionVariable(ctx), enc);
    };

    @Override
    public String toString() {
        return "~empty " + rel.getName();
    }
}