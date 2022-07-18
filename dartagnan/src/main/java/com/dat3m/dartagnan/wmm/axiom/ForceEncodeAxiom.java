package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

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
    public TupleSet getEncodeTupleSet(){
        return rel.getMaxTupleSet();
    }

    @Override
    public BooleanFormula consistent(WmmEncoder encoder) {
        BooleanFormulaManager bmgr = encoder.solverContext().getFormulaManager().getBooleanFormulaManager();
		return negated ? bmgr.makeFalse() : bmgr.makeTrue();
    }

    @Override
    public String toString() {
        return "forceEncode " + (negated ? "~" : "") + rel.getName();
    }
}
