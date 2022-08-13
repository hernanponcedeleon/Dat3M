package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_LOCK;
import static com.dat3m.dartagnan.program.event.Tag.Linux.RCU_UNLOCK;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CRIT;
import static com.google.common.collect.Lists.reverse;
import static com.google.common.collect.Sets.intersection;
import static java.util.stream.Stream.concat;

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
            List<Event> locks = reverse(thread.getCache().getEvents(FilterBasic.get(RCU_LOCK)));
            for (Event unlock : thread.getCache().getEvents(FilterBasic.get(RCU_UNLOCK))) {
                // iteration order assures that all intermediaries were already iterated
                for (Event lock : locks) {
                    if (unlock.getCId() < lock.getCId() ||
                            exec.areMutuallyExclusive(lock, unlock) ||
                            concat(minTupleSet.getByFirst(lock).stream().map(Tuple::getSecond),
                                            minTupleSet.getBySecond(unlock).stream().map(Tuple::getFirst))
                                    .anyMatch(e -> exec.isImplied(lock, e) || exec.isImplied(unlock, e))) {
                        continue;
                    }
                    boolean noIntermediary = maxTupleSet.getBySecond(unlock).stream()
                                    .allMatch(t -> exec.areMutuallyExclusive(lock, t.getFirst())) &&
                            maxTupleSet.getByFirst(lock).stream()
                                    .allMatch(t -> exec.areMutuallyExclusive(t.getSecond(), unlock));
                    Tuple tuple = new Tuple(lock, unlock);
                    maxTupleSet.add(tuple);
                    if (noIntermediary) {
                        minTupleSet.add(tuple);
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples) {
        LinkedList<Tuple> queue = new LinkedList<>(intersection(tuples, maxTupleSet));
        while (!queue.isEmpty()) {
            Tuple tuple = queue.remove();
            if (!encodeTupleSet.add(tuple)) {
                continue;
            }
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            for (Tuple t : maxTupleSet.getBySecond(unlock)) {
                if (isOrdered(lock, t.getFirst(), unlock)) {
                    queue.add(t);
                }
            }
            for (Tuple t : maxTupleSet.getByFirst(lock)) {
                if (isOrdered(lock, t.getSecond(), unlock)) {
                    queue.add(t);
                }
            }
        }
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for (Tuple tuple : encodeTupleSet) {
            Event lock = tuple.getFirst();
            Event unlock = tuple.getSecond();
            BooleanFormula relation = getExecPair(tuple, ctx);
            for (Tuple t : maxTupleSet.getBySecond(unlock)) {
                if (isOrdered(lock, t.getFirst(), unlock)) {
                    relation = bmgr.and(relation, bmgr.not(getSMTVar(t, ctx)));
                }
            }
            for (Tuple t : maxTupleSet.getByFirst(lock)) {
                if (isOrdered(lock, t.getSecond(), unlock)) {
                    relation = bmgr.and(relation, bmgr.not(getSMTVar(t, ctx)));
                }
            }
            enc = bmgr.and(enc, bmgr.equivalence(getSMTVar(tuple, ctx), relation));
        }
        return enc;
    }

    private static boolean isOrdered(Event x, Event y, Event z) {
        return x.getCId() < y.getCId() && y.getCId() < z.getCId();
    }
}