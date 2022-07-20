package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;

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
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        ExecutionAnalysis exec = a.analysisContext().get(ExecutionAnalysis.class);
        TupleSet maxTupleSet = new TupleSet();
        TupleSet minTupleSet = new TupleSet();
        for(Thread t : a.task().getProgram().getThreads()){
            List<Event> fences = t.getCache().getEvents(FilterBasic.get(fenceName));
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
                        if(!exec.areMutuallyExclusive(e1, e2)) {
                            maxTupleSet.add(new Tuple(e1, e2));
                            if(isImpliedByE1 || exec.isImplied(e2, fence)) {
                                minTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
        }
        a.send(this, maxTupleSet, minTupleSet);
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        List<Event> fences = encoder.task().getProgram().getCache().getEvents(FilterBasic.get(fenceName));
        ExecutionAnalysis exec = encoder.analysisContext().requires(ExecutionAnalysis.class);
        RelationAnalysis ra = encoder.analysisContext().requires(RelationAnalysis.class);
        TupleSet minTupleSet = ra.must(this);
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

            BooleanFormula rel = encoder.edge(this, tuple);
            enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(execution(tuple.getFirst(), tuple.getSecond(), exec, ctx), orClause)));
        }

        return enc;
    }
}
