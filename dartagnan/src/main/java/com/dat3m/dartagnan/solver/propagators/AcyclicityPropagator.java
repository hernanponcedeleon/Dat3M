package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.function.Function;

/*
    Propagator for axioms of the form acyclic(r), i.e., irreflexive(r^+).

    Edges of r come in two flavours:
      - Var-edges: (x, y) in may(r) \ must(r). Their presence is given by the edge literal r(x, y).
      - Must-edges: (x, y) in must(r). These are NOT unconditionally present: must(r) only guarantees
        exec(x) /\ exec(y) => r(x, y). Hence, a must-edge is only enabled once the execution literals of
        its endpoints are known to be true, and those literals are part of every reason that uses the edge.
        Treating must-edges as always present is only sound if must(r);must(r) is contained in must(r^+)
        (e.g. for po under SC), but not for general memory models: a cycle could go through an event that
        does not execute.
 */
public class AcyclicityPropagator extends AbstractUserPropagator {

    private static final boolean enableTheoryPropagation = true;
    // Might weaken propagation/learning if set to true?
    private static final boolean stopOnConflict = false;
    // If set to true, we can propagate the same edge twice but with different reasons
    private static final boolean allowDuplicatePropagation = false;

    private static final int TRUE = VarGraph.TRUE;
    private static final int UNASSIGNED = VarGraph.UNASSIGNED;
    private static final int FALSE = VarGraph.FALSE;

    private final RelationAnalysis relationAnalysis;
    private final ExecutionAnalysis executionAnalysis;
    private final EncodingContext context;
    private final BooleanFormulaManager bmgr;
    private final WmmEncoder wmmEncoder;
    private final List<Case> cases = new ArrayList<>();
    private final Map<BooleanFormula, Case> lit2Case = new HashMap<>();
    private final IndexedDomain<Event> domain;

    // -------- Execution literals (enabling must-edges) --------
    private final Map<BooleanFormula, Integer> execLit2Id = new HashMap<>();
    private final List<BooleanFormula> execLits = new ArrayList<>();
    private final List<BooleanFormula> negExecLits = new ArrayList<>();
    private final List<List<Watcher>> execLitWatchers = new ArrayList<>(); // Must-edges enabled by the literal
    private int[] execLitValues;
    private int[] execLitStamps; // Used to avoid duplicate literals in reasons
    private int curStamp = 0;
    private final List<Integer> execTrail = new ArrayList<>();
    private final List<Integer> execBacktrackPoints = new ArrayList<>();

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
    private CachingFormulaMap<LitData> formulaLookup;

    // -------- Statistics --------
    private final Map<Set<BooleanFormula>, Integer> observedReasons = new HashMap<>();
    private int numPropagations = 0;
    private long numChecks = 0;


    public AcyclicityPropagator(WmmEncoder wmmEncoder, EncodingContext ctx) {
        this.context = ctx;
        this.bmgr = ctx.getBooleanFormulaManager();
        this.relationAnalysis = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        this.executionAnalysis = ctx.getAnalysisContext().requires(ExecutionAnalysis.class);
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

        int numDynamicEdges = 0;
        for (Case c : cases) {
            final Acyclicity axiom = c.axiom();
            final Relation rel = axiom.getRelation();
            final EventGraph must = relationAnalysis.getKnowledge(rel).getMustSet();
            final EventGraph relevantSet = wmmEncoder.getRelevantSet(axiom);
            final VarGraph graph = c.graph();

            for (Event x : relevantSet.getDomain()) {
                for (Event y : relevantSet.getRange(x)) {
                    final int idx = domain.indexOf(x);
                    final int idy = domain.indexOf(y);
                    if (must.contains(x, y)) {
                        final VarGraph.Edge edge = graph.addMustEdge(idx, idy, getExecLitIds(x, y));
                        for (int litId : edge.getExecLitIds()) {
                            execLitWatchers.get(litId).add(new Watcher(graph, edge));
                        }
                    } else {
                        final BooleanFormula edgeLit = context.edge(rel, x, y);
                        lit2Case.put(edgeLit, c);
                        graph.addVarEdge(idx, idy, edgeLit);
                        backend.registerExpression(edgeLit);
                        numDynamicEdges++;
                    }
                }
            }
        }

        execLitValues = new int[execLits.size()];
        execLitStamps = new int[execLits.size()];
        execLits.forEach(backend::registerExpression);

        formulaLookup = new CachingFormulaMap<>((numDynamicEdges + execLits.size()) * 2, key -> {
            final Case c = lit2Case.get(key);
            if (c != null) {
                return new EdgeLitData(c.graph(), c.graph().getEdge(key));
            }
            final Integer litId = execLit2Id.get(key);
            Preconditions.checkState(litId != null, "Unknown literal %s", key);
            return new ExecLitData(litId);
        });
        alreadyPropagatedEdges = Collections.newSetFromMap(new IdentityHashMap<>(numDynamicEdges));
    }

    // Returns the ids of a minimal set of execution literals implying exec(x) /\ exec(y).
    // This mirrors EncodingContext.execution(x, y), which is how must-edges are encoded.
    private int[] getExecLitIds(Event x, Event y) {
        final boolean b = x.getGlobalId() < y.getGlobalId();
        final Event first = b ? x : y;
        final Event second = b ? y : x;
        if (executionAnalysis.isImplied(first, second)) {
            return new int[] { getOrCreateExecLitId(first) };
        }
        if (executionAnalysis.isImplied(second, first)) {
            return new int[] { getOrCreateExecLitId(second) };
        }
        final int id1 = getOrCreateExecLitId(first);
        final int id2 = getOrCreateExecLitId(second);
        return id1 == id2 ? new int[] { id1 } : new int[] { id1, id2 };
    }

    private int getOrCreateExecLitId(Event e) {
        final BooleanFormula lit = context.execution(e);
        Preconditions.checkState(lit != null, "No execution literal for event %s", e);
        return execLit2Id.computeIfAbsent(lit, k -> {
            final int id = execLits.size();
            execLits.add(k);
            negExecLits.add(bmgr.not(k));
            execLitWatchers.add(new ArrayList<>());
            return id;
        });
    }

    @Override
    public void onPush() {
        curLevel++;
        cases.forEach(c -> c.graph.push());
        execBacktrackPoints.add(execTrail.size());
        // System.out.println("------- Push: " + curLevel + " -------");
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        cases.forEach(c -> c.graph.pop(numPoppedLevels));

        final int backtrackPoint = execBacktrackPoints.get(curLevel);
        execBacktrackPoints.subList(curLevel, execBacktrackPoints.size()).clear();
        final List<Integer> undone = execTrail.subList(backtrackPoint, execTrail.size());
        undone.forEach(id -> execLitValues[id] = UNASSIGNED);
        undone.clear();

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

        switch (formulaLookup.get(expr)) {
            case EdgeLitData(VarGraph graph, VarGraph.Edge edge) -> onEdgeAssignment(graph, edge, value);
            case ExecLitData(int litId) -> onExecLitAssignment(litId, value);
        }
    }

    private void onEdgeAssignment(VarGraph graph, VarGraph.Edge edge, boolean value) {
        graph.assignEdge(edge, value);

        if (value) {
            if (alreadyPropagatedEdges.contains(edge)) {
                raisedConflict = true;
                // System.out.println("Propagation conflict");
                return;
            }
            processEdgeAddition(graph, edge);
            trackCheck();
        }
    }

    private void onExecLitAssignment(int litId, boolean value) {
        assert execLitValues[litId] == UNASSIGNED;
        execLitValues[litId] = value ? TRUE : FALSE;
        execTrail.add(litId);

        if (!value) {
            return;
        }

        // First enable all must-edges whose execution condition became true, then check them for cycles.
        final List<Watcher> enabledEdges = new ArrayList<>();
        for (Watcher w : execLitWatchers.get(litId)) {
            final VarGraph.Edge edge = w.edge();
            if (edge.isUnassigned() && allExecLitsTrue(edge)) {
                w.graph().assignEdge(edge, true);
                enabledEdges.add(w);
            }
        }

        for (Watcher w : enabledEdges) {
            if (raisedConflict && stopOnConflict) {
                return;
            }
            if (alreadyPropagatedEdges.contains(w.edge())) {
                raisedConflict = true;
                continue;
            }
            processEdgeAddition(w.graph(), w.edge());
            trackCheck();
        }
    }

    private boolean allExecLitsTrue(VarGraph.Edge mustEdge) {
        for (int litId : mustEdge.getExecLitIds()) {
            if (execLitValues[litId] != TRUE) {
                return false;
            }
        }
        return true;
    }

    private void trackCheck() {
        numChecks++;
        if (numChecks % 1000000 == 0) {
            System.out.println("numChecks: " + numChecks);
            printStatistics();
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
        curStamp++;
        int cur = edge.getSource();
        VarGraph.Edge curEdge;
        do {
            curEdge = ingoingMap[cur];
            addEdgeReason(curEdge, conflict);
            cur = curEdge.getSource();
        } while (curEdge != edge);

        return conflict;
    }

    // Adds the literals that justify the presence of <edge> to <reason>.
    // Callers must increment <curStamp> once per reason to deduplicate execution literals.
    private void addEdgeReason(VarGraph.Edge edge, List<BooleanFormula> reason) {
        assert edge.isTrue();
        if (edge.isMust()) {
            for (int litId : edge.getExecLitIds()) {
                addExecLitReason(litId, reason);
            }
        } else {
            reason.add(edge.getEdgeVar());
        }
    }

    private void addExecLitReason(int litId, List<BooleanFormula> reason) {
        assert execLitValues[litId] == TRUE;
        if (execLitStamps[litId] != curStamp) {
            execLitStamps[litId] = curStamp;
            reason.add(execLits.get(litId));
        }
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
                if (ingoingMap[next] != null) {
                    // <inEdge> would close a cycle
                    assert inEdge.isUnassigned();
                    if ((allowDuplicatePropagation || !alreadyPropagatedEdges.contains(inEdge))
                            && (!inEdge.isMust() || getSingleUnassignedExecLit(inEdge) != -1)) {
                        disabledEdgesToPropagate.add(inEdge);
                    }
                } else if (inEdge.isTrue() && outgoingMap[next] == null) {
                    outgoingMap[next] = inEdge;
                    workqueue.add(next);
                }
            }
        } while (!workqueue.isEmpty());

        // Propagate disabled edges
        propagateDisabledEdges(disabledEdgesToPropagate, ingoingMap, outgoingMap);
    }

    // A must-edge can only be disabled by falsifying one of its execution literals.
    // We can propagate this only if exactly one of those literals is unassigned and all others are true.
    // Returns the id of that literal, or -1 if there is no such literal.
    private int getSingleUnassignedExecLit(VarGraph.Edge mustEdge) {
        int unassigned = -1;
        for (int litId : mustEdge.getExecLitIds()) {
            final int value = execLitValues[litId];
            if (value == FALSE || (value == UNASSIGNED && unassigned != -1)) {
                return -1;
            } else if (value == UNASSIGNED) {
                unassigned = litId;
            }
        }
        return unassigned;
    }

    private void propagateDisabledEdges(List<VarGraph.Edge> disabledEdgesToPropagate, VarGraph.Edge[] ingoingMap, VarGraph.Edge[] outgoingMap) {
        for (var edge : disabledEdgesToPropagate) {
            assert edge.isUnassigned();
            final List<BooleanFormula> reason = new ArrayList<>();
            curStamp++;

            // Collect reason backwards
            int cur = edge.getSource();
            VarGraph.Edge curEdge;
            while ((curEdge = ingoingMap[cur]) != null) {
                addEdgeReason(curEdge, reason);
                cur = curEdge.getSource();
            }

            final int target = cur;

            // Collect reason forwards
            cur = edge.getTarget();
            while (cur != target) {
                curEdge = outgoingMap[cur];
                addEdgeReason(curEdge, reason);
                cur = curEdge.getTarget();
            }

            final BooleanFormula consequence;
            if (edge.isMust()) {
                // exec-literals (other than the unassigned one) are already true
                final int unassignedLit = getSingleUnassignedExecLit(edge);
                assert unassignedLit != -1;
                for (int litId : edge.getExecLitIds()) {
                    if (litId != unassignedLit) {
                        addExecLitReason(litId, reason);
                    }
                }
                consequence = negExecLits.get(unassignedLit);
            } else {
                consequence = edge.getNegEdgeVar();
            }

            // Propagate
            assert !reason.isEmpty();
            final BooleanFormula[] propReason = reason.toArray(new BooleanFormula[0]);
            getBackend().propagateConsequence(propReason, consequence);
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

    private record Watcher(VarGraph graph, VarGraph.Edge edge) { }

    private sealed interface LitData permits EdgeLitData, ExecLitData { }
    private record EdgeLitData(VarGraph graph, VarGraph.Edge edge) implements LitData { }
    private record ExecLitData(int litId) implements LitData { }


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
