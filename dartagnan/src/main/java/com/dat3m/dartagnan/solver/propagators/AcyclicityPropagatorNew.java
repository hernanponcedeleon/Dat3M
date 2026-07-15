package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;
import java.util.function.Predicate;

public class AcyclicityPropagatorNew extends AbstractUserPropagator {

    private static final boolean enableTheoryPropagation = false;

    private final RelationAnalysis relationAnalysis;
    private final EncodingContext context;
    private final WmmEncoder wmmEncoder;
    private final List<Case> cases = new ArrayList<>();
    private final Map<BooleanFormula, Case> lit2Case = new HashMap<>();
    private final IndexedDomain<Event> domain;

    private int curLevel = 0;
    private long numChecks = 0;
    private boolean raisedConflict = false;

    // We use a "case" per acyclicity axiom we want to track
    private record Case(Acyclicity axiom, VarGraph graph)  {
    }

    public AcyclicityPropagatorNew(WmmEncoder wmmEncoder, EncodingContext ctx) {
        this.context = ctx;
        this.relationAnalysis = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        this.wmmEncoder = wmmEncoder;

        this.domain = ctx.getAnalysisContext().requires(EventDomainRepository.class)
                .getDomain(EventDomainRepository.DomainBound.VISIBLE);
        ensureCapacity(domain.size());
    }

    public void registerAxiom(Acyclicity axiom) {
        if (cases.stream().anyMatch(c -> c.axiom() == axiom)) {
            return;
        }
        final Case c = new Case(axiom, new VarGraph(domain.size(), context.getBooleanFormulaManager()));
        cases.add(c);
    }

    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);

        backend.notifyOnKnownValue();

        AtomicInteger numDynamicEdges = new AtomicInteger();
        for (Case c : cases) {
            final Acyclicity axiom = c.axiom();
            final Relation rel = axiom.getRelation();
            final EventGraph must = relationAnalysis.getKnowledge(rel).getMustSet();
            final EventGraph relevantSet = wmmEncoder.getRelevantSet(axiom);
            final VarGraph graph = c.graph();

            relevantSet.apply((x, y) -> {
                final int idx = domain.indexOf(x);
                final int idy = domain.indexOf(y);
                if (must.contains(x, y)) {
                    // TODO: This is unsound unless the must-edges satisfy
                    //  (x,y) in must(r) /\ (y, z) in must(r) => (x, z) in must(r^+)
                    //  which is the case for SC
                    graph.addMustEdge(idx, idy);
                } else if (relevantSet.contains(x, y)) {
                    final BooleanFormula edgeLit = context.edge(rel, x, y);
                    lit2Case.put(edgeLit, c);
                    graph.addVarEdge(idx, idy, edgeLit);
                    backend.registerExpression(edgeLit);
                    numDynamicEdges.getAndIncrement();
                }
            });
        }

        customEdges = new IdentityHashMap<>(numDynamicEdges.get() * 2);

    }

    // TODO: Test code to minimize hashtable lookup times with BooleanFormula
    //  The IdentityHashMap is used to avoid expensive .equals calls on BooleanFormula
    //  We need to populate the map in onKnownValue because only there we get
    //  canonical instances for BooleanFormula that can be compared by identity.
    private record LookupData(VarGraph graph, VarGraph.Edge edge) {}
    private IdentityHashMap<BooleanFormula, LookupData> customEdges;
    private final Function<BooleanFormula, LookupData> lookupFunction = key -> {
        final VarGraph graph = lit2Case.get(key).graph();
        final VarGraph.Edge edge = graph.getEdge(key);
        return new LookupData(graph, edge);
    };

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        final LookupData lookup = customEdges.computeIfAbsent(expr, lookupFunction);

        final VarGraph graph = lookup.graph();
        final VarGraph.Edge edge = lookup.edge();
        graph.assignEdge(edge, value);


        if (value) {
            //System.out.println("Enabled: " + expr);
            propagate(graph, edge);
            if (!raisedConflict && enableTheoryPropagation) {
                theoryPropagate(graph, edge, ingoingMap, outgoingMap);
            }
            numChecks++;

            if (numChecks % 1000000 == 0) {
                System.out.println("numChecks: " + numChecks);
                printStatistic();
            }
        }
    }

    private void propagate(VarGraph graph, VarGraph.Edge edge) {
        if (raisedConflict) {
            return;
        }

        final List<VarGraph.Edge> backPath = findShortestPath(graph, edge.getTarget(), edge.getSource());
        if (!backPath.isEmpty()) {
            List<BooleanFormula> reason = computePathReason(backPath);
            //System.out.printf("Conflict: %s -> not %s\n", reason, edge.getEdgeVar());
            reason.add(edge.getEdgeVar()); // Add edge to complete cycle
            trackReason(reason);
            getBackend().propagateConflict(reason.toArray(new BooleanFormula[0]));
            raisedConflict = true;
        }
    }

    @Override
    public void onPush() {
        curLevel++;
        cases.forEach(c -> c.graph.push());
        //System.out.println("------- Push: " + curLevel + "-------");
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        cases.forEach(c -> c.graph.pop(numPoppedLevels));

        //System.out.println("------- Pop to: " + curLevel + "-------");
    }

    // ---------------------------------------- Statistics ----------------------------------------
    private Map<Set<BooleanFormula>, Integer> observedReasons = new HashMap<>();
    private int numPropagations = 0;

    private void trackReason(List<BooleanFormula> reason) {
        observedReasons.compute(new HashSet<>(reason), (k, v) -> v == null ? 1 : v + 1);
    }

    public void printStatistic() {
        int uniqueReasons = observedReasons.size();
        int totalReasons = observedReasons.values().stream().mapToInt(v -> v).sum();
        int maxDuplicate = observedReasons.values().stream().mapToInt(v -> v).max().orElse(0);
        System.out.println("total: " + totalReasons + " ### unique: " + uniqueReasons + " ### maxDup: " + maxDuplicate);
        System.out.println("numPropagations: " + numPropagations);
    }


    // ==========================================================================

    //TODO: This code is copied from PathAlgorithms and can surely be improved
    private final Queue<Integer> queueForward = new ArrayDeque<>();
    private final Queue<Integer> queueBackward = new ArrayDeque<>();

    private VarGraph.Edge[] ingoingMap = new VarGraph.Edge[0];
    private VarGraph.Edge[] outgoingMap = new VarGraph.Edge[0];

    public void ensureCapacity(int capacity) {
        if (capacity <= ingoingMap.length) {
            return;
        }

        ingoingMap = Arrays.copyOf(ingoingMap, capacity);
        outgoingMap = Arrays.copyOf(outgoingMap, capacity);
    }

    private List<VarGraph.Edge> findShortestPath(VarGraph graph, int start, int end) {
        Predicate<VarGraph.Edge> alwaysTrueFilter = (edge -> true);
        return findShortestPath(graph, start, end, alwaysTrueFilter);
    }

    /*
        This uses a bidirectional BFS to find a shortest path.
        A <filter> can be provided to skip certain edges during the search.
     */
    private List<VarGraph.Edge> findShortestPath(VarGraph graph, int start, int end, Predicate<VarGraph.Edge> filter) {

        Arrays.fill(ingoingMap, null);
        System.arraycopy(ingoingMap, 0, outgoingMap, 0, Math.min(ingoingMap.length, outgoingMap.length));

        queueForward.clear();
        queueForward.add(start);
        queueBackward.clear();
        queueBackward.add(end);

        boolean found = false;
        boolean doForwardBFS = true;
        int cur = -1;

        while (!found && (!queueForward.isEmpty() || !queueBackward.isEmpty())) {
            if (doForwardBFS) {
                // Forward BFS
                int curSize = queueForward.size();
                while (curSize-- > 0 && !found) {
                    for (VarGraph.Edge outEdge : graph.getTrueOutEdges(queueForward.poll())) {
                        if (!filter.test(outEdge)) {
                            continue;
                        }

                        cur = outEdge.getTarget();

                        if (cur == end || outgoingMap[cur] != null) {
                            ingoingMap[cur] = outEdge;
                            found = true;
                            break;
                        } else if (ingoingMap[cur] == null) {
                            ingoingMap[cur] = outEdge;
                            queueForward.add(cur);
                        }
                    }
                }
                doForwardBFS = false;
            } else {
                // Backward BFS
                int curSize = queueBackward.size();
                while (curSize-- > 0 && !found) {
                    for (VarGraph.Edge inEdge : graph.getTrueInEdges(queueBackward.poll())) {
                        if (!filter.test(inEdge)) {
                            continue;
                        }
                        cur = inEdge.getSource();

                        if (ingoingMap[cur] != null) {
                            outgoingMap[cur] = inEdge;
                            found = true;
                            break;
                        } else if (outgoingMap[cur] == null) {
                            outgoingMap[cur] = inEdge;
                            queueBackward.add(cur);
                        }
                    }
                }
                doForwardBFS = true;
            }
        }

        if (!found) {
            return Collections.emptyList();
        }

        LinkedList<VarGraph.Edge> path = new LinkedList<>();
        collectInPath(start, cur, path);
        collectOutPath(cur, end, path);
        return path;
    }

    private void collectInPath(int source, int target, LinkedList<VarGraph.Edge> path) {
        int e = target;
        while (e != source) {
            VarGraph.Edge backEdge = ingoingMap[e];
            path.addLast(backEdge);
            e = backEdge.getSource();
        }
    }

    private void collectOutPath(int source, int target, LinkedList<VarGraph.Edge> path) {
        int e = source;
        while (e != target) {
            VarGraph.Edge forwardEdge = outgoingMap[e];
            path.addFirst(forwardEdge);
            e = forwardEdge.getTarget();
        }
    }

    private List<BooleanFormula> computePathReason(List<VarGraph.Edge> path) {
        List<BooleanFormula> reason = new ArrayList<>();
        for (VarGraph.Edge e : path) {
            if (!e.isMust()) {
                reason.add(e.getEdgeVar());
            }
        }
        return reason;
    }


    // Test Code
    // TODO: This is inefficient
    // TODO: This does not find all possible propagation. It seems RA/ActiveSet does not exclude all trivial violations
    private void theoryPropagate(VarGraph graph, VarGraph.Edge enabledEdge, VarGraph.Edge[] ingoingMap, VarGraph.Edge[] outgoingMap) {
        final Map<List<BooleanFormula>, List<BooleanFormula>> implications = new HashMap<>();
        for (var edge : graph.getUnassignedEdges()) {
            int id1 = edge.getSource();
            int id2 = edge.getTarget();
            if ((id1 == enabledEdge.getTarget() || ingoingMap[id1] != null) && (id2 == enabledEdge.getSource() || outgoingMap[id2] != null)) {
                final LinkedList<VarGraph.Edge> path = new LinkedList<>();
                collectInPath(enabledEdge.getTarget(), id1, path);
                collectOutPath(id2, enabledEdge.getSource(), path);
                final List<BooleanFormula> pathReason = computePathReason(path);
                pathReason.add(enabledEdge.getEdgeVar());
                implications.computeIfAbsent(pathReason, k -> new ArrayList<>()).add(edge.getNegEdgeVar());
                numPropagations++;

                //System.out.printf("%s  =>  not %s\n", Arrays.toString(pathReason), edgeLit);
            }
        }

        for (var entry : implications.entrySet()) {
            BooleanFormula[] premise = entry.getKey().toArray(new BooleanFormula[0]);
            List<BooleanFormula> consequence = entry.getValue();

            for (BooleanFormula con : consequence) {
                getBackend().propagateConsequence(premise, con);
            }
            //System.out.printf("Prop %s  =>  %s\n", Arrays.toString(premise), consequence);
        }
    }


}
