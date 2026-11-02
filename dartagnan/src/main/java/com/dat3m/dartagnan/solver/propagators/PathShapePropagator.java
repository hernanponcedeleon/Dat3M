package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;
import java.util.function.Function;

/*
    Propagator for axioms irreflexive(R) and acyclic(R) (= irreflexive(R+)) where R is a regular expression
    over "atomic" relations (see PathAutomaton). Only the atoms are encoded; the propagator takes care of
    composition, union, and transitive closure.

    We maintain a single graph G over events whose edges are labelled by atoms. For each axiom with automaton A,
    the axiom is violated iff in the product G x A there is a path (x, init) ->* (x, f) for some event x and
    final state f.

    Edges come in two flavours:
      - Var-edges: (x, y) in active(a) \ must(a) for atom a. Their presence is given by the edge literal a(x, y).
      - Must-edges: (x, y) in must(a). These are only present if x and y execute, so they are enabled once
        the corresponding execution literals are true (see also AcyclicityPropagator).

    Conflict detection: When edge e = (u, v) labelled l becomes true, for each automaton state q' with
    some transition q -l-> q', we compute
        B  = { (y, p) | (y, p) ->* (u, q) for some q with q -l-> q' }   (backward search)
        Fw = { (y, p) | (v, q') ->* (y, p) }                            (forward search)
        X1 = { x | (x, init) in B },  X2 = { x | (x, f) in Fw, f final }
    and the axiom is violated (through e) iff X1 and X2 intersect.

    Theory propagation: An unassigned edge g = (s, t) labelled k would cause a violation (through e) iff for some
    transition p -k-> p' either
        (1) (s, p) in Fw and (t, p') ->* (x, f) for some x in X1      (e occurs before g on the violating path)
        (2) (t, p') in B and (x, init) ->* (s, p) for some x in X2    (g occurs before e on the violating path)
    which we check with a multi-source backward search from {(x, f) | x in X1} and a multi-source forward search
    from {(x, init) | x in X2}, respectively.

    Completeness of theory propagation: We maintain the invariant that every unassigned edge whose
    enabling would cause a violation has been propagated (to false). Any such edge that becomes "new" after
    enabling e must cause a violation through e, which is covered by cases (1) and (2).
    Known gaps (the propagator may still raise conflicts, which keeps it sound):
      - We only consider violations that use the candidate edge g once. Using it multiple times can be necessary
        for shapes like irreflexive(a;b;a;b) but not for typical shapes, e.g. if all occurrences of g's label
        are under a closure.
      - Setting an execution literal to true can enable several must-edges at once. We only propagate (the negation
        of) an execution literal if it alone enables a single violating must-edge.
      - The solver may assign several literals before notifying the propagator (e.g. by its own unit propagation).
 */
public class PathShapePropagator extends AbstractUserPropagator {

    private static final Logger logger = LoggerFactory.getLogger(PathShapePropagator.class);

    private static final boolean enableTheoryPropagation = true;
    private static final boolean stopOnConflict = false;
    // If set to true, we can propagate the same edge twice but with different reasons
    private static final boolean allowDuplicatePropagation = false;

    private static final int TRUE = VarGraph.TRUE;
    private static final int UNASSIGNED = VarGraph.UNASSIGNED;
    private static final int FALSE = VarGraph.FALSE;

    private final EncodingContext context;
    private final BooleanFormulaManager bmgr;
    private final RelationAnalysis ra;
    private final ExecutionAnalysis executionAnalysis;
    private final WmmEncoder wmmEncoder;

    // -------- Static data --------
    private final List<Shape> shapes = new ArrayList<>();
    private final List<Relation> labels = new ArrayList<>();
    private final Map<Relation, Integer> labelIds = new HashMap<>();
    private List<Shape>[] shapesByLabel;
    private final Map<Event, Integer> nodeIds = new HashMap<>();
    private VarGraph graph;
    private final BitSet derivableEdgeIds = new BitSet();
    private final Map<BooleanFormula, List<VarGraph.Edge>> lit2Edges = new HashMap<>();
    private int numPrunedEdges = 0;

    // -------- Execution literals (enabling must-edges) --------
    private final Map<BooleanFormula, Integer> execLit2Id = new HashMap<>();
    private final List<BooleanFormula> execLits = new ArrayList<>();
    private final List<BooleanFormula> negExecLits = new ArrayList<>();
    private final List<List<VarGraph.Edge>> execLitWatchers = new ArrayList<>(); // Must-edges enabled by the literal
    private int[] execLitValues;
    private final List<Integer> execTrail = new ArrayList<>();
    private final List<Integer> execBacktrackPoints = new ArrayList<>();

    // -------- Dynamic data --------
    private int curLevel = 0;
    private boolean raisedConflict = false;
    private boolean[] propagatedEdges; // Edges we have propagated (to false) since the last backtrack
    private final List<VarGraph.Edge> propagatedEdgeList = new ArrayList<>();

    // -------- Reason construction --------
    private int reasonStamp = 0;
    private int[] edgeReasonStamps;
    private int[] execLitReasonStamps;

    // -------- Misc --------
    private CachingFormulaMap<LitData> formulaLookup;

    // -------- Statistics --------
    private long numChecks = 0;
    private long numConflicts = 0;
    // Conflicts raised while no other conflict was pending, i.e., those that theory propagation should have avoided.
    // We distinguish those on (must-edges enabled by) execution literals, which is a known gap.
    private long numUnexpectedConflicts = 0;
    private long numUnexpectedConflictsOnExecLit = 0;
    private long numPropagations = 0;
    private long totalConflictSize = 0;
    private long totalPropagationSize = 0;

    public PathShapePropagator(WmmEncoder wmmEncoder, EncodingContext ctx, List<PathAutomaton> automata) {
        this.context = ctx;
        this.bmgr = ctx.getBooleanFormulaManager();
        this.ra = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        this.executionAnalysis = ctx.getAnalysisContext().requires(ExecutionAnalysis.class);
        this.wmmEncoder = wmmEncoder;

        for (PathAutomaton aut : automata) {
            for (Relation atom : aut.getAlphabet()) {
                labelIds.computeIfAbsent(atom, r -> {
                    labels.add(r);
                    return labels.size() - 1;
                });
            }
        }
        automata.forEach(aut -> shapes.add(new Shape(aut)));
        buildGraph();
    }

    // ================================================================================================
    // Initialization

    @SuppressWarnings("unchecked")
    private void buildGraph() {
        shapesByLabel = new List[labels.size()];
        for (int l = 0; l < labels.size(); l++) {
            shapesByLabel[l] = new ArrayList<>();
        }
        for (Shape s : shapes) {
            for (Relation atom : s.automaton.getAlphabet()) {
                shapesByLabel[labelIds.get(atom)].add(s);
            }
        }

        // ---- Collect edges ----
        // Must-edges (x, z) that are derivable via a chain of must-edges x -> y -> ... -> z can be ignored by
        // axioms whose automaton can simulate a single step by multiple steps (see canSkipDerivableEdges).
        // If all axioms can ignore them, we drop them altogether. Otherwise, we mark them as derivable.
        // NOTE: Like the relevant set reduction for acyclicity axioms, this assumes must(label) to be acyclic.
        record PendingEdge(Event x, Event y, int label, boolean isMust, boolean isDerivable) {}
        final List<PendingEdge> pending = new ArrayList<>();
        for (int l = 0; l < labels.size(); l++) {
            final int label = l;
            final Relation atom = labels.get(l);
            final RelationAnalysis.Knowledge k = ra.getKnowledge(atom);
            final boolean reducible = isAcyclic(k.getMustSet())
                    && shapesByLabel[label].stream().anyMatch(s -> canSkipDerivableEdges(s, label));
            final boolean dropDerivable = reducible
                    && shapesByLabel[label].stream().allMatch(s -> canSkipDerivableEdges(s, label));
            final EventGraph derivable = reducible ? transitivelyDerivableMustEdges(atom) : EventGraph.empty();
            if (reducible) {
                shapesByLabel[label].forEach(s -> s.skipDerivable[label] = canSkipDerivableEdges(s, label));
            }
            // The active set contains all (non-must) edges that are encoded and relevant for the axioms.
            wmmEncoder.getActiveSet(atom.getDefinition()).apply((x, y) -> {
                if (!k.getMustSet().contains(x, y)) {
                    pending.add(new PendingEdge(x, y, label, false, false));
                }
            });
            k.getMustSet().apply((x, y) -> {
                final boolean isDerivable = derivable.contains(x, y);
                if (!(isDerivable && dropDerivable)) {
                    pending.add(new PendingEdge(x, y, label, true, isDerivable));
                }
            });
        }

        // ---- Prune edges that cannot be part of any violation ----
        {
            final Map<Event, Integer> tmpIds = new HashMap<>();
            for (PendingEdge e : pending) {
                tmpIds.putIfAbsent(e.x(), tmpIds.size());
                tmpIds.putIfAbsent(e.y(), tmpIds.size());
            }
            final int[][] edgeArr = new int[pending.size()][];
            for (int i = 0; i < pending.size(); i++) {
                final PendingEdge e = pending.get(i);
                edgeArr[i] = new int[] { tmpIds.get(e.x()), tmpIds.get(e.y()), e.label() };
            }
            final boolean[] relevant = new boolean[pending.size()];
            for (Shape s : shapes) {
                s.markRelevantEdges(tmpIds.size(), edgeArr, relevant);
            }
            final List<PendingEdge> kept = new ArrayList<>();
            for (int i = 0; i < pending.size(); i++) {
                if (relevant[i]) {
                    kept.add(pending.get(i));
                }
            }
            numPrunedEdges = pending.size() - kept.size();
            pending.clear();
            pending.addAll(kept);
        }

        for (PendingEdge e : pending) {
            nodeIds.putIfAbsent(e.x(), nodeIds.size());
            nodeIds.putIfAbsent(e.y(), nodeIds.size());
        }
        graph = new VarGraph(nodeIds.size(), bmgr);

        for (PendingEdge e : pending) {
            final int x = nodeIds.get(e.x());
            final int y = nodeIds.get(e.y());
            if (e.isMust()) {
                final VarGraph.Edge edge = graph.addMustEdge(x, y, e.label(), getExecLitIds(e.x(), e.y()));
                if (e.isDerivable()) {
                    derivableEdgeIds.set(edge.getId());
                }
                for (int litId : edge.getExecLitIds()) {
                    execLitWatchers.get(litId).add(edge);
                }
            } else {
                final BooleanFormula lit = context.edge(labels.get(e.label()), e.x(), e.y());
                final VarGraph.Edge edge = graph.addVarEdge(x, y, e.label(), lit);
                lit2Edges.computeIfAbsent(lit, key -> new ArrayList<>(1)).add(edge);
            }
        }

        execLitValues = new int[execLits.size()];
        execLitReasonStamps = new int[execLits.size()];
        edgeReasonStamps = new int[graph.getNumEdges()];
        propagatedEdges = new boolean[graph.getNumEdges()];
        shapes.forEach(Shape::allocate);

        if (logger.isInfoEnabled()) {
            shapes.forEach(s -> logger.info("{}", s.automaton));
            logger.info("Path shape propagator: {} atoms, {} nodes, {} edges ({} dynamic), {} execution literals",
                    labels.size(), nodeIds.size(), graph.getNumEdges(), lit2Edges.size(), execLits.size());
        }
    }

    // An axiom can ignore must-edges (x, z) that are derivable via a chain of must-edges x -> y -> ... -> z,
    // if its automaton can simulate a single <label>-step by multiple such steps, i.e.,
    // succ(q, l) is contained in succ(succ(q, l), l) for all states q.
    private boolean canSkipDerivableEdges(Shape s, int label) {
        final int letter = s.letterOf[label];
        for (int q = 0; q < s.numStates; q++) {
            final Set<Integer> twoSteps = new HashSet<>();
            for (int p : s.successors(q, letter)) {
                for (int p2 : s.successors(p, letter)) {
                    twoSteps.add(p2);
                }
            }
            for (int p : s.successors(q, letter)) {
                if (!twoSteps.contains(p)) {
                    return false;
                }
            }
        }
        return true;
    }

    private EventGraph transitivelyDerivableMustEdges(Relation relation) {
        final EventGraph must = ra.getKnowledge(relation).getMustSet();
        final EventGraph transitiveClosure = ra.computeTransitiveClosure(must).getMustSet();
        return ra.computeComposition(transitiveClosure, transitiveClosure).getMustSet();
    }

    private static boolean isAcyclic(EventGraph graph) {
        final Map<Event, Set<Event>> out = graph.getOutMap();
        final Map<Event, Integer> state = new HashMap<>(); // 1 = on stack, 2 = done
        for (Event root : out.keySet()) {
            if (state.containsKey(root)) {
                continue;
            }
            final Deque<Iterator<Event>> stack = new ArrayDeque<>();
            final Deque<Event> nodes = new ArrayDeque<>();
            state.put(root, 1);
            stack.push(out.get(root).iterator());
            nodes.push(root);
            while (!stack.isEmpty()) {
                final Iterator<Event> it = stack.peek();
                if (it.hasNext()) {
                    final Event next = it.next();
                    final Integer st = state.get(next);
                    if (st == null) {
                        state.put(next, 1);
                        stack.push(out.getOrDefault(next, Set.of()).iterator());
                        nodes.push(next);
                    } else if (st == 1) {
                        return false;
                    }
                } else {
                    stack.pop();
                    state.put(nodes.pop(), 2);
                }
            }
        }
        return true;
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
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);
        backend.notifyOnKnownValue();

        lit2Edges.keySet().forEach(backend::registerExpression);
        execLits.forEach(backend::registerExpression);

        formulaLookup = new CachingFormulaMap<>((lit2Edges.size() + execLits.size()) * 2, key -> {
            final List<VarGraph.Edge> edges = lit2Edges.get(key);
            if (edges != null) {
                return new EdgeLitData(edges);
            }
            final Integer litId = execLit2Id.get(key);
            Preconditions.checkState(litId != null, "Unknown literal %s", key);
            return new ExecLitData(litId);
        });
    }

    // ================================================================================================
    // Backtracking

    @Override
    public void onPush() {
        curLevel++;
        graph.push();
        execBacktrackPoints.add(execTrail.size());
    }

    @Override
    public void onPop(int numPoppedLevels) {
        raisedConflict = false;
        curLevel -= numPoppedLevels;
        graph.pop(numPoppedLevels);

        final int backtrackPoint = execBacktrackPoints.get(curLevel);
        execBacktrackPoints.subList(curLevel, execBacktrackPoints.size()).clear();
        final List<Integer> undone = execTrail.subList(backtrackPoint, execTrail.size());
        undone.forEach(id -> execLitValues[id] = UNASSIGNED);
        undone.clear();

        propagatedEdgeList.forEach(e -> propagatedEdges[e.getId()] = false);
        propagatedEdgeList.clear();
        shapes.forEach(Shape::onPop);
    }

    // ================================================================================================
    // Assignments

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (raisedConflict && stopOnConflict) {
            return;
        }
        switch (formulaLookup.get(expr)) {
            case EdgeLitData(List<VarGraph.Edge> edges) -> onEdgeAssignment(edges, value);
            case ExecLitData(int litId) -> onExecLitAssignment(litId, value);
        }
    }

    // NOTE: Edges are assigned and processed one at a time: the topological order of each shape must account
    //  for all true edges except the one being processed.
    private void onEdgeAssignment(List<VarGraph.Edge> edges, boolean value) {
        for (VarGraph.Edge edge : edges) {
            graph.assignEdge(edge, value);
            if (value) {
                processEnabledEdge(edge, false);
            }
        }
    }

    private void onExecLitAssignment(int litId, boolean value) {
        assert execLitValues[litId] == UNASSIGNED;
        execLitValues[litId] = value ? TRUE : FALSE;
        execTrail.add(litId);
        if (!value) {
            return;
        }

        // Enable all must-edges whose execution condition became true.
        for (VarGraph.Edge edge : execLitWatchers.get(litId)) {
            if (edge.isUnassigned() && allExecLitsTrue(edge)) {
                graph.assignEdge(edge, true);
                processEnabledEdge(edge, true);
            }
        }
    }

    private void processEnabledEdge(VarGraph.Edge edge, boolean byExecLit) {
        if ((raisedConflict && stopOnConflict) || propagatedEdges[edge.getId()]) {
            // If we propagated this edge to false before, the solver will detect the conflict.
            raisedConflict = true;
            skipEdge(edge, 0);
            return;
        }
        numChecks++;
        final List<Shape> edgeShapes = shapesByLabel[edge.getLabel()];
        for (int i = 0; i < edgeShapes.size(); i++) {
            final Shape s = edgeShapes.get(i);
            if (s.isIgnored(edge)) {
                continue;
            }
            final boolean pendingConflict = raisedConflict;
            if (s.processEdgeAddition(edge)) {
                raisedConflict = true;
                if (!pendingConflict) {
                    numUnexpectedConflicts++;
                    numUnexpectedConflictsOnExecLit += byExecLit ? 1 : 0;
                }
                skipEdge(edge, i + 1);
                break;
            }
        }
    }

    // The remaining shapes (starting at index <from>) do not process <edge>, so their topological order may miss it.
    private void skipEdge(VarGraph.Edge edge, int from) {
        final List<Shape> edgeShapes = shapesByLabel[edge.getLabel()];
        for (int i = from; i < edgeShapes.size(); i++) {
            if (!edgeShapes.get(i).isIgnored(edge)) {
                edgeShapes.get(i).invalidateOrder();
            }
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

    // Returns true if <edge> is unassigned and could be propagated to false.
    private boolean isPropagationCandidate(VarGraph.Edge edge) {
        return edge.isUnassigned()
                && (allowDuplicatePropagation || !propagatedEdges[edge.getId()])
                && (!edge.isMust() || getSingleUnassignedExecLit(edge) != -1);
    }

    // ================================================================================================
    // Reasons

    private void newReason() {
        reasonStamp++;
    }

    // Adds the literals that justify the presence of <edge> to <reason>.
    private void addEdgeReason(VarGraph.Edge edge, List<BooleanFormula> reason) {
        assert edge.isTrue();
        if (edge.isMust()) {
            for (int litId : edge.getExecLitIds()) {
                addExecLitReason(litId, reason);
            }
        } else if (edgeReasonStamps[edge.getId()] != reasonStamp) {
            edgeReasonStamps[edge.getId()] = reasonStamp;
            reason.add(edge.getEdgeVar());
        }
    }

    private void addExecLitReason(int litId, List<BooleanFormula> reason) {
        assert execLitValues[litId] == TRUE;
        if (execLitReasonStamps[litId] != reasonStamp) {
            execLitReasonStamps[litId] = reasonStamp;
            reason.add(execLits.get(litId));
        }
    }

    private void propagateFalse(VarGraph.Edge edge, List<BooleanFormula> reason) {
        final BooleanFormula consequence;
        if (edge.isMust()) {
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
        assert !reason.isEmpty();
        getBackend().propagateConsequence(reason.toArray(new BooleanFormula[0]), consequence);
        propagatedEdges[edge.getId()] = true;
        propagatedEdgeList.add(edge);
        numPropagations++;
        totalPropagationSize += reason.size();
    }

    private void raiseConflict(List<BooleanFormula> reason) {
        getBackend().propagateConflict(reason.toArray(new BooleanFormula[0]));
        numConflicts++;
        totalConflictSize += reason.size();
    }

    // ================================================================================================
    // Per-axiom search

    private final class Shape {
        private final PathAutomaton automaton;
        private final int numStates;
        private final int numLetters;
        private final int init;
        private final boolean[] isFinal;
        // Cycle mode (see constructor): every cycle in the product graph is a violation.
        private final boolean cycleMode;
        private final int[] letterOf; // label -> letter of automaton (or -1)
        private final boolean[] skipDerivable; // label -> whether this axiom ignores derivable must-edges
        private final int[][] succ; // [q * numLetters + letter] -> successor states
        private final int[][] pred; // [q * numLetters + letter] -> predecessor states
        private final int[][] targetsByLetter; // [letter] -> distinct q' with some q -letter-> q'

        // Search buffers (indexed by product node = node * numStates + state)
        private Search bwd;  // B
        private Search fwd;  // Fw
        private Search bwd2; // B2
        private Search fwd2; // F2
        private int[] x1Pn;  // node -> (x, init) in B
        private int[] x2Pn;  // node -> (x, f) in Fw
        private int[] x1Stamp;
        private int[] x2Stamp;
        private int[] x1List;
        private int[] x2List;
        private int[] candidateStamps;
        private int xStamp = 0;
        private int[] nodeStamps;
        private int nodeStamp = 0;
        private final boolean[] isSourceState; // scratch for cycle mode

        // ---- Cycle mode: topological order of the product graph (Pearce-Kelly) ----
        // <ord> is a topological order of the product nodes w.r.t. all true (non-ignored) edges whenever
        // <orderValid> holds. Removing edges (backtracking) keeps it valid; adding edges updates it incrementally.
        // If an edge closes a cycle (conflict) or is skipped, the order becomes invalid until it is rebuilt.
        // While it is invalid, we fall back to unbounded searches.
        private int[] ord;     // product node -> position
        private int[] pos2pn;  // position -> product node
        private boolean orderValid = true;
        private boolean rebuildPending = false;
        private VarGraph.Edge insertingEdge; // Edge whose product transitions are being inserted
        private int[] insertedStamps;        // [q * numStates + q2] == insertedStamp iff (q, q2) of <insertingEdge> is ordered
        private int insertedStamp = 0;
        private int[] sortBufB;
        private int[] sortBufF;
        private int[] sortBufPool;
        private int[] sortBufNodes;
        // Propagation candidates (g, pnS, pnT)
        private VarGraph.Edge[] candEdges = new VarGraph.Edge[16];
        private int[] candS = new int[16];
        private int[] candT = new int[16];
        private int numCands;
        // Statistics
        private long numReorders = 0;
        private long numRebuilds = 0;
        private long numFallbacks = 0;

        Shape(PathAutomaton automaton) {
            this.automaton = automaton;
            this.numStates = automaton.getNumStates();
            this.init = automaton.getInitialState();
            final List<Relation> alphabet = automaton.getAlphabet();
            this.numLetters = alphabet.size();
            this.letterOf = new int[labels.size()];
            this.skipDerivable = new boolean[labels.size()];
            this.isSourceState = new boolean[numStates];
            Arrays.fill(letterOf, -1);
            for (int i = 0; i < numLetters; i++) {
                letterOf[labelIds.get(alphabet.get(i))] = i;
            }

            // ---- Cycle mode ----
            // For acyclic(R), the automaton A accepts R+. If (1) the initial state is not final and has no incoming
            // transitions and (2) every final state has the same outgoing transitions as the initial state,
            // we can merge the final states into the initial state. The resulting automaton A° accepts
            // (nonempty) words of R+ exactly on walks from init back to init.
            // If moreover (3) every cycle of A° passes through init, then every cycle in the product G x A° is
            // a violation. This allows us to use plain cycle detection (as in AcyclicityPropagator) on the product.
            final boolean mergeable = automaton.getAxiom() instanceof Acyclicity && canMergeFinalIntoInit();
            final int[] stateMap = new int[numStates];
            for (int q = 0; q < numStates; q++) {
                stateMap[q] = mergeable && automaton.isFinal(q) ? init : q;
            }
            this.succ = new int[numStates * numLetters][];
            this.pred = new int[numStates * numLetters][];
            final List<List<Set<Integer>>> predSets = new ArrayList<>();
            for (int q = 0; q < numStates; q++) {
                final List<Set<Integer>> perLetter = new ArrayList<>();
                for (int l = 0; l < numLetters; l++) {
                    perLetter.add(new TreeSet<>());
                }
                predSets.add(perLetter);
            }
            for (int q = 0; q < numStates; q++) {
                for (int l = 0; l < numLetters; l++) {
                    final boolean dead = mergeable && automaton.isFinal(q);
                    final int[] targets = dead ? new int[0]
                            : Arrays.stream(automaton.getSuccessors(q, l)).map(t -> stateMap[t]).distinct().sorted().toArray();
                    succ[q * numLetters + l] = targets;
                    for (int t : targets) {
                        predSets.get(t).get(l).add(q);
                    }
                }
            }
            for (int q = 0; q < numStates; q++) {
                for (int l = 0; l < numLetters; l++) {
                    pred[q * numLetters + l] = predSets.get(q).get(l).stream().mapToInt(Integer::intValue).toArray();
                }
            }
            this.cycleMode = mergeable && allCyclesPassInit();
            this.isFinal = new boolean[numStates];
            for (int q = 0; q < numStates; q++) {
                isFinal[q] = !mergeable && automaton.isFinal(q);
            }

            targetsByLetter = new int[numLetters][];
            for (int letter = 0; letter < numLetters; letter++) {
                final Set<Integer> targets = new TreeSet<>();
                for (int q = 0; q < numStates; q++) {
                    for (int t : succ[q * numLetters + letter]) {
                        targets.add(t);
                    }
                }
                targetsByLetter[letter] = targets.stream().mapToInt(Integer::intValue).toArray();
            }
        }

        private boolean canMergeFinalIntoInit() {
            if (automaton.isFinal(init)) {
                return false;
            }
            for (int q = 0; q < numStates; q++) {
                for (int l = 0; l < numLetters; l++) {
                    final int[] targets = automaton.getSuccessors(q, l);
                    if (Arrays.stream(targets).anyMatch(t -> t == init)) {
                        return false;
                    }
                    if (automaton.isFinal(q)) {
                        final int[] fromInit = automaton.getSuccessors(init, l);
                        if (!Arrays.equals(Arrays.stream(targets).sorted().toArray(), Arrays.stream(fromInit).sorted().toArray())) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        // Checks if the (merged) automaton without its initial state is acyclic.
        private boolean allCyclesPassInit() {
            final int[] status = new int[numStates]; // 0 = new, 1 = on stack, 2 = done
            for (int q = 0; q < numStates; q++) {
                if (q != init && status[q] == 0 && hasCycleFrom(q, status)) {
                    return false;
                }
            }
            return true;
        }

        private boolean hasCycleFrom(int q, int[] status) {
            status[q] = 1;
            for (int l = 0; l < numLetters; l++) {
                for (int t : succ[q * numLetters + l]) {
                    if (t == init) {
                        continue;
                    }
                    if (status[t] == 1 || (status[t] == 0 && hasCycleFrom(t, status))) {
                        return true;
                    }
                }
            }
            status[q] = 2;
            return false;
        }

        // Marks the edges (given as [source, target, label]) that may be part of a violation of this axiom:
        // An edge is relevant if one of its transitions in the product with the (over-approximate) graph lies
        // on a cycle. In general mode, we close paths (x, init) ->* (x, f) by reset transitions (x, f) -> (x, init).
        void markRelevantEdges(int numNodes, int[][] edges, boolean[] relevant) {
            final int size = numNodes * numStates;
            final List<List<Integer>> succs = new ArrayList<>(size);
            for (int i = 0; i < size; i++) {
                succs.add(new ArrayList<>());
            }
            for (int[] e : edges) {
                final int letter = letterOf[e[2]];
                if (letter < 0) {
                    continue;
                }
                for (int q = 0; q < numStates; q++) {
                    for (int q2 : successors(q, letter)) {
                        succs.get(e[0] * numStates + q).add(e[1] * numStates + q2);
                    }
                }
            }
            if (!cycleMode) {
                for (int x = 0; x < numNodes; x++) {
                    for (int f = 0; f < numStates; f++) {
                        if (isFinal[f]) {
                            succs.get(x * numStates + f).add(x * numStates + init);
                        }
                    }
                }
            }
            final int[] scc = computeSccs(succs);
            for (int i = 0; i < edges.length; i++) {
                final int[] e = edges[i];
                final int letter = letterOf[e[2]];
                if (relevant[i] || letter < 0) {
                    continue;
                }
                for (int q = 0; q < numStates && !relevant[i]; q++) {
                    for (int q2 : successors(q, letter)) {
                        if (scc[e[0] * numStates + q] == scc[e[1] * numStates + q2]) {
                            relevant[i] = true;
                            break;
                        }
                    }
                }
            }
        }

        void allocate() {
            final int size = nodeIds.size() * numStates;
            bwd = new Search(size);
            fwd = new Search(size);
            if (!cycleMode) {
                bwd2 = new Search(size);
                fwd2 = new Search(size);
                x1Pn = new int[nodeIds.size()];
                x2Pn = new int[nodeIds.size()];
                x1Stamp = new int[nodeIds.size()];
                x2Stamp = new int[nodeIds.size()];
                x1List = new int[nodeIds.size()];
                x2List = new int[nodeIds.size()];
            }
            candidateStamps = new int[graph.getNumEdges()];
            nodeStamps = new int[nodeIds.size()];
            if (cycleMode) {
                ord = new int[size];
                pos2pn = new int[size];
                for (int i = 0; i < size; i++) {
                    ord[i] = i;
                    pos2pn[i] = i;
                }
                insertedStamps = new int[numStates * numStates];
                sortBufB = new int[size];
                sortBufF = new int[size];
                sortBufPool = new int[size];
                sortBufNodes = new int[size];
            }
        }

        void invalidateOrder() {
            orderValid = false;
        }

        void onPop() {
            rebuildPending = !orderValid;
        }

        private int node(int pn) { return pn / numStates; }
        private int state(int pn) { return pn % numStates; }
        private int pn(int node, int state) { return node * numStates + state; }
        private int[] successors(int q, int letter) { return succ[q * numLetters + letter]; }
        private int[] predecessors(int q, int letter) { return pred[q * numLetters + letter]; }

        private boolean isIgnored(VarGraph.Edge edge) {
            return letterOf[edge.getLabel()] < 0
                    || (skipDerivable[edge.getLabel()] && derivableEdgeIds.get(edge.getId()));
        }

        // Returns true if a conflict was raised.
        boolean processEdgeAddition(VarGraph.Edge edge) {
            final int letter = letterOf[edge.getLabel()];
            if (cycleMode) {
                if (!orderValid && rebuildPending) {
                    rebuildPending = false;
                    rebuildOrder();
                }
                if (orderValid) {
                    return processEdgeIncremental(edge, letter);
                }
                numFallbacks++;
            }
            for (int q2 : targetsByLetter[letter]) {
                if (cycleMode ? processTransitionCycleMode(edge, letter, q2) : processTransition(edge, letter, q2)) {
                    return true;
                }
            }
            return false;
        }

        // ---- Cycle mode: any cycle (u, q) -e-> (v, q2) ->* (u, q) in the product is a violation ----
        private boolean processTransitionCycleMode(VarGraph.Edge e, int letter, int q2) {
            final int u = e.getSource();
            final int v = e.getTarget();
            final int[] sources = predecessors(q2, letter);
            for (int q : sources) {
                isSourceState[q] = true;
            }
            try {
                // ---- Fw: forward from (v, q2), stop once we reach some (u, q) ----
                fwd.begin();
                fwd.addSource(pn(v, q2));
                final int found = (u == v && isSourceState[q2]) ? pn(v, q2) : searchForwardUntil(fwd, u);
                if (found != -1) {
                    newReason();
                    final List<BooleanFormula> reason = new ArrayList<>();
                    fwd.collect(found, reason);
                    addEdgeReason(e, reason);
                    raiseConflict(reason);
                    return true;
                }
                if (!enableTheoryPropagation) {
                    return false;
                }

                // ---- B: backward from {(u, q) | q -letter-> q2}. Unassigned edges g = (s, t) with
                // (s, p) in Fw and (t, p') in B for some p -g-> p' would close a cycle. ----
                final int candStamp = ++reasonStamp;
                bwd.begin();
                for (int q : sources) {
                    bwd.addSource(pn(u, q));
                }
                searchBackward(bwd);
                // Scan the unassigned in-edges of each event in B once (not once per product node).
                nodeStamp++;
                for (int head = 0; head < bwd.size; head++) {
                    final int t = node(bwd.list[head]);
                    if (nodeStamps[t] == nodeStamp) {
                        continue;
                    }
                    nodeStamps[t] = nodeStamp;
                    final List<VarGraph.Edge> inEdges = graph.getInEdgeList(t);
                    for (int i = 0; i < inEdges.size(); i++) {
                        final VarGraph.Edge g = inEdges.get(i);
                        if (!g.isUnassigned() || isIgnored(g) || candidateStamps[g.getId()] == candStamp
                                || !isPropagationCandidate(g)) {
                            continue;
                        }
                        final int letterG = letterOf[g.getLabel()];
                        final int s = g.getSource();
                        search:
                        for (int p2 = 0; p2 < numStates; p2++) {
                            final int pnT = pn(t, p2);
                            if (!bwd.contains(pnT)) {
                                continue;
                            }
                            for (int p : predecessors(p2, letterG)) {
                                final int pnS = pn(s, p);
                                if (fwd.contains(pnS)) {
                                    candidateStamps[g.getId()] = candStamp;
                                    newReason();
                                    final List<BooleanFormula> reason = new ArrayList<>();
                                    fwd.collect(pnS, reason);
                                    addEdgeReason(e, reason);
                                    bwd.collect(pnT, reason);
                                    propagateFalse(g, reason);
                                    break search;
                                }
                            }
                        }
                    }
                }
                return false;
            } finally {
                for (int q : sources) {
                    isSourceState[q] = false;
                }
            }
        }

        // ---- Cycle mode with topological order ----

        private boolean processEdgeIncremental(VarGraph.Edge e, int letter) {
            final int u = e.getSource();
            final int v = e.getTarget();
            // Insert the product transitions (u, q) -e-> (v, q2) one by one. Searches only follow the transitions
            // of <e> that are already inserted, so that the order stays valid for all other transitions.
            insertingEdge = e;
            insertedStamp++;
            try {
                for (int q2 : targetsByLetter[letter]) {
                    for (int q : predecessors(q2, letter)) {
                        if (insertTransition(e, pn(u, q), pn(v, q2))) {
                            orderValid = false;
                            return true;
                        }
                        insertedStamps[q * numStates + q2] = insertedStamp;
                    }
                }
            } finally {
                insertingEdge = null;
            }
            if (enableTheoryPropagation) {
                for (int q2 : targetsByLetter[letter]) {
                    propagateIncremental(e, letter, q2);
                }
            }
            return false;
        }

        private boolean isFollowable(VarGraph.Edge edge, int p, int p2) {
            return edge != insertingEdge || insertedStamps[p * numStates + p2] == insertedStamp;
        }

        // Inserts the transition a -e-> b into the topological order. Returns true if a conflict was raised.
        private boolean insertTransition(VarGraph.Edge e, int a, int b) {
            if (a == b) {
                newReason();
                final List<BooleanFormula> reason = new ArrayList<>();
                addEdgeReason(e, reason);
                raiseConflict(reason);
                return true;
            }
            final int lb = ord[b];
            final int ub = ord[a];
            if (ub < lb) {
                return false;
            }
            // Forward from b within positions < ub. Reaching a means a cycle.
            fwd.begin();
            fwd.addSource(b);
            if (searchForwardBounded(fwd, ub, a)) {
                newReason();
                final List<BooleanFormula> reason = new ArrayList<>();
                fwd.collect(a, reason);
                addEdgeReason(e, reason);
                raiseConflict(reason);
                return true;
            }
            // Backward from a within positions > lb.
            bwd.begin();
            bwd.addSource(a);
            searchBackwardBounded(bwd, lb);
            reorder();
            return false;
        }

        // Moves the nodes of <bwd> before the nodes of <fwd>, reusing their positions.
        private void reorder() {
            numReorders++;
            final int nb = bwd.size;
            final int nf = fwd.size;
            for (int i = 0; i < nb; i++) {
                sortBufB[i] = ord[bwd.list[i]];
            }
            for (int i = 0; i < nf; i++) {
                sortBufF[i] = ord[fwd.list[i]];
            }
            Arrays.sort(sortBufB, 0, nb);
            Arrays.sort(sortBufF, 0, nf);
            // Merge positions
            int i = 0;
            int j = 0;
            int k = 0;
            while (i < nb || j < nf) {
                sortBufPool[k++] = (j >= nf || (i < nb && sortBufB[i] < sortBufF[j])) ? sortBufB[i++] : sortBufF[j++];
            }
            // Nodes in their new order: B (by old position), then F (by old position)
            for (i = 0; i < nb; i++) {
                sortBufNodes[i] = pos2pn[sortBufB[i]];
            }
            for (j = 0; j < nf; j++) {
                sortBufNodes[nb + j] = pos2pn[sortBufF[j]];
            }
            for (k = 0; k < nb + nf; k++) {
                final int node = sortBufNodes[k];
                final int pos = sortBufPool[k];
                ord[node] = pos;
                pos2pn[pos] = node;
            }
        }

        // Recomputes the order from scratch (Kahn). If the product graph is cyclic, the order stays invalid.
        private void rebuildOrder() {
            numRebuilds++;
            final int size = ord.length;
            final int[] inDegree = sortBufB;
            final int[] queue = sortBufF;
            Arrays.fill(inDegree, 0, size, 0);
            for (int x = 0; x < nodeIds.size(); x++) {
                for (VarGraph.Edge edge : graph.getTrueOutEdgeList(x)) {
                    if (isIgnored(edge)) {
                        continue;
                    }
                    for (int p = 0; p < numStates; p++) {
                        for (int p2 : successors(p, letterOf[edge.getLabel()])) {
                            inDegree[pn(edge.getTarget(), p2)]++;
                        }
                    }
                }
            }
            int tail = 0;
            for (int i = 0; i < size; i++) {
                if (inDegree[i] == 0) {
                    queue[tail++] = i;
                }
            }
            for (int head = 0; head < tail; head++) {
                final int pnX = queue[head];
                final int p = state(pnX);
                for (VarGraph.Edge edge : graph.getTrueOutEdgeList(node(pnX))) {
                    if (isIgnored(edge)) {
                        continue;
                    }
                    for (int p2 : successors(p, letterOf[edge.getLabel()])) {
                        final int next = pn(edge.getTarget(), p2);
                        if (--inDegree[next] == 0) {
                            queue[tail++] = next;
                        }
                    }
                }
            }
            if (tail < size) {
                return; // Still cyclic
            }
            for (int i = 0; i < size; i++) {
                ord[queue[i]] = i;
                pos2pn[i] = queue[i];
            }
            orderValid = true;
        }

        // Propagation for the transitions into (v, q2): every unassigned g = (s, t) with (s, p) reachable from
        // (v, q2) and (t, p') reaching some (u, q) with q -letter-> q2 and p -g-> p' would close a cycle.
        // Since the order is valid, (t, p') can only reach (u, q) if ord(t, p') <= ord(u, q). Hence we first
        // collect the candidates from the forward search and then search backward only down to the
        // smallest candidate position.
        private void propagateIncremental(VarGraph.Edge e, int letter, int q2) {
            final int u = e.getSource();
            final int v = e.getTarget();
            final int[] sources = predecessors(q2, letter);
            int maxU = -1;
            for (int q : sources) {
                maxU = Math.max(maxU, ord[pn(u, q)]);
            }

            fwd.begin();
            fwd.addSource(pn(v, q2));
            searchForward(fwd);

            // Collect candidates (scanning the out-edges of each event once)
            numCands = 0;
            int minT = Integer.MAX_VALUE;
            nodeStamp++;
            for (int head = 0; head < fwd.size; head++) {
                final int s = node(fwd.list[head]);
                if (nodeStamps[s] == nodeStamp) {
                    continue;
                }
                nodeStamps[s] = nodeStamp;
                final List<VarGraph.Edge> outEdges = graph.getOutEdgeList(s);
                for (int i = 0; i < outEdges.size(); i++) {
                    final VarGraph.Edge g = outEdges.get(i);
                    if (!g.isUnassigned() || isIgnored(g) || !isPropagationCandidate(g)) {
                        continue;
                    }
                    final int letterG = letterOf[g.getLabel()];
                    final int t = g.getTarget();
                    for (int p = 0; p < numStates; p++) {
                        final int pnS = pn(s, p);
                        if (!fwd.contains(pnS)) {
                            continue;
                        }
                        for (int p2 : successors(p, letterG)) {
                            final int pnT = pn(t, p2);
                            final int pos = ord[pnT];
                            if (pos <= maxU) {
                                addCandidate(g, pnS, pnT);
                                minT = Math.min(minT, pos);
                            }
                        }
                    }
                }
            }
            if (numCands == 0) {
                return;
            }

            bwd.begin();
            for (int q : sources) {
                bwd.addSource(pn(u, q));
            }
            searchBackwardBounded(bwd, minT - 1);

            final int candStamp = ++reasonStamp;
            for (int i = 0; i < numCands; i++) {
                final VarGraph.Edge g = candEdges[i];
                final int pnT = candT[i];
                if (candidateStamps[g.getId()] == candStamp || !bwd.contains(pnT) || !isPropagationCandidate(g)) {
                    continue;
                }
                candidateStamps[g.getId()] = candStamp;
                newReason();
                final List<BooleanFormula> reason = new ArrayList<>();
                fwd.collect(candS[i], reason);
                addEdgeReason(e, reason);
                bwd.collect(pnT, reason);
                propagateFalse(g, reason);
            }
            Arrays.fill(candEdges, 0, numCands, null);
        }

        private void addCandidate(VarGraph.Edge g, int pnS, int pnT) {
            if (numCands == candEdges.length) {
                candEdges = Arrays.copyOf(candEdges, 2 * numCands);
                candS = Arrays.copyOf(candS, 2 * numCands);
                candT = Arrays.copyOf(candT, 2 * numCands);
            }
            candEdges[numCands] = g;
            candS[numCands] = pnS;
            candT[numCands] = pnT;
            numCands++;
        }

        // Forward search visiting only nodes with position < ub (and <target>). Returns true if <target> is reached.
        private boolean searchForwardBounded(Search search, int ub, int target) {
            for (int head = 0; head < search.size; head++) {
                final int pnX = search.list[head];
                final int p = state(pnX);
                final List<VarGraph.Edge> outEdges = graph.getTrueOutEdgeList(node(pnX));
                for (int i = 0; i < outEdges.size(); i++) {
                    final VarGraph.Edge edge = outEdges.get(i);
                    if (isIgnored(edge)) {
                        continue;
                    }
                    final int next = edge.getTarget();
                    for (int p2 : successors(p, letterOf[edge.getLabel()])) {
                        if (!isFollowable(edge, p, p2)) {
                            continue;
                        }
                        final int pnNext = pn(next, p2);
                        if (pnNext == target) {
                            search.visit(pnNext, edge, pnX);
                            return true;
                        }
                        if (ord[pnNext] < ub) {
                            search.visit(pnNext, edge, pnX);
                        }
                    }
                }
            }
            return false;
        }

        // Backward search visiting only nodes with position > lb.
        private void searchBackwardBounded(Search search, int lb) {
            for (int head = 0; head < search.size; head++) {
                final int pnX = search.list[head];
                final int p = state(pnX);
                final List<VarGraph.Edge> inEdges = graph.getTrueInEdgeList(node(pnX));
                for (int i = 0; i < inEdges.size(); i++) {
                    final VarGraph.Edge edge = inEdges.get(i);
                    if (isIgnored(edge)) {
                        continue;
                    }
                    final int prev = edge.getSource();
                    for (int p0 : predecessors(p, letterOf[edge.getLabel()])) {
                        if (!isFollowable(edge, p0, p)) {
                            continue;
                        }
                        final int pnPrev = pn(prev, p0);
                        if (ord[pnPrev] > lb) {
                            search.visit(pnPrev, edge, pnX);
                        }
                    }
                }
            }
        }

        // Forward search that stops at the first visited (target, q) with isSourceState[q].
        // Returns that product node or -1.
        private int searchForwardUntil(Search search, int target) {
            for (int head = 0; head < search.size; head++) {
                final int pn = search.list[head];
                final int p = state(pn);
                final List<VarGraph.Edge> outEdges = graph.getTrueOutEdgeList(node(pn));
                for (int i = 0; i < outEdges.size(); i++) {
                    final VarGraph.Edge edge = outEdges.get(i);
                    if (isIgnored(edge)) {
                        continue;
                    }
                    final int next = edge.getTarget();
                    for (int p2 : successors(p, letterOf[edge.getLabel()])) {
                        final int pnNext = pn(next, p2);
                        if (search.visit(pnNext, edge, pn) && next == target && isSourceState[p2]) {
                            return pnNext;
                        }
                    }
                }
            }
            return -1;
        }

        // ---- General mode ----
        private boolean processTransition(VarGraph.Edge e, int letter, int q2) {
            final int u = e.getSource();
            final int v = e.getTarget();

            // ---- B: backward from {(u, q) | q -letter-> q2} ----
            bwd.begin();
            for (int q : predecessors(q2, letter)) {
                bwd.addSource(pn(u, q));
            }
            searchBackward(bwd);
            xStamp++;
            int numX1 = 0;
            for (int i = 0; i < bwd.size; i++) {
                final int pn = bwd.list[i];
                if (state(pn) == init) {
                    final int x = node(pn);
                    x1Stamp[x] = xStamp;
                    x1Pn[x] = pn;
                    x1List[numX1++] = x;
                }
            }

            // ---- Fw: forward from (v, q2) ----
            fwd.begin();
            fwd.addSource(pn(v, q2));
            searchForward(fwd);
            int numX2 = 0;
            for (int i = 0; i < fwd.size; i++) {
                final int pn = fwd.list[i];
                if (!isFinal[state(pn)]) {
                    continue;
                }
                final int x = node(pn);
                if (x1Stamp[x] == xStamp) {
                    // ---- Conflict: (x, init) ->B (u, q) -e-> (v, q2) ->Fw (x, f) ----
                    newReason();
                    final List<BooleanFormula> reason = new ArrayList<>();
                    bwd.collect(x1Pn[x], reason);
                    addEdgeReason(e, reason);
                    fwd.collect(pn, reason);
                    raiseConflict(reason);
                    return true;
                }
                if (x2Stamp[x] != xStamp) {
                    x2Stamp[x] = xStamp;
                    x2Pn[x] = pn;
                    x2List[numX2++] = x;
                }
            }

            if (!enableTheoryPropagation) {
                return false;
            }
            final int candStamp = ++reasonStamp; // Unique stamp to avoid duplicate candidates

            // ---- Case 1: (x, init) ->B (u, q) -e-> (v, q2) ->Fw (s, p) -g-> (t, p') ->B2 (x, f) ----
            if (numX1 > 0) {
                bwd2.begin();
                for (int i = 0; i < numX1; i++) {
                    for (int f = 0; f < numStates; f++) {
                        if (isFinal[f]) {
                            bwd2.addSource(pn(x1List[i], f));
                        }
                    }
                }
                searchBackward(bwd2);
                scanCandidates(fwd, bwd2, candStamp, (g, pnS, pnT) -> {
                    newReason();
                    final List<BooleanFormula> reason = new ArrayList<>();
                    fwd.collect(pnS, reason);
                    addEdgeReason(e, reason);
                    final int pnEnd = bwd2.collect(pnT, reason);
                    bwd.collect(x1Pn[node(pnEnd)], reason);
                    propagateFalse(g, reason);
                });
            }

            // ---- Case 2: (x, init) ->F2 (s, p) -g-> (t, p') ->B (u, q) -e-> (v, q2) ->Fw (x, f) ----
            if (numX2 > 0) {
                fwd2.begin();
                for (int i = 0; i < numX2; i++) {
                    fwd2.addSource(pn(x2List[i], init));
                }
                searchForward(fwd2);
                scanCandidates(fwd2, bwd, candStamp, (g, pnS, pnT) -> {
                    newReason();
                    final List<BooleanFormula> reason = new ArrayList<>();
                    final int pnStart = fwd2.collect(pnS, reason);
                    bwd.collect(pnT, reason);
                    addEdgeReason(e, reason);
                    fwd.collect(x2Pn[node(pnStart)], reason);
                    propagateFalse(g, reason);
                });
            }
            return false;
        }

        private interface CandidateHandler {
            void handle(VarGraph.Edge g, int pnS, int pnT);
        }

        // Calls <handler> once for each unassigned (not yet considered) propagation candidate g = (s, t) with
        // a transition (s, p) -g-> (t, p') where (s, p) in <from> and (t, p') in <to>.
        // The out-edges of each event are scanned only once.
        private void scanCandidates(Search from, Search to, int candStamp, CandidateHandler handler) {
            nodeStamp++;
            for (int head = 0; head < from.size; head++) {
                final int s = node(from.list[head]);
                if (nodeStamps[s] == nodeStamp) {
                    continue;
                }
                nodeStamps[s] = nodeStamp;
                final List<VarGraph.Edge> outEdges = graph.getOutEdgeList(s);
                for (int i = 0; i < outEdges.size(); i++) {
                    final VarGraph.Edge g = outEdges.get(i);
                    if (!g.isUnassigned() || isIgnored(g) || candidateStamps[g.getId()] == candStamp
                            || !isPropagationCandidate(g)) {
                        continue;
                    }
                    final int letterG = letterOf[g.getLabel()];
                    final int t = g.getTarget();
                    search:
                    for (int p = 0; p < numStates; p++) {
                        final int pnS = pn(s, p);
                        if (!from.contains(pnS)) {
                            continue;
                        }
                        for (int p2 : successors(p, letterG)) {
                            final int pnT = pn(t, p2);
                            if (to.contains(pnT)) {
                                candidateStamps[g.getId()] = candStamp;
                                handler.handle(g, pnS, pnT);
                                break search;
                            }
                        }
                    }
                }
            }
        }

        // ---- Searches ----

        private void searchForward(Search search) {
            for (int head = 0; head < search.size; head++) {
                final int pn = search.list[head];
                final int p = state(pn);
                final List<VarGraph.Edge> outEdges = graph.getTrueOutEdgeList(node(pn));
                for (int i = 0; i < outEdges.size(); i++) {
                    final VarGraph.Edge edge = outEdges.get(i);
                    if (isIgnored(edge)) {
                        continue;
                    }
                    for (int p2 : successors(p, letterOf[edge.getLabel()])) {
                        search.visit(pn(edge.getTarget(), p2), edge, pn);
                    }
                }
            }
        }

        private void searchBackward(Search search) {
            for (int head = 0; head < search.size; head++) {
                final int pn = search.list[head];
                final int p = state(pn);
                final List<VarGraph.Edge> inEdges = graph.getTrueInEdgeList(node(pn));
                for (int i = 0; i < inEdges.size(); i++) {
                    final VarGraph.Edge edge = inEdges.get(i);
                    if (isIgnored(edge)) {
                        continue;
                    }
                    for (int p0 : predecessors(p, letterOf[edge.getLabel()])) {
                        search.visit(pn(edge.getSource(), p0), edge, pn);
                    }
                }
            }
        }

    }

    // BFS over product nodes; stores for each visited node the edge (and node) it was reached from.
    private final class Search {
        private final int[] stamps;
        private final VarGraph.Edge[] linkEdge;
        private final int[] linkNode;
        private final int[] list;
        private int size;
        private int stamp = 0;

        Search(int capacity) {
            stamps = new int[capacity];
            linkEdge = new VarGraph.Edge[capacity];
            linkNode = new int[capacity];
            list = new int[capacity];
        }

        void begin() {
            stamp++;
            size = 0;
        }

        boolean contains(int pn) { return stamps[pn] == stamp; }

        void addSource(int pn) {
            if (stamps[pn] != stamp) {
                stamps[pn] = stamp;
                linkEdge[pn] = null;
                list[size++] = pn;
            }
        }

        // Returns true if <pn> was not visited before.
        boolean visit(int pn, VarGraph.Edge edge, int from) {
            if (stamps[pn] != stamp) {
                stamps[pn] = stamp;
                linkEdge[pn] = edge;
                linkNode[pn] = from;
                list[size++] = pn;
                return true;
            }
            return false;
        }

        // Collects the edges of the path from <pn> to a source of this search (following the stored links).
        // Returns the source that was reached.
        int collect(int pn, List<BooleanFormula> reason) {
            assert contains(pn);
            VarGraph.Edge edge;
            while ((edge = linkEdge[pn]) != null) {
                addEdgeReason(edge, reason);
                pn = linkNode[pn];
            }
            return pn;
        }
    }

    // Iterative Tarjan. Returns the SCC id of each node.
    private static int[] computeSccs(List<List<Integer>> succs) {
        final int n = succs.size();
        final int[] index = new int[n];
        final int[] low = new int[n];
        final int[] scc = new int[n];
        final boolean[] onStack = new boolean[n];
        Arrays.fill(index, -1);
        final int[] stack = new int[n];
        int sp = 0;
        int counter = 0;
        int numSccs = 0;
        final int[] callNode = new int[n];
        final int[] callPos = new int[n];
        for (int root = 0; root < n; root++) {
            if (index[root] != -1) {
                continue;
            }
            int depth = 0;
            callNode[0] = root;
            callPos[0] = 0;
            index[root] = low[root] = counter++;
            stack[sp++] = root;
            onStack[root] = true;
            while (depth >= 0) {
                final int v = callNode[depth];
                final List<Integer> out = succs.get(v);
                if (callPos[depth] < out.size()) {
                    final int w = out.get(callPos[depth]++);
                    if (index[w] == -1) {
                        index[w] = low[w] = counter++;
                        stack[sp++] = w;
                        onStack[w] = true;
                        depth++;
                        callNode[depth] = w;
                        callPos[depth] = 0;
                    } else if (onStack[w]) {
                        low[v] = Math.min(low[v], index[w]);
                    }
                } else {
                    if (low[v] == index[v]) {
                        int w;
                        do {
                            w = stack[--sp];
                            onStack[w] = false;
                            scc[w] = numSccs;
                        } while (w != v);
                        numSccs++;
                    }
                    depth--;
                    if (depth >= 0) {
                        final int parent = callNode[depth];
                        low[parent] = Math.min(low[parent], low[v]);
                    }
                }
            }
        }
        return scc;
    }

    // ================================================================================================
    // Statistics

    public void printStatistics() {
        System.out.println("PathShapePropagator: cycle mode = " + shapes.stream().map(s -> s.automaton.getAxiom().getName() + ":" + s.cycleMode
                + (s.cycleMode ? "(reorders=" + s.numReorders + ", rebuilds=" + s.numRebuilds + ", fallbacks=" + s.numFallbacks + ")" : "")).toList());
        System.out.printf("PathShapePropagator: checks=%d, conflicts=%d (avg size %.1f, unexpected=%d, of which on exec-literals=%d), propagations=%d (avg size %.1f)%n",
                numChecks,
                numConflicts, numConflicts == 0 ? 0.0 : (double) totalConflictSize / numConflicts,
                numUnexpectedConflicts, numUnexpectedConflictsOnExecLit,
                numPropagations, numPropagations == 0 ? 0.0 : (double) totalPropagationSize / numPropagations);
    }

    public long getNumConflicts() { return numConflicts; }
    public long getNumPropagations() { return numPropagations; }

    // ===================================== Helper classes ====================================

    private sealed interface LitData permits EdgeLitData, ExecLitData { }
    private record EdgeLitData(List<VarGraph.Edge> edges) implements LitData { }
    private record ExecLitData(int litId) implements LitData { }

    // The IdentityHashMap is used to avoid expensive .equals calls on BooleanFormula.
    // We populate the map in onKnownValue because only there we get canonical instances.
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
