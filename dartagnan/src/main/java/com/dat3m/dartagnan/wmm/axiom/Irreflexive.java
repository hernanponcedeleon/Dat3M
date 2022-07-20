package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

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
    public void activate(WmmEncoder.Buffer buf) {
        RelationAnalysis ra = buf.analysisContext().get(RelationAnalysis.class);
        TupleSet set = new TupleSet();
        ra.may(rel).stream().filter(Tuple::isLoop).forEach(set::add);
        buf.send(rel, set);
    }

    @Override
    public BooleanFormula consistent(WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : encoder.tupleSet(rel)){
            if(tuple.isLoop()){
                enc = bmgr.and(enc, bmgr.not(encoder.edge(rel, tuple)));
            }
        }
        return negated ? bmgr.not(enc) : enc;
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "irreflexive " + rel.getName();
    }
}