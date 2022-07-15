package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

//TODO(TH): RelCrit, RelRMW and RelFencerel are NOT strongly static like the other static relations
// It might be reasonable to group them into weakly static relations (or alternatively the other one's into
// strongly static)
// Explanation of these ideas:
// A relation is static IFF its edges are completely determined by the set of executed events
// (irrespective of rf, co, po and any values/addresses of the events)
// We call it "strongly static", if an edge (e1, e2) exists IFF both e1 and e2 are executed
// We call it "weakly static", if the existence of edge (e1, e2) depends on other possibly other events
// E.g. RelFenceRel is weakly static since (e1, e2) exists IFF there exists a fence e3 between e1 and e2.
// (It is a composition of the strongly static relations (po & _ x F) and po)
public abstract class StaticRelation extends Relation {

    public StaticRelation() {
        super();
    }

    public StaticRelation(String name) {
        super(name);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = getMaxTupleSet();
        }
        return minTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        for(Tuple tuple : encodeTupleSet) {
        	BooleanFormula rel = this.getSMTVar(tuple, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(execution(tuple.getFirst(), tuple.getSecond(), exec, ctx))));
        }
        return enc;
    }
}
