package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

/**
 *
 * @author Florian Furbach
 */
public class RelIntersection extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "&" + r2.getName() + ")";
    }

    public RelIntersection(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelIntersection(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        Set<Tuple> may1 = a.may(r1);
        Set<Tuple> may2 = a.may(r2);
        Set<Tuple> must1 = a.must(r1);
        Set<Tuple> must2 = a.must(r2);
        a.listen(r1, (may, must) -> a.send(this, Sets.intersection(may, may2), Sets.intersection(must, must2)));
        a.listen(r2, (may, must) -> a.send(this, Sets.intersection(may, may1), Sets.intersection(must, must1)));
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = encoder.analysisContext().get(ExecutionAnalysis.class);
        RelationAnalysis ra = encoder.analysisContext().get(RelationAnalysis.class);
        TupleSet min = ra.must(this);
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(encoder.edge(this, tuple), execution(tuple.getFirst(), tuple.getSecond(), exec, ctx)));
                continue;
            }
            BooleanFormula opt1 = encoder.edge(r1, tuple);
            BooleanFormula opt2 = encoder.edge(r2, tuple);
            enc = bmgr.and(enc, bmgr.equivalence(encoder.edge(this, tuple), bmgr.and(opt1, opt2)));
        }
        return enc;
    }
}