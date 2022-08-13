package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_LOCK;
import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_UNLOCK;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CRIT;

public class RelCrit extends StaticRelation {

    public RelCrit(){
        term = CRIT;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            getMaxTupleSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet != null) {
            return maxTupleSet;
        }
        maxTupleSet = new TupleSet();
        minTupleSet = new TupleSet();
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        for (Thread thread : task.getProgram().getThreads()) {
            // assume order by cId
            // assume cId describes a topological sorting over the control flow
            List<Event> locks = Lists.reverse(thread.getCache().getEvents(FilterBasic.get(RCU_LOCK)));
            for (Event unlock : thread.getCache().getEvents(FilterBasic.get(RCU_UNLOCK))) {
                // iteration order assures that all intermediaries were already iterated
                for (Event lock : locks) {
                    if (unlock.getCId() < lock.getCId() ||
                            exec.areMutuallyExclusive(lock, unlock) ||
                            minTupleSet.getByFirst(lock).stream().anyMatch(t -> exec.isImplied(lock, t.getSecond()))) {
                        continue;
                    }
                    boolean noIntermediary = maxTupleSet.getBySecond(unlock).isEmpty() &&
                            maxTupleSet.getByFirst(lock).isEmpty();
                    Tuple tuple = new Tuple(lock, unlock);
                    maxTupleSet.add(tuple);
                    if (noIntermediary) {
                        minTupleSet.add(tuple);
                        if (exec.isImplied(unlock, lock)) {
                            break;
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : maxTupleSet) {
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            BooleanFormula relation = getExecPair(tuple, ctx);
            for(Tuple t : maxTupleSet.getBySecond(unlock)) {
                Event otherLock = t.getFirst();
                if(lock.getCId() < otherLock.getCId() && otherLock.getCId() < unlock.getCId()) {
                    relation = bmgr.and(relation, bmgr.not(getSMTVar(t, ctx)));
                }
            }
            for(Tuple t : maxTupleSet.getByFirst(lock)) {
                Event otherUnlock = t.getSecond();
                if(lock.getCId() < otherUnlock.getCId() && otherUnlock.getCId() < unlock.getCId()) {
                    relation = bmgr.and(relation, bmgr.not(getSMTVar(t, ctx)));
                }
            }
            enc = bmgr.and(enc, bmgr.equivalence(getSMTVar(tuple, ctx), relation));
        }
        return enc;
    }
}