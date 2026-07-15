package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.function.Predicate;

public class AcyclicityPropagator extends AbstractUserPropagator {

    private final RelationAnalysis relationAnalysis;
    private final EncodingContext context;
    private final WmmEncoder wmmEncoder;
    private final List<Case> cases = new ArrayList<>();
    private final Map<BooleanFormula, Case> lit2Case = new HashMap<>();
    private final Domain<Event> domain;

    private int curLevel = 0;
    private long numChecks = 0;
    private boolean raisedConflict = false;

    // We use a "case" per acyclicity axiom we want to track
    private record Case(Acyclicity axiom, SimpleGraph graph,
                        BiMap<BooleanFormula, Edge> lit2Edge,
                        BiMap<Edge, BooleanFormula> edge2Lit)  {

        public Case(Acyclicity axiom) {
            this(axiom, HashBiMap.create());
        }

        private Case(Acyclicity axiom, BiMap<BooleanFormula, Edge> lit2Edge) {
            this(axiom, new SimpleGraph(), lit2Edge, lit2Edge.inverse());
        }
    }

    public AcyclicityPropagator(WmmEncoder wmmEncoder, EncodingContext ctx) {
        this.context = ctx;
        this.relationAnalysis = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        this.wmmEncoder = wmmEncoder;

        // Set up domain
        final List<Event> events = context.getTask().getProgram().getThreadEvents();
        this.domain = new GenericDomain<>(events);
        ensureCapacity(events.size());
    }

    public void registerAxiom(Acyclicity axiom) {
        if (cases.stream().anyMatch(c -> c.axiom() == axiom)) {
            return;
        }
        final Case c = new Case(axiom);
        c.graph.initializeToDomain(domain);
        cases.add(c);
    }

    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);

        backend.notifyOnKnownValue();

        for (Case c : cases) {
            final Acyclicity axiom = c.axiom();
            final Relation rel = axiom.getRelation();
            final EventGraph must = relationAnalysis.getKnowledge(rel).getMustSet();
            final EventGraph relevantSet = wmmEncoder.getRelevantSet(axiom);
            final SimpleGraph relationGraph = c.graph();

            relevantSet.apply((x, y) -> {
                final int idx = domain.getId(x);
                final int idy = domain.getId(y);
                if (must.contains(x, y)) {
                    // TODO: This is unsound unless the must-edges satisfy
                    //  (x,y) in must(r) /\ (y, z) in must(r) => (x, z) in must(r^+)
                    //  which is the case for SC
                    relationGraph.add(new Edge(idx, idy, 0, 0));
                } else if (relevantSet.contains(x, y)) {
                    final BooleanFormula edgeLit = context.edge(rel, x, y);
                    final Edge edge = new Edge(idx, idy, 0, 0);
                    c.lit2Edge.put(edgeLit, edge);
                    lit2Case.put(edgeLit, c);
                    backend.registerExpression(edgeLit);
                }
            });

        }
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (value) {
            final Case c = lit2Case.get(expr);
            final Edge edge = c.lit2Edge.get(expr);
            propagate(c, edge.withTime(curLevel));
            numChecks++;

            if (numChecks % 1000000 == 0) {
                System.out.println("numChecks: " + numChecks);
                printStatistic();
            }
        }
    }

    private void propagate(Case c, Edge edge) {
        if (raisedConflict) {
            return;
        }

        final SimpleGraph relationGraph = c.graph();
        final List<Edge> backPath = findShortestPath(c, edge.getSecond(), edge.getFirst());
        if (!backPath.isEmpty()) {
            List<BooleanFormula> reason = computePathReason(c, backPath);
            reason.add(c.edge2Lit.get(edge)); // Add edge to complete cycle
            trackReason(reason);
            getBackend().propagateConflict(reason.toArray(new BooleanFormula[0]));
            raisedConflict = true;
        } else {
            relationGraph.add(edge);
        }
    }

    @Override
    public void onPush() {
        curLevel++;
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        cases.forEach(c -> c.graph.backtrackTo(curLevel));
    }

    // -----
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

    private Edge[] ingoingMap = new Edge[0];
    private Edge[] outgoingMap = new Edge[0];

    public void ensureCapacity(int capacity) {
        if (capacity <= ingoingMap.length) {
            return;
        }

        ingoingMap = Arrays.copyOf(ingoingMap, capacity);
        outgoingMap = Arrays.copyOf(outgoingMap, capacity);
    }

    private List<Edge> findShortestPath(Case c, int start, int end) {
        Predicate<Edge> alwaysTrueFilter = (edge -> true);
        return findShortestPath(c, start, end, alwaysTrueFilter);
    }

    /*
        This uses a bidirectional BFS to find a shortest path.
        A <filter> can be provided to skip certain edges during the search.
     */
    private List<Edge> findShortestPath(Case c, int start, int end, Predicate<Edge> filter) {
        queueForward.clear();
        queueBackward.clear();

        Arrays.fill(ingoingMap, null);
        System.arraycopy(ingoingMap, 0, outgoingMap, 0, Math.min(ingoingMap.length, outgoingMap.length));

        queueForward.add(start);
        queueBackward.add(end);
        boolean found = false;
        boolean doForwardBFS = true;
        int cur = -1;
        final RelationGraph graph = c.graph();

        while (!found && (!queueForward.isEmpty() || !queueBackward.isEmpty())) {
            if (doForwardBFS) {
                // Forward BFS
                int curSize = queueForward.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.outEdges(queueForward.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }

                        cur = next.getSecond();

                        if (cur == end || outgoingMap[cur] != null) {
                            ingoingMap[cur] = next;
                            found = true;
                            break;
                        } else if (ingoingMap[cur] == null) {
                            ingoingMap[cur] = next;
                            queueForward.add(cur);
                        }
                    }
                }
                doForwardBFS = false;
            } else {
                // Backward BFS
                int curSize = queueBackward.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.inEdges(queueBackward.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }
                        cur = next.getFirst();

                        if (ingoingMap[cur] != null) {
                            outgoingMap[cur] = next;
                            found = true;
                            break;
                        } else if (outgoingMap[cur] == null) {
                            outgoingMap[cur] = next;
                            queueBackward.add(cur);
                        }
                    }
                }
                doForwardBFS = true;
            }
        }

        if (!found) {
            //theoryPropagate(c, start, end, ingoingMap, outgoingMap); // Test Code
            return Collections.emptyList();
        }

        LinkedList<Edge> path = new LinkedList<>();
        collectInPath(start, cur, path);
        collectOutPath(cur, end, path);
        return path;
    }

    // Test Code
    // TODO: This is inefficient
    private void theoryPropagate(Case c, int start, int end, Edge[] ingoingMap, Edge[] outgoingMap) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Map<List<BooleanFormula>, List<BooleanFormula>> implications = new HashMap<>();
        for (var entry : c.edge2Lit.entrySet()) {
            int id1 = entry.getKey().getFirst();
            int id2 = entry.getKey().getSecond();
            BooleanFormula edgeLit = entry.getValue();
            if (ingoingMap[id1] != null && outgoingMap[id2] != null) {
                final LinkedList<Edge> path = new LinkedList<>();
                collectInPath(start, id1, path);
                collectOutPath(id2, end, path);
                path.add(new Edge(end, start, 0, 0));
                final List<BooleanFormula> pathReason = computePathReason(c, path);
                implications.computeIfAbsent(pathReason, k -> new ArrayList<>()).add(bmgr.not(edgeLit));
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
            //getBackend().propagateConsequence(premise, bmgr.and(consequence));
            //System.out.printf("%s  =>  %s\n", premise, consequence);
        }
    }

    private void collectInPath(int source, int target, LinkedList<Edge> path) {
        int e = target;
        while (e != source) {
            Edge backEdge = ingoingMap[e];
            path.addLast(backEdge);
            e = backEdge.getFirst();
        }
    }

    private void collectOutPath(int source, int target, LinkedList<Edge> path) {
        int e = source;
        while (e != target) {
            Edge forwardEdge = outgoingMap[e];
            path.addFirst(forwardEdge);
            e = forwardEdge.getSecond();
        }
    }

    private List<BooleanFormula> computePathReason(Case c, List<Edge> path) {
        List<BooleanFormula> reason = new ArrayList<>();
        for (Edge e : path) {
            final BooleanFormula lit = c.edge2Lit.get(e);
            if (lit != null) {
                reason.add(lit);
            }
        }
        return reason;
    }


}
