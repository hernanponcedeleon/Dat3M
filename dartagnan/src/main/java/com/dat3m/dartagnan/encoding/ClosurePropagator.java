package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.PropagatorBackend;
import org.sosy_lab.java_smt.basicimpl.AbstractUserPropagator;

import java.util.*;

/*
    Enforces "a path implies a closure edge" for the lazy closures of a WmmEncoder.
    Since a lazy closure is only used negatively, this lower bound is all that its encoding needs:
    any model can be turned into one where the closure edges are exactly the reachable pairs.

    A path is made of steps whose truth is known to the solver:
      - edges of the closed relation (variables of its active set),
      - pairs that are must-edges of the closed relation or of the closure, which hold iff both events execute.
    These are the same steps that the eager encoding of the closure uses (see WmmEncoder.visitTransitiveClosure),
    so the propagator derives at least the same closure edges.
    The transitive closure of the true steps is maintained incrementally, and every newly reachable lazy edge
    gets propagated with the steps of a witnessing path as reason.
 */
public class ClosurePropagator extends AbstractUserPropagator {

    // Keeps the quadratic tables (reachability and path witnesses) small.
    private static final int MAX_EVENTS = 2048;

    private final BooleanFormulaManager bmgr;
    private final List<ClosureGraph> graphs = new ArrayList<>();
    // Closure edges implied by steps that are always present. They must be asserted by the caller.
    private final List<BooleanFormula> initialFacts = new ArrayList<>();
    // Callback targets of each registered literal: {graph, STEP or EXECUTION, id}
    private final Map<BooleanFormula, List<int[]>> watches = new HashMap<>();
    private static final int STEP = 0;
    private static final int EXECUTION = 1;

    private boolean initializing = true;
    private long numPropagations = 0;
    private long numReasonLiterals = 0;

    public ClosurePropagator(EncodingContext context, List<WmmEncoder.LazyClosure> closures) {
        this.bmgr = context.getBooleanFormulaManager();
        for (WmmEncoder.LazyClosure closure : closures) {
            graphs.add(new ClosureGraph(graphs.size(), context, closure));
        }
        initializing = false;
    }

    public static boolean canHandle(EncodingContext context, WmmEncoder.LazyClosure closure) {
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        return Steps.compute(ra, closure).events.size() <= MAX_EVENTS;
    }

    public BooleanFormula encodeInitialFacts() {
        return bmgr.and(initialFacts);
    }

    public String getStatistics() {
        final StringJoiner joiner = new StringJoiner(", ");
        graphs.forEach(g -> joiner.add(g.toString()));
        return "%s; #propagations: %d, avg. reason size: %.1f".formatted(joiner, numPropagations,
                numPropagations == 0 ? 0.0 : (double) numReasonLiterals / numPropagations);
    }

    // ==================================================== Callbacks ====================================================

    @Override
    public void initializeWithBackend(PropagatorBackend backend) {
        super.initializeWithBackend(backend);
        watches.keySet().forEach(backend::registerExpression);
        backend.notifyOnKnownValue();
    }

    @Override
    public void onPush() {
        graphs.forEach(ClosureGraph::push);
    }

    @Override
    public void onPop(int numPoppedLevels) {
        graphs.forEach(g -> g.pop(numPoppedLevels));
    }

    @Override
    public void onKnownValue(BooleanFormula expr, boolean value) {
        if (!value) {
            // Only true steps and executed events can make pairs reachable.
            return;
        }
        for (int[] watch : watches.getOrDefault(expr, List.of())) {
            final ClosureGraph graph = graphs.get(watch[0]);
            if (watch[1] == STEP) {
                graph.enableStep(watch[2]);
            } else {
                graph.setExecuted(watch[2]);
            }
        }
    }

    // ==================================================== Steps ====================================================

    // The events and steps of a lazy closure.
    private record Steps(List<Event> events, List<Event> sources, List<Event> targets, List<Boolean> executionGated) {

        static Steps compute(RelationAnalysis ra, WmmEncoder.LazyClosure closure) {
            final Relation operand = closure.definition().getOperand();
            final EventGraph operandMay = ra.getKnowledge(operand).getMaySet();
            final EventGraph operandMust = ra.getKnowledge(operand).getMustSet();
            final EventGraph closureMust = ra.getKnowledge(closure.definition().getDefinedRelation()).getMustSet();
            final EventGraph operandActive = closure.operandActiveSet();

            final Steps steps = new Steps(new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
            final Set<Event> known = new HashSet<>();
            final java.util.function.Consumer<Event> addEvent = e -> {
                if (known.add(e)) {
                    steps.events.add(e);
                }
            };
            closure.lazyEdges().apply((x, y) -> { addEvent.accept(x); addEvent.accept(y); });
            operandActive.apply((x, y) -> { addEvent.accept(x); addEvent.accept(y); });

            // Single steps of the operand. As in the eager encoding, they start from events with lazy or active edges:
            // every other event on a path is a source of a lazy edge or is followed by a must-edge of the closure.
            final Set<List<Event>> added = new HashSet<>();
            final int numInitialEvents = steps.events.size();
            for (int i = 0; i < numInitialEvents; i++) {
                final Event x = steps.events.get(i);
                for (Event y : operandMay.getRange(x)) {
                    final boolean gated = closureMust.contains(x, y) || operandMust.contains(x, y);
                    if (x != y && (gated || operandActive.contains(x, y)) && added.add(List.of(x, y))) {
                        steps.add(x, y, gated);
                        addEvent.accept(y);
                    }
                }
            }
            // Must-edges of the closure that end in the target of a lazy edge.
            final Map<Event, Set<Event>> closureMustIn = closureMust.getInMap();
            final Set<Event> lazyTargets = new HashSet<>();
            closure.lazyEdges().apply((x, y) -> lazyTargets.add(y));
            for (Event y : lazyTargets) {
                for (Event x : closureMustIn.getOrDefault(y, Set.of())) {
                    if (x != y && known.contains(x) && added.add(List.of(x, y))) {
                        steps.add(x, y, true);
                    }
                }
            }
            return steps;
        }

        private void add(Event x, Event y, boolean gated) {
            sources.add(x);
            targets.add(y);
            executionGated.add(gated);
        }
    }

    // ==================================================== Graph ====================================================

    private final class ClosureGraph {

        private final String name;
        private final int numEvents;
        private final int numWords;

        // Steps
        private final int[] stepSource;
        private final int[] stepTarget;
        private final BooleanFormula[] stepLiteral; // null for execution-gated steps
        private final boolean[] stepEnabled;
        private final List<List<Integer>> gatedStepsOf = new ArrayList<>();
        private final BooleanFormula[] executionLiteral;
        private final boolean[] executed;

        // Lazy closure edges, by source: the targets and their literals
        private final int[][] lazyTargets;
        private final BooleanFormula[][] lazyLiterals;

        // reach[x] contains y iff there is a path of enabled steps from x to y,
        // and witness[x][y] is the last step added to the first such path that was found.
        private final long[][] reach;
        private final int[][] witness;

        // Backtracking
        private final List<Integer> reachTrailRows = new ArrayList<>();
        private final List<long[]> reachTrailDeltas = new ArrayList<>();
        private final List<Integer> stepTrail = new ArrayList<>();
        private final List<Integer> executionTrail = new ArrayList<>();
        private final Deque<int[]> levels = new ArrayDeque<>();

        // Scratch space
        private final int[] sources;
        private final int[] stepMarks;
        private int currentMark = 0;

        ClosureGraph(int index, EncodingContext context, WmmEncoder.LazyClosure closure) {
            final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
            final Relation closed = closure.definition().getDefinedRelation();
            final EncodingContext.EdgeEncoder operandEdge = context.edge(closure.definition().getOperand());
            final EncodingContext.EdgeEncoder closureEdge = context.edge(closed);
            final Steps steps = Steps.compute(ra, closure);

            name = closed.getNameOrTerm();
            numEvents = steps.events.size();
            numWords = (numEvents + 63) / 64;
            final Map<Event, Integer> ids = new HashMap<>();
            steps.events.forEach(e -> ids.put(e, ids.size()));

            final int numSteps = steps.sources.size();
            stepSource = new int[numSteps];
            stepTarget = new int[numSteps];
            stepLiteral = new BooleanFormula[numSteps];
            stepEnabled = new boolean[numSteps];
            executionLiteral = new BooleanFormula[numEvents];
            executed = new boolean[numEvents];
            for (int i = 0; i < numEvents; i++) {
                gatedStepsOf.add(new ArrayList<>());
            }
            for (int s = 0; s < numSteps; s++) {
                final Event x = steps.sources.get(s);
                final Event y = steps.targets.get(s);
                stepSource[s] = ids.get(x);
                stepTarget[s] = ids.get(y);
                if (steps.executionGated.get(s)) {
                    gatedStepsOf.get(stepSource[s]).add(s);
                    gatedStepsOf.get(stepTarget[s]).add(s);
                } else {
                    stepLiteral[s] = operandEdge.encode(x, y);
                    watch(stepLiteral[s], index, STEP, s);
                }
            }
            for (int e = 0; e < numEvents; e++) {
                if (!gatedStepsOf.get(e).isEmpty()) {
                    executionLiteral[e] = context.execution(steps.events.get(e));
                    executed[e] = bmgr.isTrue(executionLiteral[e]);
                    if (!executed[e] && !bmgr.isFalse(executionLiteral[e])) {
                        watch(executionLiteral[e], index, EXECUTION, e);
                    }
                }
            }

            final List<List<Event>> lazyTargetEvents = new ArrayList<>();
            for (int e = 0; e < numEvents; e++) {
                lazyTargetEvents.add(new ArrayList<>());
            }
            closure.lazyEdges().apply((x, y) -> lazyTargetEvents.get(ids.get(x)).add(y));
            lazyTargets = new int[numEvents][];
            lazyLiterals = new BooleanFormula[numEvents][];
            for (int e = 0; e < numEvents; e++) {
                final List<Event> ys = lazyTargetEvents.get(e);
                lazyTargets[e] = new int[ys.size()];
                lazyLiterals[e] = new BooleanFormula[ys.size()];
                for (int k = 0; k < ys.size(); k++) {
                    lazyTargets[e][k] = ids.get(ys.get(k));
                    lazyLiterals[e][k] = closureEdge.encode(steps.events.get(e), ys.get(k));
                }
            }

            reach = new long[numEvents][numWords];
            witness = new int[numEvents][numEvents];
            sources = new int[numEvents];
            stepMarks = new int[numSteps];

            // Steps between events that always execute
            for (int s = 0; s < numSteps; s++) {
                if (stepLiteral[s] == null && executed[stepSource[s]] && executed[stepTarget[s]]) {
                    enableStep(s);
                }
            }
        }

        private void watch(BooleanFormula literal, int graph, int kind, int id) {
            watches.computeIfAbsent(literal, k -> new ArrayList<>()).add(new int[]{graph, kind, id});
        }

        @Override
        public String toString() {
            return "%s: %d events, %d steps".formatted(name, numEvents, stepSource.length);
        }

        void push() {
            levels.push(new int[]{reachTrailRows.size(), stepTrail.size(), executionTrail.size()});
        }

        void pop(int numLevels) {
            int[] level = null;
            for (int i = 0; i < numLevels; i++) {
                level = levels.pop();
            }
            assert level != null;
            for (int i = reachTrailRows.size() - 1; i >= level[0]; i--) {
                final long[] row = reach[reachTrailRows.get(i)];
                final long[] delta = reachTrailDeltas.get(i);
                for (int w = 0; w < numWords; w++) {
                    row[w] &= ~delta[w];
                }
            }
            reachTrailRows.subList(level[0], reachTrailRows.size()).clear();
            reachTrailDeltas.subList(level[0], reachTrailDeltas.size()).clear();
            for (int i = level[1]; i < stepTrail.size(); i++) {
                stepEnabled[stepTrail.get(i)] = false;
            }
            stepTrail.subList(level[1], stepTrail.size()).clear();
            for (int i = level[2]; i < executionTrail.size(); i++) {
                executed[executionTrail.get(i)] = false;
            }
            executionTrail.subList(level[2], executionTrail.size()).clear();
        }

        void setExecuted(int e) {
            if (executed[e]) {
                return;
            }
            executed[e] = true;
            executionTrail.add(e);
            for (int s : gatedStepsOf.get(e)) {
                if (executed[stepSource[s]] && executed[stepTarget[s]]) {
                    enableStep(s);
                }
            }
        }

        void enableStep(int s) {
            if (stepEnabled[s]) {
                return;
            }
            stepEnabled[s] = true;
            stepTrail.add(s);
            final int u = stepSource[s];
            final int v = stepTarget[s];
            if (contains(reach[u], v)) {
                return;
            }
            // Every event that reaches u (and u itself) now reaches v and everything that v reaches.
            int numSources = 0;
            sources[numSources++] = u;
            for (int x = 0; x < numEvents; x++) {
                if (x != u && contains(reach[x], u)) {
                    sources[numSources++] = x;
                }
            }
            final long[] newlyReachable = reach[v].clone();
            newlyReachable[v >>> 6] |= 1L << (v & 63);
            for (int i = 0; i < numSources; i++) {
                final int x = sources[i];
                final long[] row = reach[x];
                long[] delta = null;
                for (int w = 0; w < numWords; w++) {
                    final long d = newlyReachable[w] & ~row[w];
                    if (d != 0) {
                        if (delta == null) {
                            delta = new long[numWords];
                        }
                        delta[w] = d;
                    }
                }
                if (delta == null) {
                    continue;
                }
                for (int w = 0; w < numWords; w++) {
                    row[w] |= delta[w];
                    for (long d = delta[w]; d != 0; d &= d - 1) {
                        witness[x][(w << 6) + Long.numberOfTrailingZeros(d)] = s;
                    }
                }
                reachTrailRows.add(x);
                reachTrailDeltas.add(delta);
                for (int k = 0; k < lazyTargets[x].length; k++) {
                    if (contains(delta, lazyTargets[x][k])) {
                        propagate(x, lazyTargets[x][k], lazyLiterals[x][k]);
                    }
                }
            }
        }

        private boolean contains(long[] row, int e) {
            return (row[e >>> 6] & (1L << (e & 63))) != 0;
        }

        private void propagate(int x, int y, BooleanFormula closureLiteral) {
            final List<BooleanFormula> reason = new ArrayList<>();
            currentMark++;
            final Deque<int[]> segments = new ArrayDeque<>();
            segments.push(new int[]{x, y});
            while (!segments.isEmpty()) {
                // A path from p to q ends with the step (u, v) = witness[p][q]:
                // it consists of a path from p to u, the step itself, and a path from v to q.
                final int[] segment = segments.pop();
                final int s = witness[segment[0]][segment[1]];
                if (stepMarks[s] != currentMark) {
                    stepMarks[s] = currentMark;
                    addReason(reason, s);
                }
                if (segment[0] != stepSource[s]) {
                    segments.push(new int[]{segment[0], stepSource[s]});
                }
                if (stepTarget[s] != segment[1]) {
                    segments.push(new int[]{stepTarget[s], segment[1]});
                }
            }
            if (initializing) {
                initialFacts.add(bmgr.implication(bmgr.and(reason), closureLiteral));
                return;
            }
            numPropagations++;
            numReasonLiterals += reason.size();
            getBackend().propagateConsequence(reason.toArray(new BooleanFormula[0]), closureLiteral);
        }

        private void addReason(List<BooleanFormula> reason, int s) {
            if (stepLiteral[s] != null) {
                reason.add(stepLiteral[s]);
                return;
            }
            for (int e : new int[]{stepSource[s], stepTarget[s]}) {
                final BooleanFormula literal = executionLiteral[e];
                if (!bmgr.isTrue(literal) && !reason.contains(literal)) {
                    reason.add(literal);
                }
            }
        }
    }
}
