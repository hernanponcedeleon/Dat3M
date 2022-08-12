package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_LOCK;
import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_UNLOCK;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CRIT;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.iterate;

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
            List<Event> events = thread.getCache().getEvents(FilterUnion.get(FilterBasic.get(RCU_LOCK), FilterBasic.get(RCU_UNLOCK)));
            // assume order by cId
            // assume cId describes a topological sorting over the control flow
            for (int end = 1; end < events.size(); end++) {
                Event second = events.get(end);
                if (!second.is(RCU_UNLOCK)) {
                    continue;
                }
                int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                        .filter(i -> exec.isImplied(second, events.get(i)))
                        .findFirst().orElse(0);
                List<Event> candidates = events.subList(start, end).stream()
                        .filter(e -> !exec.areMutuallyExclusive(e, second))
                        .collect(toList());
                int size = candidates.size();
                for (int i = 0; i < size; i++) {
                    Event first = candidates.get(i);
                    List<Event> intermediaries = candidates.subList(i + 1, size);
                    if (!first.is(RCU_LOCK) ||
                            intermediaries.stream().anyMatch(e -> exec.isImplied(first, e))) {
                        continue;
                    }
                    Tuple tuple = new Tuple(first, second);
                    maxTupleSet.add(tuple);
                    if (intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(first, e))) {
                        minTupleSet.add(tuple);
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