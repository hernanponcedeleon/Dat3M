package com.dat3m.dartagnan.wmm.relation.unary;

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

import static java.util.stream.Collectors.toSet;

public class RelRangeIdentity extends UnaryRelation {

    public static String makeTerm(Relation r1){
        return "[range(" + r1.getName() + ")]";
    }

    public RelRangeIdentity(Relation r1){
        super(r1);
        term = makeTerm(r1);
    }

    public RelRangeIdentity(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        a.listen(r1, (may, must) -> a.send(this,
            may.stream().map(Tuple::getSecond).map(e -> new Tuple(e,e)).collect(toSet()),
            must.stream().filter(t -> exec.isImplied(t.getSecond(),t.getFirst())).map(Tuple::getSecond).map(e -> new Tuple(e,e)).collect(toSet())));
    }

    @Override
    public void activate(Set<Tuple> activeSet, WmmEncoder.Buffer buf) {
        //TODO: Optimize using minSets (but no CAT uses this anyway)
        TupleSet r1Set = new TupleSet();
        RelationAnalysis ra = buf.analysisContext().get(RelationAnalysis.class);
        TupleSet may1 = ra.may(r1);
        for(Tuple tuple : activeSet) {
            r1Set.addAll(may1.getBySecond(tuple.getFirst()));
        }
        buf.send(r1, r1Set);
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        RelationAnalysis ra = encoder.analysisContext().get(RelationAnalysis.class);
        TupleSet may1 = ra.may(r1);
        //TODO: Optimize using minSets (but no CAT uses this anyway)
        for(Tuple tuple1 : encodeTupleSet){
            Event e = tuple1.getFirst();
            BooleanFormula opt = bmgr.makeFalse();
            for(Tuple tuple2 : may1.getBySecond(e)){
                opt = bmgr.or(encoder.edge(r1, tuple2));
            }
            enc = bmgr.and(enc, bmgr.equivalence(encoder.edge(this, e, e), opt));
        }
        return enc;
    }
}