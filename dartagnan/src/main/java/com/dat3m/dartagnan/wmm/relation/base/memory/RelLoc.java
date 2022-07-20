package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.expression.utils.Utils;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;
import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.LOC;

public class RelLoc extends Relation {

    public RelLoc(){
        term = LOC;
    }

    @Override
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        AliasAnalysis alias = a.analysisContext().get(AliasAnalysis.class);
        TupleSet maxTupleSet = new TupleSet();
        TupleSet minTupleSet = new TupleSet();
        Collection<Event> events = a.task().getProgram().getCache().getEvents(FilterBasic.get(MEMORY));
        for(Event e1 : events){
            for(Event e2 : events){
                if(alias.mayAlias((MemEvent)e1, (MemEvent)e2) && !exec.areMutuallyExclusive(e1, e2)) {
                    Tuple t = new Tuple(e1, e2);
                    maxTupleSet.add(t);
                    if(alias.mustAlias((MemEvent)e1, (MemEvent)e2)) {
                        minTupleSet.add(t);
                    }
                }
            }
        }
        a.send(this, maxTupleSet, minTupleSet);
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

    	BooleanFormula enc = bmgr.makeTrue();
        ExecutionAnalysis exec = encoder.analysisContext().requires(ExecutionAnalysis.class);
        for(Tuple tuple : encodeTupleSet) {
        	BooleanFormula rel = encoder.edge(this, tuple);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(
                execution(tuple.getFirst(), tuple.getSecond(), exec, ctx),
                    Utils.generalEqual(
                            ((MemEvent)tuple.getFirst()).getMemAddressExpr(),
                            ((MemEvent)tuple.getSecond()).getMemAddressExpr(), ctx)
            )));
        }
        return enc;
    }
}
