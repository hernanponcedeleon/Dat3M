package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.dat3m.dartagnan.wmm.utils.Utils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.utils.Utils.cycleVar;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

	private static final Logger logger = LogManager.getLogger(Acyclic.class);

    public Acyclic(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Acyclic(Relation rel) {
        super(rel, false, false);
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
            ASSUMPTION: MinSet is acyclic!
            IDEA:
                Edges that are (must-)transitively implied do not need to get encoded.
                For this, we compute a (must-)transitive closure and a (must-)transitive reduction of must(rel).
                The difference "must(rel)+ \ red(must(rel))" does not net to be encoded.
                Note that it this is sound if the closure gets underapproximated and/or the reduction
                gets over approximated.
            COMPUTATION:
                (1) We compute an approximate (must-)transitive closure of must(rel)
                    - must(rel) is likely to be already transitive per thread (due to mostly coming from po)
                      Hence, we get a reasonable approximation by closing transitively over thread-crossing edges only.
                (2) We compute a (must) transitive reduction of the transitively closed must(rel)+.
                    - Since must(rel)+ is transitive, it suffice to check for each edge (a, c) if there
                      is an intermediate event b such that (a, b) and (b, c) are in must(rel)+
                      and b is implied by either a or c.
                    - It is possible to reduce must(rel) but that may give a less precise result.
         */
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        TupleSet minSet = rel.getMinTupleSet();

        // (1) Approximate transitive closure of minSet (only gets computed when crossEdges are available)
        List<Tuple> crossEdges = minSet.stream()
                .filter(t -> t.isCrossThread() && !t.getFirst().is(Tag.INIT))
                .collect(Collectors.toList());
        TupleSet transMinSet = crossEdges.isEmpty() ? minSet : new TupleSet(minSet);
        for (Tuple crossEdge : crossEdges) {
            Event e1 = crossEdge.getFirst();
            Event e2 = crossEdge.getSecond();

            List<Event> ingoing = new ArrayList<>();
            ingoing.add(e1); // ingoing events + self
            minSet.getBySecond(e1).stream().map(Tuple::getFirst)
                    .filter(e -> exec.isImplied(e, e1))
                    .forEach(ingoing::add);


            List<Event> outgoing = new ArrayList<>();
            outgoing.add(e2); // outgoing edges + self
            minSet.getByFirst(e2).stream().map(Tuple::getSecond)
                    .filter(e -> exec.isImplied(e, e2))
                    .forEach(outgoing::add);

            for (Event in : ingoing) {
                for (Event out : outgoing) {
                    transMinSet.add(new Tuple(in, out));
                }
            }
        }

        // (2) Approximate reduction of transitive must-set: red(must(r)+).
        // Note: We reduce the transitive closure which may have more edges
        // that can be used to perform reduction
        TupleSet reduct = TupleSet.approximateTransitiveMustReduction(exec, transMinSet);

        // Remove (must(r)+ \ red(must(r)+)
        encodeSet.removeIf(t -> transMinSet.contains(t) && !reduct.contains(t));
    }

    @Override
	public BooleanFormula consistent(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeTrue();
        BooleanFormula eventsInCycle = bmgr.makeFalse();
        if(negated) {
        	// We use Boolean variables which guess the edges and nodes constituting the cycle. 
            for(Event e : rel.getEncodeTupleSet().stream().map(Tuple::getFirst).collect(Collectors.toSet())){
            	
            	eventsInCycle = bmgr.or(eventsInCycle, cycleVar(rel.getName(), e, ctx));
            	
            	BooleanFormula in = bmgr.makeFalse();
            	for(Tuple pre : rel.getEncodeTupleSet().getBySecond(e)) {
            		in = bmgr.or(in, getSMTCycleVar(pre, ctx));
            	}
            	BooleanFormula out = bmgr.makeFalse();
            	for(Tuple post : rel.getEncodeTupleSet().getByFirst(e)) {
            		out = bmgr.or(out, getSMTCycleVar(post, ctx));
            	}
            	// We ensure that for every event in the cycle, there should be at least one incoming 
            	// edge and at least one outgoing edge that are also in the cycle.
            	enc = bmgr.and(enc, bmgr.implication(cycleVar(rel.getName(), e, ctx), bmgr.and(in , out)));
            	
                for(Tuple tuple : rel.getEncodeTupleSet()){
                    Event e1 = tuple.getFirst();
                    Event e2 = tuple.getSecond();
                    // If an edge is guessed to be in a cycle, the edge must belong to relation, 
                    // and both events must also be guessed to be on the cycle.
                    enc = bmgr.and(enc, bmgr.implication(getSMTCycleVar(tuple, ctx),
                    		bmgr.and(rel.getSMTVar(tuple, ctx), cycleVar(rel.getName(), e1, ctx), cycleVar(rel.getName(), e2, ctx))));
                }
            }
            // A cycle exists if there is an event in the cycle.
            enc = bmgr.and(enc, eventsInCycle);
        } else {
            for(Tuple tuple : rel.getEncodeTupleSet()){
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
    			enc = bmgr.and(enc, bmgr.implication(rel.getSMTVar(tuple, ctx), 
    									imgr.lessThan(
    											Utils.intVar(rel.getName(), e1, ctx), 
    											Utils.intVar(rel.getName(), e2, ctx))));
            }        	
        }        
        return enc;
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "acyclic " + rel.getName();
    }

    private BooleanFormula getSMTCycleVar(Tuple edge, SolverContext ctx) {
        return !rel.getMaxTupleSet().contains(edge) ?
                ctx.getFormulaManager().getBooleanFormulaManager().makeFalse() :
                edge(getName() + "-cycle", edge.getFirst(), edge.getSecond(), ctx);
    }
}