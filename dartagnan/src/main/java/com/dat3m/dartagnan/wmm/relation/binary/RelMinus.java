package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

/**
 *
 * @author Florian Furbach
 */
public class RelMinus extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "\\" + r2.getName() + ")";
    }

    public RelMinus(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        TupleSet may2 = a.may(r2);
        TupleSet must2 = a.must(r2);
        a.listen(r1, (may1, must1) -> a.send(this, Sets.difference(may1, must2), Sets.difference(must1, may2)));
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = encoder.analysisContext().requires(ExecutionAnalysis.class);
        RelationAnalysis ra = encoder.analysisContext().requires(RelationAnalysis.class);
        TupleSet min = ra.must(this);
        for(Tuple tuple : encodeTupleSet){
            BooleanFormula edge = encoder.edge(this, tuple);
            if (min.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple.getFirst(), tuple.getSecond(), exec, ctx)));
                continue;
            }

            BooleanFormula opt1 = encoder.edge(r1, tuple);
            BooleanFormula opt2 = bmgr.not(encoder.edge(r2, tuple));
            if (Relation.PostFixApprox) {
                enc = bmgr.and(enc, bmgr.implication(bmgr.and(opt1, opt2), edge));
            } else {
                enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.and(opt1, opt2)));
            }
        }
        return enc;
    }
}
