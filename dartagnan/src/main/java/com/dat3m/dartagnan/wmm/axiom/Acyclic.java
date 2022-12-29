package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.*;
import java.util.stream.Collectors;

public class Acyclic extends Axiom {

	private static final Logger logger = LogManager.getLogger(Acyclic.class);

    public Acyclic(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Acyclic(Relation rel) {
        super(rel, false, false);
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "acyclic " + rel.getName();
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
	public BooleanFormula consistent(Set<Tuple> toBeEncoded, EncodingContext context) {
        BooleanFormula enc;
        if(negated) {
            enc = inconsistentSAT(toBeEncoded, context); // There is no IDL-based encoding for inconsistency
        } else {
            enc = context.usesSATEncoding() ? consistentSAT(toBeEncoded, context) : consistentIDL(toBeEncoded, context);
        }
        return enc;
    }

    private BooleanFormula inconsistentSAT(Set<Tuple> toBeEncoded, EncodingContext context) {
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final Relation rel = this.rel;
        BooleanFormula enc = bmgr.makeTrue();
        BooleanFormula eventsInCycle = bmgr.makeFalse();
        Map<Event, BooleanFormula> inMap = new HashMap<>();
        Map<Event, BooleanFormula> outMap = new HashMap<>();
        for(Tuple t : toBeEncoded) {
            BooleanFormula cycleVar = getSMTCycleVar(t, fmgr);
            inMap.merge(t.getSecond(), cycleVar, bmgr::or);
            outMap.merge(t.getFirst(), cycleVar, bmgr::or);
        }
        // We use Boolean variables which guess the edges and nodes constituting the cycle.
        for (Event e : toBeEncoded.stream().map(Tuple::getFirst).collect(Collectors.toSet())) {
            eventsInCycle = bmgr.or(eventsInCycle, cycleVar(e, fmgr));
            // We ensure that for every event in the cycle, there should be at least one incoming
            // edge and at least one outgoing edge that are also in the cycle.
            enc = bmgr.and(enc, bmgr.implication(cycleVar(e, fmgr), bmgr.and(inMap.get(e), outMap.get(e))));
            for (Tuple tuple : toBeEncoded) {
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                // If an edge is guessed to be in a cycle, the edge must belong to relation,
                // and both events must also be guessed to be on the cycle.
                enc = bmgr.and(enc, bmgr.implication(getSMTCycleVar(tuple, fmgr),
                        bmgr.and(context.edge(rel, tuple), cycleVar(e1, fmgr), cycleVar(e2, fmgr))));
            }
        }
        // A cycle exists if there is an event in the cycle.
        enc = bmgr.and(enc, eventsInCycle);
        return enc;
    }

    private BooleanFormula consistentIDL(Set<Tuple> toBeEncoded, EncodingContext context) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
        final Relation rel = this.rel;
        final String clockVarName = rel.getName();

        BooleanFormula enc = bmgr.makeTrue();
        for (Tuple tuple : toBeEncoded) {
            enc = bmgr.and(enc, bmgr.implication(context.edge(rel, tuple),
                    imgr.lessThan(
                            context.clockVariable(clockVarName, tuple.getFirst()),
                            context.clockVariable(clockVarName, tuple.getSecond()))));
        }

        return enc;
    }

    private BooleanFormula consistentSAT(Set<Tuple> toBeEncoded, EncodingContext context) {
        // We use a vertex-elimination graph based encoding.
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        final Relation rel = this.rel;

        // Build original graph G
        Map<Event, Set<Tuple>> inEdges = new HashMap<>();
        Map<Event, Set<Tuple>> outEdges = new HashMap<>();
        Set<Event> nodes = new HashSet<>();
        Set<Event> selfloops = new HashSet<>();         // Special treatment for self-loops
        for (final Tuple t : toBeEncoded) {
            final Event e1 = t.getFirst();
            final Event e2 = t.getSecond();
            if (t.isLoop()) {
                selfloops.add(e1);
            } else {
                nodes.add(e1);
                nodes.add(e2);
                outEdges.computeIfAbsent(e1, key -> new HashSet<>()).add(t);
                inEdges.computeIfAbsent(e2, key -> new HashSet<>()).add(t);
            }
        }

        // Handle corner-cases where some node has no ingoing or outgoing edges
        for (Event node : nodes) {
            outEdges.putIfAbsent(node, new HashSet<>());
            inEdges.putIfAbsent(node, new HashSet<>());
        }

        // Build vertex elimination graph G*, by iteratively modifying G
        Map<Event, Set<Tuple>> vertEleInEdges = new HashMap<>();
        Map<Event, Set<Tuple>> vertEleOutEdges = new HashMap<>();
        for (Event e : nodes) {
            vertEleInEdges.put(e, new HashSet<>(inEdges.get(e)));
            vertEleOutEdges.put(e, new HashSet<>(outEdges.get(e)));
        }
        List<Event[]> triangles = new ArrayList<>();

        // Build variable elimination ordering
        List<Event> varOrderings = new ArrayList<>(); // We should order this
        while (!nodes.isEmpty()) {
            // Find best vertex e to eliminate
            final Comparator<Event> comparator = Comparator.comparingInt(ev -> vertEleInEdges.get(ev).size() * vertEleOutEdges.get(ev).size());
            final Event e = nodes.stream().min(comparator).get();
            varOrderings.add(e);

            // Eliminate e
            nodes.remove(e);
            final Set<Tuple> in = inEdges.remove(e);
            final Set<Tuple> out = outEdges.remove(e);
            in.forEach(t -> outEdges.get(t.getFirst()).remove(t));
            out.forEach(t -> inEdges.get(t.getSecond()).remove(t));
            // Create new edges due to elimination of e
            for (Tuple t1 : in) {
                Event e1 = t1.getFirst();
                for (Tuple t2 : out) {
                    Event e2 = t2.getSecond();
                    if (e2 == e1 || exec.areMutuallyExclusive(e1, e2)) {
                        continue;
                    }
                    Tuple t = new Tuple(e1, e2);
                    // Update next graph in the elimination sequence
                    inEdges.get(e2).add(t);
                    outEdges.get(e1).add(t);
                    // Update vertex elimination graph
                    vertEleOutEdges.get(e1).add(t);
                    vertEleInEdges.get(e2).add(t);
                    // Store constructed triangle
                    triangles.add(new Event[]{e1, e, e2});
                }
            }
        }

        // --- Create encoding ---
        final Set<Tuple> minSet = rel.getMinTupleSet();
        BooleanFormula enc = bmgr.makeTrue();
        // Basic lifting
        for (Tuple t : toBeEncoded) {
            BooleanFormula cond = minSet.contains(t) ? context.execution(t.getFirst(), t.getSecond()) : context.edge(rel, t);
            enc = bmgr.and(enc, bmgr.implication(cond, getSMTCycleVar(t, fmgr)));
        }

        // Encode triangle rules
        for (Event[] tri : triangles) {
            Tuple t1 = new Tuple(tri[0], tri[1]);
            Tuple t2 = new Tuple(tri[1], tri[2]);
            Tuple t3 = new Tuple(tri[0], tri[2]);

            BooleanFormula cond = minSet.contains(t3) ?
                    context.execution(t3.getFirst(), t3.getSecond())
                    : bmgr.and(getSMTCycleVar(t1, fmgr), getSMTCycleVar(t2, fmgr));

            enc = bmgr.and(enc, bmgr.implication(cond, getSMTCycleVar(t3, fmgr)));
        }

        //  --- Encode inconsistent assignments ---
        // Handle self-loops
        for (Event e : selfloops) {
            enc = bmgr.and(enc, bmgr.not(context.edge(rel, new Tuple(e, e))));
        }
        // Handle remaining cycles
        for (int i = 0; i < varOrderings.size(); i++) {
            Set<Tuple> out = vertEleOutEdges.get(varOrderings.get(i));
            for (Tuple t : out) {
                if (varOrderings.indexOf(t.getSecond()) > i && vertEleInEdges.get(t.getSecond()).contains(t)) {
                    BooleanFormula cond = minSet.contains(t) ? bmgr.makeTrue() : getSMTCycleVar(t, fmgr);
                    enc = bmgr.and(enc, bmgr.implication(cond, bmgr.not(getSMTCycleVar(t.getInverse(), fmgr))));
                }
            }
        }

        return enc;
    }

    private BooleanFormula cycleVar(Event event, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d", m.escape(getNameOrTerm()), event.getCId()));
    }

    private BooleanFormula getSMTCycleVar(Tuple edge, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d %d", m.escape(getNameOrTerm()), edge.getFirst().getCId(), edge.getSecond().getCId()));
    }
}