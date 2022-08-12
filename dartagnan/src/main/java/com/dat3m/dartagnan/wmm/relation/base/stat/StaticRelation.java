package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.List;

import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.iterate;

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

        for(Tuple tuple : encodeTupleSet) {
        	BooleanFormula rel = this.getSMTVar(tuple, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(getExecPair(tuple, ctx))));
        }
        return enc;
    }

    protected interface MatchConsumer {
        /**
         * Called once for each found pair.
         * @param tuple Pair of events that could match in some execution.
         * @param noIntermediary There is no event between the pair that could match with any of both.
         */
        void accept(Tuple tuple, boolean noIntermediary);
    }

    /**
     * Iterates all program-ordered pairs of events that describe.
     * @param filter Program-ordered collection of relevant events from a same thread.
     * @param filterFirst Classifies events from {@code events} that appear as first field.
     * @param filterSecond Classifies events in {@code events} for the second field.
     * @param match Invoked once for each matched tuple.
     */
    protected void findMatchingPairs(FilterAbstract filter, FilterAbstract filterFirst, FilterAbstract filterSecond, MatchConsumer match) {
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        for (Thread thread : task.getProgram().getThreads()) {
            List<Event> events = thread.getCache().getEvents(filter);
            // assume order by cId
            // assume cId describes a topological sorting over the control flow
            for (int end = 1; end < events.size(); end++) {
                Event second = events.get(end);
                if (!filterSecond.filter(second)) {
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
                    if (filterFirst.filter(first) &&
                            intermediaries.stream().noneMatch(e -> exec.isImplied(first, e))) {
                        match.accept(new Tuple(first, second),
                                intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(first, e)));
                    }
                }
            }
        }
    }
}
