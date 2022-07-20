package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

/**
 *
 * @author Florian Furbach
 */
public class RelComposition extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + ";" + r2.getName() + ")";
    }

    public RelComposition(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelComposition(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        TupleSet may1 = a.may(r1);
        TupleSet must1 = a.must(r1);
        TupleSet may2 = a.may(r2);
        TupleSet must2 = a.must(r2);
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        a.listen(r1, (may, must) -> update(may, must, may2, must2, exec, a));
        a.listen(r2, (may, must) -> update(may1, must1, may, must, exec, a));
    }

    @Override
    public void activate(Set<Tuple> activeSet, WmmEncoder.Buffer buf) {
        TupleSet r1Set = new TupleSet();
        TupleSet r2Set = new TupleSet();

        RelationAnalysis ra = buf.analysisContext().get(RelationAnalysis.class);
        TupleSet r1Max = ra.may(r1);
        TupleSet r2Max = ra.may(r2);
        for (Tuple t : activeSet) {
            Event e1 = t.getFirst();
            Event e3 = t.getSecond();
            for (Tuple t1 : r1Max.getByFirst(e1)) {
                Event e2 = t1.getSecond();
                Tuple t2 = new Tuple(e2, e3);
                if (r2Max.contains(t2)) {
                    r1Set.add(t1);
                    r2Set.add(t2);
                }
            }
        }
        buf.send(r1, r1Set);
        buf.send(r2, r2Set);
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = encoder.analysisContext().get(ExecutionAnalysis.class);
        RelationAnalysis ra = encoder.analysisContext().get(RelationAnalysis.class);
        TupleSet r1Max = ra.may(r1);
        TupleSet r2Max = ra.may(r2);
        TupleSet minSet = ra.must(this);
        for(Tuple tuple : encodeTupleSet) {
            BooleanFormula expr = bmgr.makeFalse();
            if (minSet.contains(tuple)) {
                expr = execution(tuple.getFirst(), tuple.getSecond(), exec, ctx);
            } else {
                for (Tuple t1 : r1Max.getByFirst(tuple.getFirst())) {
                    Tuple t2 = new Tuple(t1.getSecond(), tuple.getSecond());
                    if (r2Max.contains(t2)) {
                        expr = bmgr.or(expr, bmgr.and(encoder.edge(r1, t1), encoder.edge(r2, t2)));
                    }
                }
            }

            enc = bmgr.and(enc, bmgr.equivalence(encoder.edge(this, tuple), expr));
        }
        return enc;
    }

    private void update(TupleSet may1, TupleSet must1, TupleSet may2, TupleSet must2, ExecutionAnalysis exec, RelationAnalysis.Buffer a) {
        TupleSet maxTupleSet = may1.postComposition(may2,
                (t1, t2) -> !exec.areMutuallyExclusive(t1.getFirst(), t2.getSecond()));
        TupleSet minTupleSet = must1.postComposition(must2,
                (t1, t2) -> (exec.isImplied(t1.getFirst(), t1.getSecond())
                        || exec.isImplied(t2.getSecond(), t1.getSecond()))
                        && !exec.areMutuallyExclusive(t1.getFirst(), t2.getSecond()));
        a.send(this, maxTupleSet, minTupleSet);
    }
}