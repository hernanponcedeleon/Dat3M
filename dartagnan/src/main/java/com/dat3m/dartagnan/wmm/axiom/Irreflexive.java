package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.Set;

import static java.util.stream.Collectors.toSet;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom {

    public Irreflexive(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Irreflexive(Relation rel) {
        super(rel, false, false);
    }

    @Override
    protected Set<Tuple> getEncodeTupleSet(Context analysisContext) {
        final RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        return ra.getKnowledge(rel).getMaySet().stream().filter(Tuple::isLoop).collect(toSet());
    }

    @Override
    public BooleanFormula consistent(EncodingContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        final EncodingContext.EdgeEncoder edge = ctx.edge(rel);
        for (Tuple tuple : getEncodeTupleSet(ctx.getAnalysisContext())) {
            enc = bmgr.and(enc, bmgr.not(edge.encode(tuple)));
        }
        return negated ? bmgr.not(enc) : enc;
    }

    @Override
    public Irreflexive substitute(Relation p, Relation r) {
        return rel.equals(p) ? new Irreflexive(r) : this;
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "irreflexive " + rel.getNameOrTerm();
    }
}