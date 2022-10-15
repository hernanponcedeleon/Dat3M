package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.Set;

public class Empty extends Axiom {

    public Empty(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Empty(Relation rel) {
        super(rel, false, false);
    }

    @Override
    protected Set<Tuple> getEncodeTupleSet(Context analysisContext) {
        final RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        return ra.getKnowledge(rel).getMaySet();
    }

    @Override
    public BooleanFormula consistent(EncodingContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        final RelationAnalysis ra = ctx.getAnalysisContext().get(RelationAnalysis.class);
        final EncodingContext.EdgeEncoder edge = ctx.edge(rel);
        for (Tuple tuple : ra.getKnowledge(rel).getMaySet()) {
            enc = bmgr.and(enc, bmgr.not(edge.encode(tuple)));
        }
        return negated ? bmgr.not(enc) : enc;
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "empty " + rel.getNameOrTerm();
    }
}