package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.List;

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
    protected EventGraph getEncodeGraph(Context analysisContext) {
        return analysisContext.requires(RelationAnalysis.class).getKnowledge(rel).getMaySet();
    }

    @Override
    public List<BooleanFormula> consistent(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        return negated ? List.of(bmgr.makeFalse()) : List.of();
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitForceEncodeAxiom(this);
    }

    @Override
    public String toString() {
        return "forceEncode " + (negated ? "~" : "") + rel.getNameOrTerm();
    }
}
