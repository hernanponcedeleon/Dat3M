package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.Set;

/*
    This is a fake axiom that forces a relation to get encoded!
 */
public class ForceEncodeAxiom extends Axiom {
    public ForceEncodeAxiom(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public ForceEncodeAxiom(Relation rel) {
        super(rel, false, false);
    }

    @Override
    protected Set<Tuple> getEncodeTupleSet(Context analysisContext) {
        return analysisContext.requires(RelationAnalysis.class).getKnowledge(rel).getMaySet();
    }

    @Override
    public BooleanFormula consistent(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		return negated ? bmgr.makeFalse() : bmgr.makeTrue();
    }

    @Override
    public String toString() {
        return "forceEncode " + (negated ? "~" : "") + rel.getNameOrTerm();
    }
}
