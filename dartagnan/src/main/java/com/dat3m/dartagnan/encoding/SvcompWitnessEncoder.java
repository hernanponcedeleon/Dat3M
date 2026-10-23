package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.WitnessValidationTask;
import com.dat3m.dartagnan.witness.svcomp.SvcompViolationWitness;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.Candidate;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedVariable;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedSegment;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWaypoint;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWitness;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.HB_RELATION;

/**
 * Encodes a violation witness resolved by {@link SvcompWitnessResolver} as follows:
 *
 * Threads: each witness thread ID is bound to exactly one of its compatible program threads,
 * and distinct IDs are bound to distinct threads. Every selected candidate event runs in the thread
 * bound to the ID of its waypoint. The thread entered by a function_enter waypoint must start
 * executing, and its creator must run in the thread bound to the parent's ID.
 *
 * Assumptions: supported constraints are Boolean constants, expressions of the form
 * variable == integer_literal, or conjunctions of these. Floating-point assumptions are
 * currently unsupported. Each equality constrains the value of its variable immediately
 * before the source statement. Its value comes from the last executed write, including
 * initialization, in the SV-COMP execution order. All equalities in a conjunction refer
 * to the same position.
 *
 * Targets: for assertion-based properties, at least one assertion resolved for the target must
 * be violated, i.e., executed with a false condition. For other properties, at least one event in
 * the specified thread at the target source location must execute. For CAT specifications, the
 * selected target events must also constitute the violation: they must form an edge, in either
 * direction, of the relation of a flagged non-emptiness axiom (e.g., the data-race relation).
 * A single target must be an endpoint of such an edge.
 *
 * Every waypoint must satisfy the requirement for its type: the child thread starts
 * executing, the assumption holds, or the target is reached.
 *
 * Segment order: to order segments, at least one executed candidate event is selected
 * per segment. A selected assumption event must also satisfy its value constraints.
 * Bitvector ranks place selected events from consecutive segments in
 * strictly increasing order. Ranks also respect every encoded hb-consistency edge and
 * program order between executed candidate events in the same thread, and no event of another
 * thread is ranked inside an executed atomic section or read-modify-write pair. Thus, the witness
 * order must be compatible with the memory model, while unrelated events may also be ordered.
 * The accesses to the variables of a selected assumption, within the same statement instance,
 * are also placed after the previous segment's events and before the next segment's events,
 * without ordering them among each other.
 */
public final class SvcompWitnessEncoder {

    private static final Logger logger = LoggerFactory.getLogger(SvcompWitnessEncoder.class);
    private static final String WITNESS_CLOCK = "witness-hb";

    private final EncodingContext context;
    private final SvcompViolationWitness witness;
    private final Property property;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final BitvectorFormulaManager bvmgr;
    private final int rankWidth;
    private final String clockPrefix;

    private SvcompWitnessEncoder(EncodingContext context, SvcompViolationWitness witness, Property property) {
        this.context = context;
        this.witness = witness;
        this.property = property;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
        this.clockPrefix = context.getFormulaManager().escape(WITNESS_CLOCK) + " ";
        // Every integer ordering of N events can be ranked from 0 to N - 1.
        // Use unsigned comparisons without arithmetic, so ranks cannot wrap around.
        this.rankWidth = Math.max(1, Integer.SIZE - Integer.numberOfLeadingZeros(
                program.getThreadEvents().size() - 1));
    }

    public static SvcompWitnessEncoder withContext(EncodingContext context) {
        if (!(context.getTask() instanceof WitnessValidationTask task)) {
            throw new IllegalArgumentException("Witness encoding requires a witness validation task");
        }
        return new SvcompWitnessEncoder(context, task.getWitness(), task.getProperty());
    }

    public BooleanFormula encode() {
        logger.info("Encoding witness");
        final AliasAnalysis alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        final ResolvedWitness resolvedWitness = SvcompWitnessResolver.resolve(witness, program, alias, property);
        final Map<String, ResolvedVariable> variables = resolvedWitness.variables();
        final List<BooleanFormula> constraints = new ArrayList<>();
        // If the witness needs more threads than this bounded program contains, the bindings are unsatisfiable,
        // which lets the solver check reachable bounds and retry.
        constraints.add(encodeThreadBindings(resolvedWitness.threads()));
        // For each non-empty segment and each of its waypoints, the encoding of every candidate event.
        final List<List<Map<Event, BooleanFormula>>> segmentsEnc = new ArrayList<>();
        final Map<Event, Set<Event>> statementAccesses = new HashMap<>();
        for (ResolvedSegment segment : resolvedWitness.segments()) {
            final List<Map<Event, BooleanFormula>> segmentEnc = new ArrayList<>();
            for (ResolvedWaypoint waypoint : segment.waypoints()) {
                final Map<Event, BooleanFormula> waypointEnc = new LinkedHashMap<>();
                for (Candidate candidate : waypoint.candidates()) {
                    waypointEnc.put(candidate.event(), bmgr.and(encodeBinding(waypoint, candidate.event()),
                            encodeWaypoint(waypoint, candidate, variables)));
                    if (waypoint.waypoint() instanceof Assumption) {
                        statementAccesses.computeIfAbsent(candidate.event(), _ -> new LinkedHashSet<>())
                                .addAll(candidate.constrainedAccesses());
                    }
                }
                segmentEnc.add(waypointEnc);
            }
            segmentsEnc.add(segmentEnc);
        }
        // Every waypoint must be satisfied, even if there is nothing to order.
        final List<List<Map<Event, BooleanFormula>>> selectors = new ArrayList<>();
        constraints.add(encodeSegmentOrder(segmentsEnc, statementAccesses, selectors));
        if (property == Property.CAT_SPEC) {
            constraints.add(encodeFlaggedEdgeTargets(targetSelectors(resolvedWitness, selectors)));
        }
        final boolean hasValues = resolvedWitness.hasValueConstraints();
        if (segmentsEnc.size() > 1 || hasValues) {
            // Ranks are only compared for ordering segments and for reading values.
            final Set<Event> segmentCandidates = new LinkedHashSet<>();
            segmentsEnc.forEach(segment -> segment.forEach(waypoint -> segmentCandidates.addAll(waypoint.keySet())));
            final List<Init> inits = variables.values().stream()
                    .flatMap(variable -> variable.writes().stream())
                    .filter(Init.class::isInstance).map(Init.class::cast).distinct().toList();
            constraints.add(encodeExecutionOrder(segmentCandidates, inits, hasValues));
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeThreadBindings(Map<Integer, List<Thread>> threads) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        final Map<Thread, List<BooleanFormula>> bindingsOfThread = new HashMap<>();
        threads.forEach((id, candidates) -> {
            final List<BooleanFormula> bindings = candidates.stream().map(thread -> bound(id, thread)).toList();
            constraints.add(bmgr.or(bindings));
            constraints.add(atMostOne(bindings));
            candidates.forEach(thread -> bindingsOfThread.computeIfAbsent(thread, _ -> new ArrayList<>())
                    .add(bound(id, thread)));
        });
        bindingsOfThread.values().forEach(bindings -> constraints.add(atMostOne(bindings)));
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeBinding(ResolvedWaypoint waypoint, Event event) {
        final Thread thread = event.getThread();
        final BooleanFormula binding = bound(waypoint.threadId(), thread);
        if (!(waypoint.waypoint() instanceof FunctionEnter enter)) {
            return binding;
        }
        return bmgr.and(binding, bound(enter.threadId(), thread.getEntry().getCreator().getThread()));
    }

    private BooleanFormula atMostOne(List<BooleanFormula> formulas) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        for (int i = 0; i < formulas.size(); i++) {
            for (int j = i + 1; j < formulas.size(); j++) {
                constraints.add(bmgr.not(bmgr.and(formulas.get(i), formulas.get(j))));
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula bound(int id, Thread thread) {
        return bmgr.makeVariable("witness-thread " + id + " " + thread.getId());
    }

    private BooleanFormula encodeExecutionOrder(Set<Event> segmentCandidates, List<Init> inits,
            boolean hasValues) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(encodeRelationOrder(HB_RELATION));
        if (hasValues) {
            // Snapshots also respect communication inside atomic sections.
            constraints.add(encodeRelationOrder("com"));
        }

        // Atomic sections restrict the interleaving, independently of whether assumptions constrain values.
        final Set<Event> waypointEvents = new LinkedHashSet<>(segmentCandidates);
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            waypointEvents.add(end.getBegin());
            waypointEvents.add(end);
        }
        final Set<Event> orderedEvents = new LinkedHashSet<>(program.getThreadEvents(MemoryCoreEvent.class));
        orderedEvents.addAll(waypointEvents);
        constraints.add(encodeProgramOrder(waypointEvents, orderedEvents));
        for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
            constraints.add(encodeAtomicInterval(end.getBegin(), end, orderedEvents));
        }
        for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
            constraints.add(encodeAtomicInterval(store.getLoadEvent(), store, orderedEvents));
        }

        if (hasValues) {
            for (Init init : inits) {
                for (Event event : orderedEvents) {
                    if (!(event instanceof Init)) {
                        constraints.add(bmgr.implication(context.execution(event), before(init, event)));
                    }
                }
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeRelationOrder(String name) {
        final Relation relation = context.getTask().getMemoryModel().getRelation(name);
        if (relation == null) {
            throw new IllegalArgumentException("Witness ordering requires the '" + name + "' relation");
        }
        if (!context.isEncoded(relation.getDefinition())) {
            throw new IllegalStateException("Witness ordering relation is not encoded: " + name);
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        final var may = context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(relation).getMaySet();
        final EncodingContext.EdgeEncoder edge = context.edge(relation);
        // Clocks respect every actual edge, but may also order unrelated events.
        may.apply((first, second) -> constraints.add(bmgr.implication(edge.encode(first, second), before(first, second))));
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeProgramOrder(Set<Event> waypoints, Collection<Event> events) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        // Waypoints may refer to non-memory events outside the memory-model relation.
        for (Event waypoint : waypoints) {
            for (Event event : events) {
                if (!waypoint.getThread().equals(event.getThread()) || waypoint == event
                        || (waypoints.contains(event) && event.getGlobalId() < waypoint.getGlobalId())) {
                    continue;
                }
                final BooleanFormula order = waypoint.getGlobalId() < event.getGlobalId()
                        ? before(waypoint, event) : before(event, waypoint);
                constraints.add(bmgr.implication(context.execution(waypoint, event), order));
            }
        }
        return bmgr.and(constraints);
    }

    /*
     * Fills 'selectorsOut' with the selector of each candidate, per segment and waypoint.
     *
     * Each waypoint selects one executed candidate event satisfying it. Every selected event of a segment is ordered
     * after every selected event of the previous segment, so all waypoints of a segment (e.g., both race targets)
     * follow the previous segment. The order among the events of one segment is left open.
     * Besides, the accesses to the constrained variables in the selected statement instance of an assumption
     * lie after the previous segment's events and before the next segment's events.
     */
    private BooleanFormula encodeSegmentOrder(List<List<Map<Event, BooleanFormula>>> segmentsEnc,
            Map<Event, Set<Event>> statementAccesses, List<List<Map<Event, BooleanFormula>>> selectorsOut) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        Map<Event, List<BooleanFormula>> previousSelectors = Map.of();
        for (int segmentIndex = 0; segmentIndex < segmentsEnc.size(); segmentIndex++) {
            final Map<Event, List<BooleanFormula>> selectors = new LinkedHashMap<>();
            final List<Map<Event, BooleanFormula>> waypoints = segmentsEnc.get(segmentIndex);
            final List<Map<Event, BooleanFormula>> segmentSelectors = new ArrayList<>();
            for (int waypointIndex = 0; waypointIndex < waypoints.size(); waypointIndex++) {
                final List<BooleanFormula> waypointSelectors = new ArrayList<>();
                final Map<Event, BooleanFormula> selectorOfCandidate = new LinkedHashMap<>();
                for (var candidate : waypoints.get(waypointIndex).entrySet()) {
                    final Event event = candidate.getKey();
                    final BooleanFormula selector = bmgr.makeVariable("witness-segment " + segmentIndex + " "
                            + waypointIndex + " " + event.getGlobalId());
                    waypointSelectors.add(selector);
                    selectorOfCandidate.put(event, selector);
                    selectors.computeIfAbsent(event, _ -> new ArrayList<>()).add(selector);
                    constraints.add(bmgr.implication(selector, candidate.getValue()));
                    for (var previous : previousSelectors.entrySet()) {
                        final Event previousEvent = previous.getKey();
                        final BooleanFormula both = bmgr.and(bmgr.or(previous.getValue()), selector);
                        constraints.add(bmgr.implication(both, before(previousEvent, event)));
                        for (Event access : statementAccesses.getOrDefault(event, Set.of())) {
                            if (access != previousEvent) {
                                constraints.add(bmgr.implication(bmgr.and(both, context.execution(access)),
                                        before(previousEvent, access)));
                            }
                        }
                        for (Event access : statementAccesses.getOrDefault(previousEvent, Set.of())) {
                            if (access != event) {
                                constraints.add(bmgr.implication(bmgr.and(both, context.execution(access)),
                                        before(access, event)));
                            }
                        }
                    }
                }
                constraints.add(bmgr.or(waypointSelectors));
                segmentSelectors.add(selectorOfCandidate);
            }
            selectorsOut.add(segmentSelectors);
            previousSelectors = selectors;
        }
        return bmgr.and(constraints);
    }

    private static List<Map<Event, BooleanFormula>> targetSelectors(ResolvedWitness witness,
            List<List<Map<Event, BooleanFormula>>> selectors) {
        final List<Map<Event, BooleanFormula>> result = new ArrayList<>();
        for (int segmentIndex = 0; segmentIndex < witness.segments().size(); segmentIndex++) {
            final List<ResolvedWaypoint> waypoints = witness.segments().get(segmentIndex).waypoints();
            for (int waypointIndex = 0; waypointIndex < waypoints.size(); waypointIndex++) {
                if (waypoints.get(waypointIndex).waypoint() instanceof Target) {
                    result.add(selectors.get(segmentIndex).get(waypointIndex));
                }
            }
        }
        return result;
    }

    // The selected target events form an edge of a flagged relation that must be empty for the specification to hold.
    private BooleanFormula encodeFlaggedEdgeTargets(List<Map<Event, BooleanFormula>> targets) {
        if (targets.isEmpty()) {
            return bmgr.makeTrue();
        }
        if (targets.size() > 2) {
            throw new IllegalArgumentException("Witness for a CAT specification has more than two targets");
        }
        final List<Relation> relations = context.getTask().getMemoryModel().getAxioms().stream()
                .filter(axiom -> axiom.isFlagged() && axiom.isNegated() && axiom instanceof Emptiness)
                .map(Axiom::getRelation)
                .toList();
        if (relations.isEmpty()) {
            throw new IllegalArgumentException("Witness targets require a flagged non-emptiness axiom");
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        if (targets.size() == 2) {
            for (var first : targets.getFirst().entrySet()) {
                for (var second : targets.getLast().entrySet()) {
                    final Event e1 = first.getKey();
                    final Event e2 = second.getKey();
                    final List<BooleanFormula> edges = new ArrayList<>();
                    for (Relation relation : relations) {
                        final EncodingContext.EdgeEncoder edge = edgeEncoder(relation);
                        edges.add(edge.encode(e1, e2));
                        edges.add(edge.encode(e2, e1));
                    }
                    constraints.add(bmgr.implication(bmgr.and(first.getValue(), second.getValue()), bmgr.or(edges)));
                }
            }
        } else {
            for (var target : targets.getFirst().entrySet()) {
                final Event event = target.getKey();
                final List<BooleanFormula> edges = new ArrayList<>();
                for (Relation relation : relations) {
                    final EncodingContext.EdgeEncoder edge = edgeEncoder(relation);
                    mayGraph(relation).apply((e1, e2) -> {
                        if (e1 == event || e2 == event) {
                            edges.add(edge.encode(e1, e2));
                        }
                    });
                }
                constraints.add(bmgr.implication(target.getValue(), bmgr.or(edges)));
            }
        }
        return bmgr.and(constraints);
    }

    private EncodingContext.EdgeEncoder edgeEncoder(Relation relation) {
        if (!context.isEncoded(relation.getDefinition())) {
            throw new IllegalStateException("Flagged relation is not encoded: " + relation.getNameOrTerm());
        }
        return context.edge(relation);
    }

    private EventGraph mayGraph(Relation relation) {
        return context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(relation).getMaySet();
    }

    private BooleanFormula encodeAtomicInterval(Event begin, Event end, Collection<Event> events) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(bmgr.implication(context.execution(begin, end), before(begin, end)));
        for (Event event : events) {
            if (!event.getThread().equals(begin.getThread()) && !(event instanceof Init)) {
                constraints.add(bmgr.implication(bmgr.and(context.execution(begin, end), context.execution(event)),
                        bmgr.or(before(event, begin), before(end, event))));
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula before(Event first, Event second) {
        return bvmgr.lessThan(bvmgr.makeVariable(rankWidth, clockPrefix + first.getGlobalId()),
                bvmgr.makeVariable(rankWidth, clockPrefix + second.getGlobalId()), false);
    }

    private BooleanFormula encodeWaypoint(ResolvedWaypoint waypoint, Candidate candidate,
            Map<String, ResolvedVariable> variables) {
        if (waypoint.assertionViolation()) {
            final Assert assertion = (Assert) candidate.event();
            return bmgr.and(context.execution(assertion), bmgr.not(context.getExpressionEncoder()
                    .encodeBooleanAt(assertion.getExpression(), assertion).formula()));
        }
        if (!(waypoint.waypoint() instanceof Assumption assumption)) {
            return context.execution(candidate.event());
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(context.execution(candidate.event()));
        // Use the first executed event of this statement instance.
        for (Event previous : candidate.earlierInStatementInstance()) {
            constraints.add(bmgr.not(context.execution(previous)));
        }
        constraints.add(encodeAssumption(assumption.expression(), candidate.event(), variables));
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeAssumption(AssumptionExpression assumption, Event position,
            Map<String, ResolvedVariable> variables) {
        return switch (assumption) {
            case BooleanConstant(boolean value) -> bmgr.makeBoolean(value);
            case Conjunction(AssumptionExpression left, AssumptionExpression right) ->
                    bmgr.and(encodeAssumption(left, position, variables), encodeAssumption(right, position, variables));
            case VariableEquality(String name, BigInteger value) -> {
                final ResolvedVariable variable = variables.get(name);
                if (variable == null) {
                    // The variable does not exist in this bounded program.
                    yield bmgr.makeFalse();
                }
                final MemoryObject object = variable.object();
                final List<Store> writes = variable.writes();
                yield bmgr.or(writes.stream().map(write -> bmgr.and(
                        encodeLastWrite(write, object, position, writes),
                        context.getExpressionEncoder().equal(context.value(write), literal(write, value)))).toList());
            }
        };
    }

    private BooleanFormula encodeLastWrite(Store write, MemoryObject object, Event position, List<Store> writes) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(context.execution(write));
        constraints.add(writesTo(write, object));
        constraints.add(before(write, position));
        for (Store other : writes) {
            if (other != write && other != position) {
                // Strict comparisons exclude equal clocks hiding an intervening write.
                constraints.add(bmgr.implication(bmgr.and(context.execution(other), writesTo(other, object)),
                        bmgr.or(before(other, write), before(position, other))));
            }
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula writesTo(Store write, MemoryObject object) {
        return context.getExpressionEncoder().equal(context.address(write), context.address(object));
    }

    private Expression literal(Store write, BigInteger value) {
        final var expressions = context.getExpressionFactory();
        return switch (write.getAccessType()) {
            case IntegerType type -> expressions.makeValue(value, type);
            case BooleanType _ -> expressions.makeValue(value.signum() != 0);
            default -> throw new IllegalArgumentException("Witness constrains a non-integral write at " + write);
        };
    }
}
