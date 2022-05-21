package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

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

	// This is an over-approximation of the real rcu-rscs since we don't do proper matching. 
    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread thread : task.getProgram().getThreads()){
                for(Event lock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                    for(Event unlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                        if(lock.getCId() < unlock.getCId()){
                            maxTupleSet.add(new Tuple(lock, unlock));
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    // TODO: Not the most efficient implementation
    // Let's see if we need to keep a reference to a thread in events for anything else, and then optimize this method
    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(Thread thread : task.getProgram().getThreads()){
            for(Event lock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                for(Event unlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                    if(lock.getCId() < unlock.getCId()){
                        Tuple tuple = new Tuple(lock, unlock);
                        if(encodeTupleSet.contains(tuple)){
                        	BooleanFormula relation = bmgr.and(getExecPair(lock, unlock, ctx));
                            for(Event otherLock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_LOCK))){
                                if(lock.getCId() < otherLock.getCId() && otherLock.getCId() < unlock.getCId()){
                                    relation = bmgr.and(relation, bmgr.not(this.getSMTVar(otherLock, unlock, ctx)));
                                }
                            }
                            for(Event otherUnlock : thread.getCache().getEvents(FilterBasic.get(Tag.Linux.RCU_UNLOCK))){
                                if(lock.getCId() < otherUnlock.getCId() && otherUnlock.getCId() < unlock.getCId()){
                                    relation = bmgr.and(relation, bmgr.not(this.getSMTVar(lock, otherUnlock, ctx)));
                                }
                            }
                            enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), relation));
                        }
                    }
                }
            }
        }
        return enc;
    }
}