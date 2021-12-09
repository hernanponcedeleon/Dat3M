package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.dat3m.dartagnan.wmm.utils.Utils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

	private static final Logger logger = LogManager.getLogger(Acyclic.class);

    public Acyclic(Relation rel) {
        super(rel);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        logger.info("Computing encodeTupleSet for " + this);
        // ====== Construct [Event -> Successor] mapping ======
        Map<Event, Collection<Event>> succMap = new HashMap<>();
        TupleSet relMaxTuple = rel.getMaxTupleSet();
        for (Tuple t : relMaxTuple) {
            succMap.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t.getSecond());
        }

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        TupleSet result = new TupleSet();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Event>.Node node1 : scc) {
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Tuple t = new Tuple(node1.getContent(), node2.getContent());
                    if (relMaxTuple.contains(t)) {
                        result.add(t);
                    }
                }
            }
        }

        logger.info("encodeTupleSet size " + result.size());
        if (GlobalSettings.REDUCE_ACYCLICITY_ENCODE_SETS) {
            reduceWithMinSets(result);
            logger.info("reduced encodeTupleSet size " + result.size());
        }
        return result;
    }

    private void reduceWithMinSets(TupleSet encodeSet) {
        /*
            Assumption: MinSet is acyclic!
            Overall idea:
                (1) We compute a (must) transitive reduction of must(rel) per thread.
                    - For this, we assume that must(rel) is mostly transitive per thread.
                      If it is not, we won't get a full reduction but still a good one
                    - For any pair (a, c) in must(rel) mod thread, we look for some b such that
                      (a, b) and (b, c) is in must(rel) and b is implied by either a or c
                (2) We compute the (must) transitive closure of must(rel) (not of the reduction!!!)
                    - Any edge in "must(rel)+ \ red(must(rel))" can be removed from the encodeSet
                    - We might want to optimize this by finding the cross-thread must edges
                      and only compute reachability wrt to those, as we assume that must(rel) is already
                      transitive within threads.

         */
        BranchEquivalence eq = task.getBranchEquivalence();
        TupleSet minSet = rel.getMinTupleSet();
        // (1) Reduction
        TupleSet reduct = new TupleSet();
        Map<Event, Collection<Event>> predMap = new HashMap<>();
        for (Tuple t : minSet) {
            predMap.computeIfAbsent(t.getSecond(), key -> new ArrayList<>()).add(t.getFirst());
        }
        DependencyGraph<Event> depGraph = DependencyGraph.from(predMap.keySet(), predMap);
        for (DependencyGraph<Event>.Node start : depGraph.getNodes()) {
            Event e1 = start.getContent();
            List<DependencyGraph<Event>.Node> deps = start.getDependents();
            for (int i = deps.size() - 1; i >= 0; i--) {
                DependencyGraph<Event>.Node end = deps.get(i);
                Event e3 = end.getContent();
                boolean redundant = false;
                for (DependencyGraph<Event>.Node mid : deps.subList(0, i)) {
                    Event e2 = mid.getContent();
                    if (e2.cfImpliesExec() && (eq.isImplied(e1, e2) || eq.isImplied(e3, e2))) {
                        if (minSet.contains(new Tuple(e2, e3))) {
                            redundant = true;
                            break;
                        }
                    }
                }
                if (!redundant) {
                    reduct.add(new Tuple(e1, e3));
                }
            }
        }

        //TODO (2): Will only be relevant once we have cross-thread must-edges

        encodeSet.removeIf(t -> minSet.contains(t) && !reduct.contains(t));
    }

    @Override
	public BooleanFormula consistent(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
			enc = bmgr.and(enc, bmgr.implication(rel.getSMTVar(tuple, ctx), 
									imgr.lessThan(
											Utils.intVar(rel.getName(), e1, ctx), 
											Utils.intVar(rel.getName(), e2, ctx))));
        }
        return enc;
    }

    @Override
    public String toString() {
        return "acyclic " + rel.getName();
    }
}