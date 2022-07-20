package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    Map<Event, Set<Event>> transitiveReachabilityMap;

    public static String makeTerm(Relation r1){
        return r1.getName() + "^+";
    }

    public RelTrans(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTrans(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        TupleSet maySet = a.may(this);
        TupleSet mustSet = a.must(this);
        a.listen(this, (may, must) -> {
            TupleSet maxTupleSet = may.postComposition(maySet,
                (t1, t2) -> !exec.areMutuallyExclusive(t1.getFirst(), t2.getSecond()));
            TupleSet minTupleSet = must.postComposition(mustSet,
                (t1, t2) -> (exec.isImplied(t1.getFirst(), t1.getSecond())
                        || exec.isImplied(t2.getSecond(), t1.getSecond()))
                    && !exec.areMutuallyExclusive(t1.getFirst(), t2.getSecond()));
            a.send(this,maxTupleSet,minTupleSet);
        });
        a.listen(r1, (may, must) -> a.send(this, may, must));
    }

    @Override
    public void activate(Set<Tuple> news, WmmEncoder.Buffer buf) {
        HashSet<Tuple> factors = new HashSet<>();
        RelationAnalysis ra = buf.analysisContext().get(RelationAnalysis.class);
        TupleSet maxTupleSet = ra.may(this);
        for(Tuple t : news) {
            for(Tuple t1 : maxTupleSet.getByFirst(t.getFirst())) {
                Tuple t2 = new Tuple(t1.getSecond(), t.getSecond());
                if(maxTupleSet.contains(t2)) {
                    factors.add(t1);
                    factors.add(t2);
                }
            }
        }
        buf.send(this, factors);
        buf.send(r1, Sets.intersection(news, ra.may(r1)));
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = encoder.analysisContext().get(ExecutionAnalysis.class);
        RelationAnalysis ra = encoder.analysisContext().get(RelationAnalysis.class);
        TupleSet may = ra.may(this);
        TupleSet minSet = ra.must(this);
        TupleSet r1Max = ra.may(r1);
        for(Tuple tuple : encodeTupleSet){
            BooleanFormula edge = encoder.edge(this, tuple);
            if (minSet.contains(tuple)) {
                if(Relation.PostFixApprox) {
                    enc = bmgr.and(enc, bmgr.implication(execution(tuple.getFirst(), tuple.getSecond(), exec, ctx), edge));
                } else {
                    enc = bmgr.and(enc, bmgr.equivalence(edge, execution(tuple.getFirst(), tuple.getSecond(), exec, ctx)));
                }
                continue;
            }

            BooleanFormula orClause = bmgr.makeFalse();
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            if(r1Max.contains(tuple)){
                orClause = bmgr.or(orClause, encoder.edge(r1, tuple));
            }


            for(Tuple t : r1Max.getByFirst(e1)){
                Event e3 = t.getSecond();
                if(e3.getCId() != e1.getCId() && e3.getCId() != e2.getCId() && may.contains(new Tuple(e3, e2))){
                    BooleanFormula tVar = encoder.edge(minSet.contains(t) ? this : r1, t);
                    orClause = bmgr.or(orClause, bmgr.and(tVar, encoder.edge(this, e3, e2)));
                }
            }

            if(Relation.PostFixApprox) {
                enc = bmgr.and(enc, bmgr.implication(orClause, edge));
            } else {
                enc = bmgr.and(enc, bmgr.equivalence(edge, orClause));
            }
        }

        return enc;
    }
}