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
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.WitnessValidationTask;
import com.dat3m.dartagnan.witness.svcomp.SvcompViolationWitness;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.Candidate;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedVariable;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWaypoint;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWitness;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.math.BigInteger;
import java.util.*;

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
 * selected target events must also constitute the violation, as encoded by {@link WitnessTargetEncoder}.
 *
 * Every waypoint must satisfy the requirement for its type: the child thread starts
 * executing, the assumption holds, or the target is reached.
 *
 * Segment order: to order segments, at least one executed candidate event is selected
 * per segment. A selected assumption event must also satisfy its value constraints.
 * Bitvector ranks, provided by {@link WitnessOrderEncoder}, place selected events from consecutive segments in
 * strictly increasing order. Thus, the witness order must be compatible with the memory model.
 * The accesses to the variables of a selected assumption, within the same statement instance,
 * are also placed after the previous segment's events and before the next segment's events,
 * without ordering them among each other.
 */
public final class SvcompWitnessEncoder {

    private static final Logger logger = LoggerFactory.getLogger(SvcompWitnessEncoder.class);

    /**
     * The condition under which a candidate event satisfies its waypoint, and the literal selecting it.
     * The candidate also carries the accesses of its statement instance that the ordering constrains.
     */
    private record CandidateEncoding(Candidate candidate, BooleanFormula condition, BooleanFormula selector) { }

    /** A waypoint with the encodings of all events that may satisfy it. */
    private record WaypointEncoding(Waypoint waypoint, Map<Event, CandidateEncoding> candidates) {

        Map<Event, BooleanFormula> selectors() {
            final Map<Event, BooleanFormula> result = new LinkedHashMap<>();
            candidates.forEach((event, candidate) -> result.put(event, candidate.selector()));
            return result;
        }
    }

    private record SegmentEncoding(List<WaypointEncoding> waypoints) { }

    private final EncodingContext context;
    private final SvcompViolationWitness witness;
    private final Property property;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final WitnessOrderEncoder order;
    private final WitnessTargetEncoder targets;

    private SvcompWitnessEncoder(EncodingContext context, SvcompViolationWitness witness, Property property) {
        this.context = context;
        this.witness = witness;
        this.property = property;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.order = new WitnessOrderEncoder(context);
        this.targets = new WitnessTargetEncoder(context);
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
        final List<SegmentEncoding> segments = encodeSegments(resolvedWitness);
        // Every waypoint must be satisfied, even if there is nothing to order.
        constraints.add(encodeSegmentOrder(segments));
        if (property == Property.CAT_SPEC) {
            constraints.add(targets.encode(segments.stream()
                    .flatMap(segment -> segment.waypoints().stream())
                    .filter(waypoint -> waypoint.waypoint() instanceof Target)
                    .map(WaypointEncoding::selectors)
                    .toList()));
        }
        final boolean hasValues = resolvedWitness.hasValueConstraints();
        if (segments.size() > 1 || hasValues) {
            // Ranks are only compared for ordering segments and for reading values.
            final Set<Event> segmentCandidates = new LinkedHashSet<>();
            segments.forEach(segment -> segment.waypoints()
                    .forEach(waypoint -> segmentCandidates.addAll(waypoint.candidates().keySet())));
            final List<Init> inits = variables.values().stream()
                    .flatMap(variable -> variable.writes().stream())
                    .filter(Init.class::isInstance).map(Init.class::cast).distinct().toList();
            constraints.add(order.encode(segmentCandidates, inits, hasValues));
        }
        return bmgr.and(constraints);
    }

    // For each non-empty segment and each of its waypoints, the encoding of every candidate event.
    private List<SegmentEncoding> encodeSegments(ResolvedWitness resolvedWitness) {
        final List<SegmentEncoding> result = new ArrayList<>();
        for (int segmentIndex = 0; segmentIndex < resolvedWitness.segments().size(); segmentIndex++) {
            final List<ResolvedWaypoint> waypoints = resolvedWitness.segments().get(segmentIndex).waypoints();
            final List<WaypointEncoding> segment = new ArrayList<>();
            for (int waypointIndex = 0; waypointIndex < waypoints.size(); waypointIndex++) {
                final ResolvedWaypoint waypoint = waypoints.get(waypointIndex);
                final Map<Event, CandidateEncoding> candidates = new LinkedHashMap<>();
                for (Candidate candidate : waypoint.candidates()) {
                    final Event event = candidate.event();
                    final BooleanFormula condition = bmgr.and(encodeBinding(waypoint, event),
                            encodeWaypoint(waypoint, candidate, resolvedWitness.variables()));
                    final BooleanFormula selector = bmgr.makeVariable("witness-segment " + segmentIndex + " "
                            + waypointIndex + " " + event.getGlobalId());
                    candidates.put(event, new CandidateEncoding(candidate, condition, selector));
                }
                segment.add(new WaypointEncoding(waypoint.waypoint(), candidates));
            }
            result.add(new SegmentEncoding(segment));
        }
        return result;
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

    /*
     * Each waypoint selects one executed candidate event satisfying it. Every selected event of a segment is ordered
     * after every selected event of the previous segment, so all waypoints of a segment (e.g., both race targets)
     * follow the previous segment. The order among the events of one segment is left open.
     * Besides, the accesses to the constrained variables in the selected statement instance of an assumption
     * lie after the previous segment's events and before the next segment's events.
     */
    private BooleanFormula encodeSegmentOrder(List<SegmentEncoding> segments) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        SegmentEncoding previousSegment = null;
        for (SegmentEncoding segment : segments) {
            for (WaypointEncoding waypoint : segment.waypoints()) {
                for (CandidateEncoding candidate : waypoint.candidates().values()) {
                    constraints.add(bmgr.implication(candidate.selector(), candidate.condition()));
                    if (previousSegment != null) {
                        for (WaypointEncoding previousWaypoint : previousSegment.waypoints()) {
                            for (CandidateEncoding previous : previousWaypoint.candidates().values()) {
                                constraints.add(encodeOrder(previous, candidate));
                            }
                        }
                    }
                }
                constraints.add(bmgr.or(waypoint.selectors().values().stream().toList()));
            }
            previousSegment = segment;
        }
        return bmgr.and(constraints);
    }

    // If both candidates are selected, the first precedes the second, and so do the accesses of their statements.
    private BooleanFormula encodeOrder(CandidateEncoding first, CandidateEncoding second) {
        final Event firstEvent = first.candidate().event();
        final Event secondEvent = second.candidate().event();
        final BooleanFormula both = bmgr.and(first.selector(), second.selector());
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(order.before(firstEvent, secondEvent));
        for (Event access : second.candidate().constrainedAccesses()) {
            if (access != firstEvent) {
                constraints.add(bmgr.implication(context.execution(access), order.before(firstEvent, access)));
            }
        }
        for (Event access : first.candidate().constrainedAccesses()) {
            if (access != secondEvent) {
                constraints.add(bmgr.implication(context.execution(access), order.before(access, secondEvent)));
            }
        }
        return bmgr.implication(both, bmgr.and(constraints));
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
        constraints.add(order.before(write, position));
        for (Store other : writes) {
            if (other != write && other != position) {
                // Strict comparisons exclude equal clocks hiding an intervening write.
                constraints.add(bmgr.implication(bmgr.and(context.execution(other), writesTo(other, object)),
                        bmgr.or(order.before(other, write), order.before(position, other))));
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
