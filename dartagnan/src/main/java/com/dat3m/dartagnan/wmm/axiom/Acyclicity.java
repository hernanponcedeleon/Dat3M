package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;

import java.util.*;

import static com.dat3m.dartagnan.wmm.utils.EventGraph.difference;
import static com.google.common.base.Preconditions.checkArgument;

public class Acyclicity extends Axiom {

    private static final Logger logger = LogManager.getLogger(Acyclicity.class);

    public Acyclicity(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Acyclicity(Relation rel) {
        super(rel, false, false);
    }

    // Under-approximates the must-set of (rel+ ; rel).
    // It is the smallest set that contains the binary composition of the must-set with itself with implied intermediates
    // and is closed under that operation with the must-set.
    // Basically, the clause {@code exec(x) and exec(z) implies before(x,z)} is obsolete,
    // if the clauses {@code exec(x) implies before(x,y)} and {@code exec(z) implies before(y,z)} exist.
    // NOTE: Assumes that the must-set of rel+ is acyclic.
    private static EventGraph transitivelyDerivableMustEdges(ExecutionAnalysis exec, RelationAnalysis.Knowledge k) {
        EventGraph result = new EventGraph();
        Map<Event, Set<Event>> map = new HashMap<>();
        Map<Event, Set<Event>> mapInverse = new HashMap<>();
        EventGraph current = k.getMustSet();
        while (!current.isEmpty()) {
            EventGraph next = new EventGraph();
            current.apply((x, y) -> {
                map.computeIfAbsent(x, e -> new HashSet<>()).add(y);
                mapInverse.computeIfAbsent(y, e -> new HashSet<>()).add(x);
            });
            current.apply((x, y) -> {
                boolean implied = exec.isImplied(y, x);
                boolean implies = exec.isImplied(x, y);
                for (Event z : map.getOrDefault(y, Set.of())) {
                    if (!implies && !exec.isImplied(z, y) || exec.areMutuallyExclusive(x, z)) {
                        continue;
                    }
                    if (result.add(x, z)) {
                        next.add(x, z);
                    }
                }
                for (Event w : mapInverse.getOrDefault(x, Set.of())) {
                    if (!implied && !exec.isImplied(w, x) || exec.areMutuallyExclusive(w, y)) {
                        continue;
                    }
                    if (result.add(w, y)) {
                        next.add(w, y);
                    }
                }
            });
            current = next;
        }
        return result;
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
        EventGraph may = knowledge.getMaySet();
        EventGraph must = knowledge.getMustSet();
        EventGraph newDisabled = new EventGraph();
        may.apply((e1, e2) -> {
            if (Tuple.isLoop(e1, e2) || must.contains(e2, e1)) {
                newDisabled.add(e1, e2);
            }
        });
        Map<Event, List<Event>> mustOut = new HashMap<>();
        must.apply((e1, e2) -> {
            if (!Tuple.isLoop(e1, e2)) {
                mustOut.computeIfAbsent(e1, x -> new ArrayList<>()).add(e2);
            }
        });
        EventGraph current = knowledge.getMustSet();
        while (true) {
            EventGraph next = new EventGraph();
            current.apply((x, y) -> {
                if (Tuple.isLoop(x, y)) {
                    boolean implied = exec.isImplied(x, y);
                    for (Event z : mustOut.getOrDefault(y, List.of())) {
                        if (!implied && !exec.isImplied(z, y) || exec.areMutuallyExclusive(x, z)) {
                            continue;
                        }
                        if (newDisabled.add(z, x)) {
                            next.add(x, z);
                        }
                    }
                }
            });
            if (next.isEmpty()) {
                break;
            }
            current = next;
        }
        newDisabled.retainAll(knowledge.getMaySet());
        logger.debug("disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(newDisabled, EventGraph.empty()));
    }

    @Override
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeIncrementalKnowledgeClosure(
            Relation changed,
            EventGraph disabled,
            EventGraph enabled,
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        checkArgument(changed == rel,
                "misdirected knowledge propagation from relation %s to %s", changed, this);
        long t0 = System.currentTimeMillis();
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis.Knowledge knowledge = knowledgeMap.get(rel);
        EventGraph may = knowledge.getMaySet();
        EventGraph newDisabled = new EventGraph();
        enabled.apply((e1, e2) -> {
            if (may.contains(e2, e1)) {
                newDisabled.add(e2, e1);
            }
        });
        Map<Event, List<Event>> mustIn = new HashMap<>();
        Map<Event, List<Event>> mustOut = new HashMap<>();
        knowledge.getMustSet().apply((e1, e2) -> {
            if (!Tuple.isLoop(e1, e2)) {
                mustIn.computeIfAbsent(e2, x -> new ArrayList<>()).add(e1);
                mustOut.computeIfAbsent(e1, x -> new ArrayList<>()).add(e2);
            }
        });

        EventGraph current = enabled;
        while (true) {
            EventGraph next = new EventGraph();
            current.apply((x, y) -> {
                if (!Tuple.isLoop(x, y)) {
                    boolean implies = exec.isImplied(x, y);
                    boolean implied = exec.isImplied(y, x);
                    for (Event w : mustIn.getOrDefault(x, List.of())) {
                        if (!implied && !exec.isImplied(w, x) || exec.areMutuallyExclusive(w, y)) {
                            continue;
                        }
                        if (newDisabled.add(y, w)) {
                            next.add(w, y);
                        }
                    }
                    for (Event z : mustOut.getOrDefault(y, List.of())) {
                        if (!implies && !exec.isImplied(z, y) || exec.areMutuallyExclusive(x, z)) {
                            continue;
                        }
                        if (newDisabled.add(z, x)) {
                            next.add(x, z);
                        }
                    }
                }
            });
            if (next.isEmpty()) {
                break;
            }
            current = next;
        }
        newDisabled.retainAll(knowledge.getMaySet());
        logger.debug("Disabled {} edges in {}ms", newDisabled.size(), System.currentTimeMillis() - t0);
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(newDisabled, EventGraph.empty()));
    }

    @Override
    protected EventGraph getEncodeGraph(Context analysisContext) {
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
        return difference(getEncodeGraph(exec, ra), k.getMustSet());
    }

    public int getEncodeGraphSize(Context analysisContext) {
        return getEncodeGraph(analysisContext).size();
    }

    private EventGraph getEncodeGraph(ExecutionAnalysis exec, RelationAnalysis ra) {
        logger.info("Computing encodeGraph for {}", this);
        // ====== Construct [Event -> Successor] mapping ======
        EventGraph maySet = ra.getKnowledge(rel).getMaySet();
        Map<Event, Set<Event>> succMap = maySet.getOutMap();

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        final EventGraph result = new EventGraph();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            for (DependencyGraph<Event>.Node node1 : scc) {
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Event e1 = node1.getContent();
                    Event e2 = node2.getContent();
                    if (maySet.contains(e1, e2)) {
                        result.add(e1, e2);
                    }
                }
            }
        }

        logger.info("encodeGraph size: {}", result.size());
        if (getMemoryModel().getConfig().isReduceAcyclicityEncoding()) {
            EventGraph obsolete = transitivelyDerivableMustEdges(exec, ra.getKnowledge(rel));
            result.removeAll(obsolete);
            logger.info("reduced encodeGraph size: {}", result.size());
        }
        return result;
    }

    private void reduceWithMinSets(EventGraph encodeSet, ExecutionAnalysis exec, RelationAnalysis ra) {
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
        EventGraph crossEdges = k.getMustSet()
                .filter((e1, e2) -> Tuple.isCrossThread(e1, e2) && !e1.hasTag(Tag.INIT));

        logger.debug("cross-edges: {}", crossEdges.size());
        Map<Event, Set<Event>> transMinSet = new HashMap<>();
        k.getMustSet().apply((e1, e2) -> transMinSet.computeIfAbsent(e2, x -> new HashSet<>()).add(e1));
        Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
        Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
        crossEdges.apply((e1, e2) -> {
            List<Event> ingoing = new ArrayList<>();
            ingoing.add(e1); // ingoing events + self
            mustIn.getOrDefault(e1, Set.of()).forEach(e -> {
                if (exec.isImplied(e, e1)) {
                    ingoing.add(e);
                }
            });
            List<Event> outgoing = new ArrayList<>();
            outgoing.add(e2); // outgoing edges + self
            mustOut.getOrDefault(e2, Set.of()).forEach(e -> {
                if (exec.isImplied(e, e2)) {
                    outgoing.add(e);
                }
            });
            for (Event in : ingoing) {
                for (Event out : outgoing) {
                    transMinSet.computeIfAbsent(out, x -> new HashSet<>()).add(in);
                }
            }
        });

        // (2) Approximate reduction of transitive must-set: red(must(r)+).
        // Note: We reduce the transitive closure which may have more edges
        // that can be used to perform reduction
        // Approximative must-transitive reduction of minSet:
        EventGraph reduct = new EventGraph();
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
                    reduct.add(e1, e3);
                }
            }
        }

        // Remove (must(r)+ \ red(must(r)+)
        encodeSet.removeIf((e1, e2) -> transMinSet.getOrDefault(e2, Set.of()).contains(e1) && !reduct.contains(e1, e2));
    }

    @Override
    public List<BooleanFormula> consistent(EncodingContext context) {
        ExecutionAnalysis exec = context.getAnalysisContext().get(ExecutionAnalysis.class);
        RelationAnalysis ra = context.getAnalysisContext().get(RelationAnalysis.class);
        EventGraph toBeEncoded = getEncodeGraph(exec, ra);
        return negated ?
                inconsistentSAT(toBeEncoded, context) : // There is no IDL-based encoding for inconsistency
                context.usesSATEncoding() ?
                        consistentSAT(toBeEncoded, context) :
                        consistentIDL(toBeEncoded, context);
    }

    private List<BooleanFormula> inconsistentSAT(EventGraph toBeEncoded, EncodingContext context) {
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final Relation rel = this.rel;
        List<BooleanFormula> enc = new ArrayList<>();
        List<BooleanFormula> eventsInCycle = new ArrayList<>();
        Map<Event, List<BooleanFormula>> inMap = new HashMap<>();
        Map<Event, List<BooleanFormula>> outMap = new HashMap<>();
        toBeEncoded.apply((e1, e2) -> {
            BooleanFormula cycleVar = getSMTCycleVar(e1, e2, fmgr);
            inMap.computeIfAbsent(e2, k -> new ArrayList<>()).add(cycleVar);
            outMap.computeIfAbsent(e1, k -> new ArrayList<>()).add(cycleVar);
        });
        // We use Boolean variables which guess the edges and nodes constituting the cycle.
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        for (Event e : toBeEncoded.getDomain()) {
            eventsInCycle.add(cycleVar(e, fmgr));
            // We ensure that for every event in the cycle, there should be at least one incoming
            // edge and at least one outgoing edge that are also in the cycle.
            enc.add(bmgr.implication(cycleVar(e, fmgr), bmgr.and(bmgr.or(inMap.get(e)), bmgr.or(outMap.get(e)))));
            toBeEncoded.apply((e1, e2) ->
                // If an edge is guessed to be in a cycle, the edge must belong to relation,
                // and both events must also be guessed to be on the cycle.
                enc.add(bmgr.implication(getSMTCycleVar(e1, e2, fmgr),
                        bmgr.and(edge.encode(e1, e2), cycleVar(e1, fmgr), cycleVar(e2, fmgr)))));
        }
        // A cycle exists if there is an event in the cycle.
        enc.add(bmgr.or(eventsInCycle));
        return enc;
    }

    private List<BooleanFormula> consistentIDL(EventGraph toBeEncoded, EncodingContext context) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
        final Relation rel = this.rel;
        final String clockVarName = rel.getNameOrTerm();
        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        toBeEncoded.apply((e1, e2) ->
            enc.add(bmgr.implication(edge.encode(e1, e2),
                    imgr.lessThan(
                            context.clockVariable(clockVarName, e1),
                            context.clockVariable(clockVarName,e2))))
        );
        return enc;
    }

    private List<BooleanFormula> consistentSAT(EventGraph toBeEncoded, EncodingContext context) {
        // We use a vertex-elimination graph based encoding.
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        final Relation rel = this.rel;

        // Build original graph G
        Map<Event, Set<Event>> inEdges = new HashMap<>();
        Map<Event, Set<Event>> outEdges = new HashMap<>();
        Set<Event> nodes = new HashSet<>();
        Set<Event> selfloops = new HashSet<>();         // Special treatment for self-loops
        toBeEncoded.apply((e1, e2) -> {
            if (Tuple.isLoop(e1, e2)) {
                selfloops.add(e1);
            } else {
                nodes.add(e1);
                nodes.add(e2);
                outEdges.computeIfAbsent(e1, key -> new HashSet<>()).add(e2);
                inEdges.computeIfAbsent(e2, key -> new HashSet<>()).add(e1);
            }
        });

        // Handle corner-cases where some node has no ingoing or outgoing edges
        for (Event node : nodes) {
            outEdges.putIfAbsent(node, new HashSet<>());
            inEdges.putIfAbsent(node, new HashSet<>());
        }

        // Build vertex elimination graph G*, by iteratively modifying G
        Map<Event, Set<Event>> vertEleInEdges = new HashMap<>();
        Map<Event, Set<Event>> vertEleOutEdges = new HashMap<>();
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
            final Set<Event> in = inEdges.remove(e);
            final Set<Event> out = outEdges.remove(e);
            in.forEach(x -> outEdges.get(x).remove(e));
            out.forEach(x -> inEdges.get(x).remove(e));
            // Create new edges due to elimination of e
            for (Event e1 : in) {
                for (Event e2 : out) {
                    if (e2 == e1 || exec.areMutuallyExclusive(e1, e2)) {
                        continue;
                    }
                    // Update next graph in the elimination sequence
                    inEdges.get(e2).add(e1);
                    outEdges.get(e1).add(e2);
                    // Update vertex elimination graph
                    vertEleOutEdges.get(e1).add(e2);
                    vertEleInEdges.get(e2).add(e1);
                    // Store constructed triangle
                    triangles.add(new Event[]{e1, e, e2});
                }
            }
        }

        // --- Create encoding ---
        final EventGraph minSet = ra.getKnowledge(rel).getMustSet();
        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = context.edge(rel);
        // Basic lifting
        toBeEncoded.apply((e1, e2) -> {
            BooleanFormula cond = minSet.contains(e1, e2) ? context.execution(e1, e2) : edge.encode(e1, e2);
            enc.add(bmgr.implication(cond, getSMTCycleVar(e1, e2, fmgr)));
        });

        // Encode triangle rules
        for (Event[] tri : triangles) {
            BooleanFormula cond = minSet.contains(tri[0], tri[2]) ?
                    context.execution(tri[0], tri[2])
                    : bmgr.and(getSMTCycleVar(tri[0], tri[1], fmgr), getSMTCycleVar(tri[1], tri[2], fmgr));
            enc.add(bmgr.implication(cond, getSMTCycleVar(tri[0], tri[2], fmgr)));
        }

        //  --- Encode inconsistent assignments ---
        // Handle self-loops
        for (Event e : selfloops) {
            enc.add(bmgr.not(edge.encode(e, e)));
        }
        // Handle remaining cycles
        for (int i = 0; i < varOrderings.size(); i++) {
            Event e1 = varOrderings.get(i);
            Set<Event> out = vertEleOutEdges.get(e1);
            for (Event e2: out) {
                if (varOrderings.indexOf(e2) > i && vertEleInEdges.get(e2).contains(e1)) {
                    BooleanFormula cond = minSet.contains(e1, e2) ? bmgr.makeTrue() : getSMTCycleVar(e1, e2, fmgr);
                    enc.add(bmgr.implication(cond, bmgr.not(getSMTCycleVar(e2, e1, fmgr))));
                }
            }
        }

        return enc;
    }

    private BooleanFormula cycleVar(Event event, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d", m.escape(getNameOrTerm()), event.getGlobalId()));
    }

    private BooleanFormula getSMTCycleVar(Event e1, Event e2, FormulaManager m) {
        return m.getBooleanFormulaManager().makeVariable(String.format("cycle %s %d %d", m.escape(getNameOrTerm()), e1.getGlobalId(), e2.getGlobalId()));
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAcyclicity(this);
    }
}