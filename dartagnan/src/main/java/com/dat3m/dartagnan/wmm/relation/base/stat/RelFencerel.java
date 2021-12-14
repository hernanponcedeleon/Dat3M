package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

public class RelFencerel extends StaticRelation {

    private final String fenceName;

    public static String makeTerm(String fenceName){
        return "fencerel(" + fenceName + ")";
    }

    public RelFencerel(String fenceName) {
        this.fenceName = fenceName;
        term = makeTerm(fenceName);
    }

    public RelFencerel(String fenceName, String name) {
        super(name);
        this.fenceName = fenceName;
        term = makeTerm(fenceName);
    }

    public String getFenceName() { return fenceName; }

    @Override
    public void fetchMinTupleSet() {
        if(minTupleSet.isEmpty()) {
            BranchEquivalence eq = task.getBranchEquivalence();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(FilterBasic.get(fenceName));
                List<Event> memEvents = t.getCache().getEvents(FilterBasic.get(EType.MEMORY));
                for (Event fence : fences) {
                    if (!fence.cfImpliesExec()) {
                        continue;
                    }
                    int numEventsBeforeFence = (int) memEvents.stream()
                            .mapToInt(Event::getCId).filter(id -> id < fence.getCId())
                            .count();
                    List<Event> eventsBefore = memEvents.subList(0, numEventsBeforeFence);
                    List<Event> eventsAfter = memEvents.subList(numEventsBeforeFence, memEvents.size());

                    for (Event e1 : eventsBefore) {
                        boolean isImpliedByE1 = eq.isImplied(e1, fence);
                        for (Event e2 : eventsAfter) {
                            if (isImpliedByE1 || eq.isImplied(e2, fence)) {
                                minTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(minTupleSet);
        }
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(FilterBasic.get(fenceName));
                List<Event> memEvents = t.getCache().getEvents(FilterBasic.get(EType.MEMORY));
                for (Event fence : fences) {
                    int numEventsBeforeFence = (int) memEvents.stream()
                            .mapToInt(Event::getCId).filter(id -> id < fence.getCId())
                            .count();
                    List<Event> eventsBefore = memEvents.subList(0, numEventsBeforeFence);
                    List<Event> eventsAfter = memEvents.subList(numEventsBeforeFence, memEvents.size());

                    for (Event e1 : eventsBefore) {
                        for (Event e2 : eventsAfter) {
                            maxTupleSet.add(new Tuple(e1, e2));
                        }
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
		BooleanFormula enc = bmgr.makeTrue();

        List<Event> fences = task.getProgram().getCache().getEvents(FilterBasic.get(fenceName));

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BooleanFormula orClause;
            if(minTupleSet.contains(tuple)) {
                orClause = bmgr.makeTrue();
            } else {
                orClause = fences.stream()
                        .filter(f -> e1.getCId() < f.getCId() && f.getCId() < e2.getCId())
                        .map(Event::exec).reduce(bmgr.makeFalse(), bmgr::or);
            }

            BooleanFormula rel = this.getSMTVar(tuple, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(getExecPair(tuple, ctx), orClause)));
        }

        return enc;
    }
}
