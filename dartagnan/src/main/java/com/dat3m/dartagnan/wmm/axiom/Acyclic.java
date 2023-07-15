package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.collect.Sets.difference;

@Options
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
        return (negated ? "~" : "") + "acyclic " + rel.getNameOrTerm();
    }

    @Override
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        long t0 = System.currentTimeMillis();
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis.Knowledge knowledge = knowledgeMap.get(rel);
        Set<Tuple> newDisabled = new HashSet<>();
        for (Tuple t : knowledge.getMaySet()) {
            if (t.isLoop()) {
                newDisabled.add(t);
            }
        }
        for (Tuple t : knowledge.getMustSet()) {
            Tuple inverse = t.getInverse();
            if (knowledge.containsMay(inverse)) {
                newDisabled.add(inverse);
            }
        }
        Map<Event, List<Event>> mustOut = new HashMap<>();
        for (Tuple t : knowledge.getMustSet()) {
            if (!t.isLoop()) {
                mustOut.computeIfAbsent(t.getFirst(), x -> new ArrayList<>()).add(t.getSecond());
            }
        }
        for (Collection<Tuple> next = knowledge.getMustSet(); !next.isEmpty();) {
            Collection<Tuple> current = next;
            next = new ArrayList<>();
            for (Tuple xy : current) {
                if (xy.isLoop()) {
                    continue;
                }
                Event x = xy.getFirst();
                Event y = xy.getSecond();
                boolean implied = exec.isImplied(x, y);
                for (Event z : mustOut.getOrDefault(y, List.of())) {
                    if ((implied || exec.isImplied(z, y)) && !exec.areMutuallyExclusive(x, z)) {
                        Tuple zx = new Tuple(z, x);
                        if (newDisabled.add(zx)) {
                            next.add(new Tuple(x, z));
                        }
                    }
                }
            }
        }
        newDisabled.retainAll(knowledge.getMaySet());
        logger.debug("disabled {} tuples in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(newDisabled, Set.of()));
    }

    @Override
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeIncrementalKnowledgeClosure(
            Relation changed,
            Set<Tuple> disabled,
            Set<Tuple> enabled,
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        checkArgument(changed == rel,
                "misdirected knowledge propagation from relation %s to %s", changed, this);
        long t0 = System.currentTimeMillis();
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis.Knowledge knowledge = knowledgeMap.get(rel);
        Set<Tuple> newDisabled = new HashSet<>();
        for (Tuple t : enabled) {
            Tuple inverse = t.getInverse();
            if (knowledge.containsMay(inverse)) {
                newDisabled.add(inverse);
            }
        }
        Map<Event, List<Event>> mustIn = new HashMap<>();
        Map<Event, List<Event>> mustOut = new HashMap<>();
        for (Tuple t : knowledge.getMustSet()) {
            if (!t.isLoop()) {
                mustIn.computeIfAbsent(t.getSecond(), x -> new ArrayList<>()).add(t.getFirst());
                mustOut.computeIfAbsent(t.getFirst(), x -> new ArrayList<>()).add(t.getSecond());
            }
        }
        for (Collection<Tuple> next = enabled; !next.isEmpty();) {
            Collection<Tuple> current = next;
            next = new ArrayList<>();
            for (Tuple xy : current) {
                if (xy.isLoop()) {
                    continue;
                }
                Event x = xy.getFirst();
                Event y = xy.getSecond();
                boolean implies = exec.isImplied(x, y);
                boolean implied = exec.isImplied(y, x);
                for (Event w : mustIn.getOrDefault(x, List.of())) {
                    if ((implied || exec.isImplied(w, x)) && !exec.areMutuallyExclusive(w, y)) {
                        Tuple yw = new Tuple(y, w);
                        if (newDisabled.add(yw)) {
                            next.add(new Tuple(w, y));
                        }
                    }
                }
                for (Event z : mustOut.getOrDefault(y, List.of())) {
                    if ((implies || exec.isImplied(z, y)) && !exec.areMutuallyExclusive(x, z)) {
                        Tuple zx = new Tuple(z, x);
                        if (newDisabled.add(zx)) {
                            next.add(new Tuple(x, z));
                        }
                    }
                }
            }
        }
        newDisabled.retainAll(knowledge.getMaySet());
        logger.debug("Disabled {} tuples in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(newDisabled, Set.of()));
    }

    @Override
    protected Set<Tuple> getEncodeTupleSet(Context analysisContext) {
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
        return difference(getEncodeTupleSet(exec, ra), k.getMustSet());
    }

    public int getEncodeTupleSetSize(Context analysisContext) {
        return getEncodeTupleSet(analysisContext).size();
    }

    private Set<Tuple> getEncodeTupleSet(ExecutionAnalysis exec, RelationAnalysis ra) {
        logger.info("Computing encodeTupleSet for {}", this);
        // ====== Construct [Event -> Successor] mapping ======
        Map<Event, Collection<Event>> succMap = new HashMap<>();
        final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
        for (Tuple t : k.getMaySet()) {
            succMap.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t.getSecond());
        }

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        final Set<Tuple> result = new HashSet<>();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Event>.Node node1 : scc) {
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Tuple t = new Tuple(node1.getContent(), node2.getContent());
                    if (k.containsMay(t)) {
                        result.add(t);
                    }
                }
            }
        }

        logger.info("encodeTupleSet size: {}", result.size());
        if (getMemoryModel().getConfig().isReduceAcyclicityEncoding()) {
            Set<Tuple> obsolete = transitivelyDerivableMustTuples(exec, ra.getKnowledge(rel));
            result.removeAll(obsolete);
            logger.info("reduced encodeTupleSet size: {}", result.size());
        }
        return result;
    }

    // Under-approximates the must-set of (rel+ ; rel).
    // It is the smallest set that contains the binary composition of the must-set with itself with implied intermediates
    // and is closed under that operation with the must-set.
    // Basically, the clause {@code exec(x) and exec(z) implies before(x,z)} is obsolete,
    // if the clauses {@code exec(x) implies before(x,y)} and {@code exec(z) implies before(y,z)} exist.
    // NOTE: Assumes that the must-set of rel+ is acyclic.
    private static Set<Tuple> transitivelyDerivableMustTuples(ExecutionAnalysis exec, RelationAnalysis.Knowledge k) {
        Set<Tuple> result = new HashSet<>();
        Map<Event, List<Event>> map = new HashMap<>();
        Map<Event, List<Event>> mapInverse = new HashMap<>();
        Collection<Tuple> current = k.getMustSet();
        while (!current.isEmpty()) {
            List<Tuple> next = new ArrayList<>();
            for (Tuple tuple : current) {
                map.computeIfAbsent(tuple.getFirst(), x -> new ArrayList<>()).add(tuple.getSecond());
                mapInverse.computeIfAbsent(tuple.getSecond(), x -> new ArrayList<>()).add(tuple.getFirst());
            }
            for (Tuple xy : current) {
                Event x = xy.getFirst();
                Event y = xy.getSecond();
                boolean implied = exec.isImplied(y, x);
                boolean implies = exec.isImplied(x, y);
                for (Event z : map.getOrDefault(y, List.of())) {
                    if ((implies || exec.isImplied(z, y)) && !exec.areMutuallyExclusive(x, z)) {
                        Tuple xz = new Tuple(x, z);
                        if (result.add(xz)) {
                            next.add(xz);
                        }
                    }
                }
                for (Event w : mapInverse.getOrDefault(x, List.of())) {
                    if ((implied || exec.isImplied(w, x)) && !exec.areMutuallyExclusive(w, y)) {
                        Tuple wy = new Tuple(w, y);
                        if (result.add(wy)) {
                            next.add(wy);
                        }
                    }
                }
            }
            current = next;
        }
        return result;
    }

    private void reduceWithMinSets(Set<Tuple> encodeSet, ExecutionAnalysis exec, RelationAnalysis ra) {
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
        final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);

        // (1) Approximate transitive closure of minSet (only gets computed when crossEdges are available)
        List<Tuple> crossEdges = k.getMustSet().stream()
                .filter(t -> t.isCrossThread() && !t.getFirst().hasTag(Tag.INIT))
                .collect(Collectors.toList());
        logger.debug("cross-edges: {}", crossEdges.size());
        Map<Event, Set<Event>> transMinSet = new HashMap<>();
        for (Tuple t : k.getMustSet()) {
            transMinSet.computeIfAbsent(t.getSecond(), x -> new HashSet<>()).add(t.getFirst());
        }
        final Function<Event, Collection<Tuple>> mustIn = k.getMustIn();
        final Function<Event, Collection<Tuple>> mustOut = k.getMustOut();
        for (Tuple crossEdge : crossEdges) {
            Event e1 = crossEdge.getFirst();
            Event e2 = crossEdge.getSecond();
            List<Event> ingoing = new ArrayList<>();
            ingoing.add(e1); // ingoing events + self
            mustIn.apply(e1).stream().map(Tuple::getFirst)
                    .filter(e -> exec.isImplied(e, e1))
                    .forEach(ingoing::add);
            List<Event> outgoing = new ArrayList<>();
            outgoing.add(e2); // outgoing edges + self
            mustOut.apply(e2).stream().map(Tuple::getSecond)
                    .filter(e -> exec.isImplied(e, e2))
                    .forEach(outgoing::add);
            for (Event in : ingoing) {
                for (Event out : outgoing) {
                    transMinSet.computeIfAbsent(out, x -> new HashSet<>()).add(in);
                }
            }
        }

        // (2) Approximate reduction of transitive must-set: red(must(r)+).
        // Note: We reduce the transitive closure which may have more edges
        // that can be used to perform reduction
        // Approximative must-transitive reduction of minSet:
        Set<Tuple> reduct = new HashSet<>();
        DependencyGraph<Event> depGraph = DependencyGraph.from(transMinSet.keySet(), e -> transMinSet.getOrDefault(e, Set.of()));
        for (DependencyGraph<Event>.Node start : depGraph.getNodes()) {
            Event e1 = start.getContent();
            List<DependencyGraph<Event>.Node> deps = start.getDependents();
            for (int i = deps.size() - 1; i >= 0; i--) {
                Event e3 = deps.get(i).getContent();
                if (deps.subList(0, i).stream()
                        .map(DependencyGraph.Node::getContent)
                        .noneMatch(e2 -> (exec.isImplied(e1, e2) || exec.isImplied(e3, e2)) &&
                                transMinSet.getOrDefault(e3, Set.of()).contains(e2))) {
                    reduct.add(new Tuple(e1, e3));
                }
            }
        }

        // Remove (must(r)+ \ red(must(r)+)
        encodeSet.removeIf(t -> transMinSet.getOrDefault(t.getSecond(), Set.of()).contains(t.getFirst()) && !reduct.contains(t));
    }

    @Override
	public List<BooleanFormula> consistent(EncodingContext context) {
        ExecutionAnalysis exec = context.getAnalysisContext().get(ExecutionAnalysis.class);
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        Set<Tuple> toBeEncoded = getEncodeTupleSet(exec, ra);
        return negated ?
                inconsistentSAT(toBeEncoded, context) : // There is no IDL-based encoding for inconsistency
                context.usesSATEncoding() ?
                        consistentSAT(toBeEncoded, context) :
                        consistentIDL(toBeEncoded, context);
    }

    private List<BooleanFormula> inconsistentSAT(Set<Tuple> toBeEncoded, EncodingContext context) {
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final Relation rel = this.rel;
        List<BooleanFormula> enc = new ArrayList<>();
        List<BooleanFormula> eventsInCycle = new ArrayList<>();
        Map<Event, List<BooleanFormula>> inMap = new HashMap<>();
        Map<Event, List<BooleanFormula>> outMap = new HashMap<>();
        for(Tuple t : toBeEncoded) {
            BooleanFormula cycleVar = getSMTCycleVar(t, fmgr);
            inMap.computeIfAbsent(t.getSecond(), k -> new ArrayList<>()).add(cycleVar);
            outMap.computeIfAbsent(t.getFirst(), k -> new ArrayList<>()).add(cycleVar);
        }
        // We use Boolean variables which guess the edges and nodes constituting the cycle.
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        for (Event e : toBeEncoded.stream().map(Tuple::getFirst).collect(Collectors.toSet())) {
            eventsInCycle.add(cycleVar(e, fmgr));
            // We ensure that for every event in the cycle, there should be at least one incoming
            // edge and at least one outgoing edge that are also in the cycle.
            enc.add(bmgr.implication(cycleVar(e, fmgr), bmgr.and(bmgr.or(inMap.get(e)), bmgr.or(outMap.get(e)))));
            for (Tuple tuple : toBeEncoded) {
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                // If an edge is guessed to be in a cycle, the edge must belong to relation,
                // and both events must also be guessed to be on the cycle.
                enc.add(bmgr.implication(getSMTCycleVar(tuple, fmgr),
                        bmgr.and(edge.encode(tuple), cycleVar(e1, fmgr), cycleVar(e2, fmgr))));
            }
        }
        // A cycle exists if there is an event in the cycle.
        enc.add(bmgr.or(eventsInCycle));
        return enc;
    }

    private List<BooleanFormula> consistentIDL(Set<Tuple> toBeEncoded, EncodingContext context) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
        final Relation rel = this.rel;
        final String clockVarName = rel.getNameOrTerm();

        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        for (Tuple tuple : toBeEncoded) {
            enc.add(bmgr.implication(edge.encode(tuple),
                    imgr.lessThan(
                            context.clockVariable(clockVarName, tuple.getFirst()),
                            context.clockVariable(clockVarName, tuple.getSecond()))));
        }

        return enc;
    }

    private List<BooleanFormula> consistentSAT(Set<Tuple> toBeEncoded, EncodingContext context) {
        // We use a vertex-elimination graph based encoding.
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
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
        final Set<Tuple> minSet = ra.getKnowledge(rel).getMustSet();
        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        // Basic lifting
        for (Tuple t : toBeEncoded) {
            BooleanFormula cond = minSet.contains(t) ? context.execution(t.getFirst(), t.getSecond()) : edge.encode(t);
            enc.add(bmgr.implication(cond, getSMTCycleVar(t, fmgr)));
        }

        // Encode triangle rules
        for (Event[] tri : triangles) {
            Tuple t1 = new Tuple(tri[0], tri[1]);
            Tuple t2 = new Tuple(tri[1], tri[2]);
            Tuple t3 = new Tuple(tri[0], tri[2]);

            BooleanFormula cond = minSet.contains(t3) ?
                    context.execution(t3.getFirst(), t3.getSecond())
                    : bmgr.and(getSMTCycleVar(t1, fmgr), getSMTCycleVar(t2, fmgr));

            enc.add(bmgr.implication(cond, getSMTCycleVar(t3, fmgr)));
        }

        //  --- Encode inconsistent assignments ---
        // Handle self-loops
        for (Event e : selfloops) {
            enc.add(bmgr.not(edge.encode(new Tuple(e, e))));
        }
        // Handle remaining cycles
        for (int i = 0; i < varOrderings.size(); i++) {
            Set<Tuple> out = vertEleOutEdges.get(varOrderings.get(i));
            for (Tuple t : out) {
                if (varOrderings.indexOf(t.getSecond()) > i && vertEleInEdges.get(t.getSecond()).contains(t)) {
                    BooleanFormula cond = minSet.contains(t) ? bmgr.makeTrue() : getSMTCycleVar(t, fmgr);
                    enc.add(bmgr.implication(cond, bmgr.not(getSMTCycleVar(t.getInverse(), fmgr))));
                }
            }
        }

        return enc;
    }

    private BooleanFormula cycleVar(Event event, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d", m.escape(getNameOrTerm()), event.getGlobalId()));
    }

    private BooleanFormula getSMTCycleVar(Tuple edge, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d %d", m.escape(getNameOrTerm()), edge.getFirst().getGlobalId(), edge.getSecond().getGlobalId()));
    }
}