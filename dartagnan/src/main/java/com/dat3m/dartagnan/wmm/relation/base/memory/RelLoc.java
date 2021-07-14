package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collection;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.program.utils.EType.MEMORY;

public class RelLoc extends Relation {

    public RelLoc(){
        term = "loc";
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            for (Tuple t : getMaxTupleSet()) {
                MemEvent e1 = (MemEvent) t.getFirst();
                MemEvent e2 = (MemEvent) t.getSecond();
                if (e1.getMaxAddressSet().size() == 1 && e2.getMaxAddressSet().size() == 1) {
                    minTupleSet.add(t);
                }
            }
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            Collection<Event> events = task.getProgram().getCache().getEvents(FilterBasic.get(MEMORY));
            for(Event e1 : events){
                for(Event e2 : events){
                    //TODO: loc should be reflexive according to
                    // "Syntax and semantics of the weak consistency model specification language cat"
                    if(e1.getCId() != e2.getCId() && MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
    	
    	BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : encodeTupleSet) {
        	BooleanFormula rel = this.getSMTVar(tuple, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(
                    bmgr.and(tuple.getFirst().exec(), tuple.getSecond().exec()),
                    imgr.equal((IntegerFormula)((MemEvent)tuple.getFirst()).getMemAddressExpr(), (IntegerFormula)((MemEvent)tuple.getSecond()).getMemAddressExpr())
            )));
        }
        return enc;
    }
}
