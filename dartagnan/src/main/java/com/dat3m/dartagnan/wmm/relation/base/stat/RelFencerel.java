package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

public class RelFencerel extends StaticRelation {

    protected FilterAbstract filter;

    public static String makeTerm(FilterAbstract filter){
        return "fencerel(" + filter + ")";
    }

    public RelFencerel(FilterAbstract filter) {
        this.filter = filter;
        term = makeTerm(filter);
    }

    public RelFencerel(FilterAbstract filter, String name) {
        super(name);
        this.filter = filter;
        term = makeTerm(filter);
    }

    public String getFenceName() { return name != null ? name : filter.getName(); }
    public FilterAbstract getFilter() { return filter; }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
            minTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(filter);
                List<Event> memEvents = t.getCache().getEvents(FilterBasic.get(Tag.MEMORY));
                for (Event fence : fences) {
                    int numEventsBeforeFence = (int) memEvents.stream()
                            .mapToInt(Event::getCId).filter(id -> id < fence.getCId())
                            .count();
                    List<Event> eventsBefore = memEvents.subList(0, numEventsBeforeFence);
                    List<Event> eventsAfter = memEvents.subList(numEventsBeforeFence, memEvents.size());

                    for (Event e1 : eventsBefore) {
                        boolean isImpliedByE1 = exec.isImplied(e1, fence);
                        for (Event e2 : eventsAfter) {
                            if (isImpliedByE1 || exec.isImplied(e2, fence)) {
                                minTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(minTupleSet);
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(filter);
                List<Event> memEvents = t.getCache().getEvents(FilterBasic.get(Tag.MEMORY));
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

        List<Event> fences = task.getProgram().getCache().getEvents(filter);

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
