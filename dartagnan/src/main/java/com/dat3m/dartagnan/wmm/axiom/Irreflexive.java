package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.Set;

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
        TupleSet set = new TupleSet();
        rel.getMaxTupleSet().stream().filter(Tuple::isLoop).forEach(set::add);
        return set;
    }

    @Override
    public BooleanFormula consistent(EncodingContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        final EncodingContext.EdgeEncoder edge = ctx.edge(rel);
        for (Tuple tuple : rel.getMaxTupleSet()) {
            if(tuple.isLoop()){
                enc = bmgr.and(enc, bmgr.not(edge.encode(tuple)));
            }
        }
        return negated ? bmgr.not(enc) : enc;
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "irreflexive " + rel.getName();
    }
}