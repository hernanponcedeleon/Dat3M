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

public class AcyclicityPropagatorNew extends AbstractUserPropagator {

    private static final boolean enableTheoryPropagation = true;
    // Might weaken propagation/learning if set to true?
    private static final boolean stopOnConflict = false;
    // If set to true, we can propagate the same edge twice but with different reasons
    private static final boolean allowDuplicatePropagation = false;

    private final RelationAnalysis relationAnalysis;
    private final EncodingContext context;
    private final WmmEncoder wmmEncoder;
    private final List<Case> cases = new ArrayList<>();
    private final Map<BooleanFormula, Case> lit2Case = new HashMap<>();
    private final IndexedDomain<Event> domain;

    // -------- Dynamic search data --------
    private int curLevel = 0;
    private boolean raisedConflict = false;

    private final Queue<Integer> workqueue = new ArrayDeque<>(); // Used for BFS
    private final VarGraph.Edge[] ingoingMap; // Spanning tree for forward search
    private final VarGraph.Edge[] outgoingMap; // Spanning tree for backward search

    // TODO: Evaluate the need for this.
    // Track already-made propagations to avoid redundant propagation
    private Set<VarGraph.Edge> alreadyPropagatedEdges;

    // -------- Misc --------
    // Used to cheaply associate data with BooleanFormulas
    private CachingFormulaMap<FormulaData> formulaLookup;

    // -------- Statistics --------
    private final Map<Set<BooleanFormula>, Integer> observedReasons = new HashMap<>();
    private int numPropagations = 0;
    private long numChecks = 0;


    public AcyclicityPropagatorNew(WmmEncoder wmmEncoder, EncodingContext ctx) {
        this.context = ctx;
        this.relationAnalysis = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        this.wmmEncoder = wmmEncoder;

        this.domain = ctx.getAnalysisContext().requires(EventDomainRepository.class)
                .getDomain(EventDomainRepository.DomainBound.VISIBLE);
        ingoingMap = new VarGraph.Edge[domain.size()];
        outgoingMap = new VarGraph.Edge[domain.size()];
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
                } else {
                    final BooleanFormula edgeLit = context.edge(rel, x, y);
                    lit2Case.put(edgeLit, c);
                    graph.addVarEdge(idx, idy, edgeLit);
                    backend.registerExpression(edgeLit);
                    numDynamicEdges.getAndIncrement();
                }
            });
        }

        formulaLookup = new CachingFormulaMap<>(numDynamicEdges.get() * 2, key-> {
            final VarGraph graph = lit2Case.get(key).graph();
            final VarGraph.Edge edge = graph.getEdge(key);
            return new FormulaData(graph, edge);
        });
        alreadyPropagatedEdges = Collections.newSetFromMap(new IdentityHashMap<>(numDynamicEdges.get()));
    }

    @Override
    public void onPush() {
        curLevel++;
        cases.forEach(c -> c.graph.push());
        // System.out.println("------- Push: " + curLevel + " -------");
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        cases.forEach(c -> c.graph.pop(numPoppedLevels));
        alreadyPropagatedEdges.clear();
        // System.out.println("------- Pop to: " + curLevel + " -------");
    }


    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (raisedConflict && stopOnConflict) {
            // We have a pending conflict
            // System.out.println("Already conflict; skip " + expr);
            return;
        }

        final FormulaData data = formulaLookup.get(expr);
        final VarGraph graph = data.graph();
        final VarGraph.Edge edge = data.edge();
        graph.assignEdge(edge, value);

        if (value) {
            if (alreadyPropagatedEdges.contains(edge)) {
                raisedConflict = true;
                // System.out.println("Propagation conflict");
                return;
            }
            processEdgeAddition(graph, edge);

            numChecks++;
            if (numChecks % 1000000 == 0) {
                System.out.println("numChecks: " + numChecks);
                printStatistics();
            }
        }
    }

    // Checks for cycles caused by adding <edge> and possibly raises a conflict.
    // If no conflict is raised, tries to do theory propagation
    private void processEdgeAddition(VarGraph graph, VarGraph.Edge edge) {

        if (forwardBfsSearch(graph, edge, ingoingMap)) {
            // We found a cycle
            final List<BooleanFormula> conflict = computeCycleReason(edge, ingoingMap);
            trackReason(conflict);
            getBackend().propagateConflict(conflict.toArray(new BooleanFormula[0]));
            raisedConflict = true;
        } else if (enableTheoryPropagation) {
            backwardBfsPropagate(graph, edge, ingoingMap);
        }
    }

    private List<BooleanFormula> computeCycleReason(VarGraph.Edge edge, VarGraph.Edge[] ingoingMap) {
        // Collect reason backwards
        final List<BooleanFormula> conflict = new ArrayList<>();
        int cur = edge.getSource();
        VarGraph.Edge curEdge;
        do {
            curEdge = ingoingMap[cur];
            if (!curEdge.isMust()) {
                conflict.add(curEdge.getEdgeVar());
            }
            cur = curEdge.getSource();
        } while (curEdge != edge);

        return conflict;
    }

    // ==========================================================================


    private boolean forwardBfsSearch(VarGraph graph, VarGraph.Edge addedEdge, VarGraph.Edge[] ingoingMap) {
        Arrays.fill(ingoingMap, null);
        workqueue.clear();
        workqueue.add(addedEdge.getTarget());

        final int target = addedEdge.getSource();
        ingoingMap[addedEdge.getTarget()] = addedEdge;

        do {
            // Forward BFS
            for (VarGraph.Edge outEdge : graph.getTrueOutEdges(workqueue.poll())) {
                final int next = outEdge.getTarget();
                if (next == target) {
                    // Found cycle
                    ingoingMap[next] = outEdge;
                    return true;
                } else if (ingoingMap[next] == null) {
                    ingoingMap[next] = outEdge;
                    workqueue.add(next);
                }
            }
        } while (!workqueue.isEmpty());

        // No cycle found
        return false;
    }

    // ------------------------------------------------------------------------------------
    // Theory propagation

    private void backwardBfsPropagate(VarGraph graph, VarGraph.Edge addedEdge, VarGraph.Edge[] ingoingMap) {
        Arrays.fill(outgoingMap, null);
        workqueue.clear();
        workqueue.add(addedEdge.getSource());

        // Do backward BFS to collect disabled edges
        final List<VarGraph.Edge> disabledEdgesToPropagate = new ArrayList<>();
        do {
            for (VarGraph.Edge inEdge : graph.getInEdges(workqueue.poll())) {
                if (inEdge.isFalse()) {
                    continue;
                }

                final int next = inEdge.getSource();
                if (ingoingMap[next] != null && (allowDuplicatePropagation || !alreadyPropagatedEdges.contains(inEdge))) {
                    assert inEdge.isUnassigned();
                    disabledEdgesToPropagate.add(inEdge);
                    /*if ( !alreadyPropagatedEdges.contains(inEdge)) {
                        System.out.println("New prop reason for: " + inEdge);
                    }*/
                } else if (inEdge.isTrue() && outgoingMap[next] == null) {
                    outgoingMap[next] = inEdge;
                    workqueue.add(next);
                }
            }
        } while (!workqueue.isEmpty());

        // Propagate disabled edges
        propagateDisabledEdges(disabledEdgesToPropagate, ingoingMap, outgoingMap);
    }

    private void propagateDisabledEdges(List<VarGraph.Edge> disabledEdgesToPropagate, VarGraph.Edge[] ingoingMap, VarGraph.Edge[] outgoingMap) {
        for (var edge : disabledEdgesToPropagate) {
            assert edge.isUnassigned();
            final List<BooleanFormula> reason = new ArrayList<>();

            // Collect reason backwards
            int cur = edge.getSource();
            VarGraph.Edge curEdge;
            while ((curEdge = ingoingMap[cur]) != null) {
                if (!curEdge.isMust()) {
                    reason.add(curEdge.getEdgeVar());
                }
                cur = curEdge.getSource();
            }

            final int target = cur;

            // Collect reason forwards
            cur = edge.getTarget();
            while (cur != target) {
                curEdge = outgoingMap[cur];
                if (!curEdge.isMust()) {
                    reason.add(curEdge.getEdgeVar());
                }
                cur = curEdge.getTarget();
            }

            // Propagate
            assert !reason.isEmpty();
            final BooleanFormula[] propReason = reason.toArray(new BooleanFormula[0]);
            getBackend().propagateConsequence(propReason, edge.getNegEdgeVar());
            numPropagations++;
            alreadyPropagatedEdges.add(edge);

        }
    }

    // ---------------------------------------- Statistics ----------------------------------------

    private void trackReason(List<BooleanFormula> reason) {
        observedReasons.compute(new HashSet<>(reason), (k, v) -> v == null ? 1 : v + 1);
    }

    public void printStatistics() {
        int uniqueReasons = observedReasons.size();
        int totalReasons = observedReasons.values().stream().mapToInt(v -> v).sum();
        int maxDuplicate = observedReasons.values().stream().mapToInt(v -> v).max().orElse(0);
        System.out.println("total: " + totalReasons + " ### unique: " + uniqueReasons + " ### maxDup: " + maxDuplicate);
        System.out.println("numPropagations: " + numPropagations);
    }


    // ===================================== Helper classes ====================================

    // We use a "case" per acyclicity axiom we want to track
    private record Case(Acyclicity axiom, VarGraph graph) { }

    private record FormulaData(VarGraph graph, VarGraph.Edge edge) { }


    // TODO: Test code to minimize hashtable lookup times with BooleanFormula
    //  The IdentityHashMap is used to avoid expensive .equals calls on BooleanFormula
    //  We need to populate the map in onKnownValue because only there we get
    //  canonical instances for BooleanFormula that can be compared by identity.
    private static class CachingFormulaMap<TData> {
        private final IdentityHashMap<BooleanFormula, TData> formulaLookup;
        private final Function<BooleanFormula, TData> dataConstructor;

        public CachingFormulaMap(int expectedMaxSize, Function<BooleanFormula, TData> dataConstructor) {
            this.formulaLookup = new IdentityHashMap<>(expectedMaxSize);
            this.dataConstructor = dataConstructor;
        }

        public TData get(BooleanFormula formula) {
            return formulaLookup.computeIfAbsent(formula, dataConstructor);
        }
    }

}