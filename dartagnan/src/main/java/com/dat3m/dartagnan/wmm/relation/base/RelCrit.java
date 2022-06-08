package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CRIT;

public class RelCrit extends StaticRelation {
    //TODO: We can optimize this a lot by using branching analysis

    public RelCrit(){
        term = CRIT;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            // Todo
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            for(Thread thread : task.getProgram().getThreads()){
                for(Event lock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                    for(Event unlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                        if(lock.getCId() < unlock.getCId() && !exec.areMutuallyExclusive(lock, unlock)) {
                            maxTupleSet.add(new Tuple(lock, unlock));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }

    // TODO: Not the most efficient implementation
    // Let's see if we need to keep a reference to a thread in events for anything else, and then optimize this method
    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        ExecutionAnalysis exec = encoder.analysisContext().requires(ExecutionAnalysis.class);
        for(Thread thread : encoder.task().getProgram().getThreads()){
            for(Event lock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                for(Event unlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                    if(lock.getCId() < unlock.getCId()){
                        Tuple tuple = new Tuple(lock, unlock);
                        if(encodeTupleSet.contains(tuple)){
                            BooleanFormula relation = bmgr.and(execution(lock, unlock, exec, ctx));
                            for(Event otherLock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                                if(lock.getCId() < otherLock.getCId() && otherLock.getCId() < unlock.getCId()){
                                    relation = bmgr.and(relation, bmgr.not(encoder.edge(this, otherLock, unlock)));
                                }
                            }
                            for(Event otherUnlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                                if(lock.getCId() < otherUnlock.getCId() && otherUnlock.getCId() < unlock.getCId()){
                                    relation = bmgr.and(relation, bmgr.not(encoder.edge(this, lock, otherUnlock)));
                                }
                            }
                            enc = bmgr.and(enc, bmgr.equivalence(encoder.edge(this, tuple), relation));
                        }
                    }
                }
            }
        }
        return enc;
    }
}