package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.smt.EncodingUtils;
import com.dat3m.dartagnan.task.verification.WitnessValidationTask;
import com.dat3m.dartagnan.witness.svcomp.ViolationWitness;
import com.dat3m.dartagnan.witness.svcomp.Witness.*;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver.Candidate;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver.ResolvedVariable;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver.ResolvedWaypoint;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver.ResolvedWitness;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Constrains executions to follow a resolved witness by selecting compatible
 * waypoint candidates and binding witness IDs to distinct program threads.
 * Assumptions read variable values immediately before their source statement.
 * Segment ordering and target violations are handled by
 * {@link SvcompWitnessOrderEncoder} and {@link SvcompWitnessPropertyEncoder}.
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
    private final ViolationWitness witness;
    private final Property property;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final SvcompWitnessOrderEncoder order;
    private final SvcompWitnessPropertyEncoder propertyEncoder;

    private SvcompWitnessEncoder(EncodingContext context, ViolationWitness witness, Property property) {
        this.context = context;
        this.witness = witness;
        this.property = property;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.order = new SvcompWitnessOrderEncoder(context);
        this.propertyEncoder = new SvcompWitnessPropertyEncoder(context, property);
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
        final ResolvedWitness resolvedWitness = WitnessResolver.resolve(witness, program, alias, property);
        final Map<String, ResolvedVariable> variables = resolvedWitness.variables();
        final List<BooleanFormula> constraints = new ArrayList<>();
        // If the witness needs more threads than this bounded program contains, the bindings are unsatisfiable,
        // which lets the solver check reachable bounds and retry.
        constraints.add(encodeThreadBindings(resolvedWitness.threads()));
        final List<SegmentEncoding> segments = encodeSegments(resolvedWitness);
        // Every waypoint must be satisfied, even if there is nothing to order.
        constraints.add(encodeSegmentOrder(segments));
        constraints.add(propertyEncoder.encode(segments.stream()
                .flatMap(segment -> segment.waypoints().stream())
                .filter(waypoint -> waypoint.waypoint() instanceof Target)
                .map(WaypointEncoding::selectors)
                .toList()));
        final boolean hasValues = resolvedWitness.hasValueConstraints();
        if (segments.size() > 1 || hasValues) {
            // Ranks are only compared for ordering segments and for reading values.
            final Set<Event> segmentCandidates = new LinkedHashSet<>();
            segments.forEach(segment -> segment.waypoints()
                    .forEach(waypoint -> segmentCandidates.addAll(waypoint.candidates().keySet())));
            final List<Init> inits = variables.values().stream()
                    .flatMap(variable -> variable.writes().stream())
                    .filter(Init.class::isInstance).map(Init.class::cast).distinct().toList();
            constraints.add(order.encode(segmentCandidates, inits));
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
        final EncodingUtils utils = context.getFormulaManager().getEncodingUtils();
        final List<BooleanFormula> constraints = new ArrayList<>();
        final Map<Thread, List<BooleanFormula>> bindingsOfThread = new HashMap<>();
        threads.forEach((id, candidates) -> {
            final List<BooleanFormula> bindings = candidates.stream().map(thread -> bound(id, thread)).toList();
            constraints.add(bmgr.or(bindings));
            constraints.add(utils.atMostOnePairwise(bindings));
            candidates.forEach(thread -> bindingsOfThread.computeIfAbsent(thread, _ -> new ArrayList<>())
                    .add(bound(id, thread)));
        });
        bindingsOfThread.values().forEach(bindings -> constraints.add(utils.atMostOnePairwise(bindings)));
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
        for (int index = 0; index < segments.size(); index++) {
            for (WaypointEncoding waypoint : segments.get(index).waypoints()) {
                for (CandidateEncoding candidate : waypoint.candidates().values()) {
                    constraints.add(bmgr.implication(candidate.selector(), candidate.condition()));
                }
                constraints.add(bmgr.or(waypoint.selectors().values().stream().toList()));
            }
            if (index > 0) {
                constraints.add(encodeBoundary(segments.get(index - 1), segments.get(index), order.separator(index)));
            }
        }
        return bmgr.and(constraints);
    }

    /*
     * If candidates are selected, every one of the previous segment precedes every one of the next segment,
     * and so do the accesses of their statements. A separator rank between both segments expresses this
     * with one comparison per candidate, instead of one per pair of candidates.
     * An access that is itself a candidate of the neighboring segment may only be ordered relative to the other
     * selected candidates, so these accesses are compared with each of them.
     */
    private BooleanFormula encodeBoundary(SegmentEncoding previous, SegmentEncoding next, BitvectorFormula separator) {
        final List<CandidateEncoding> previousCandidates = candidatesOf(previous);
        final List<CandidateEncoding> nextCandidates = candidatesOf(next);
        final Set<Event> previousEvents = eventsOf(previousCandidates);
        final Set<Event> nextEvents = eventsOf(nextCandidates);
        final List<BooleanFormula> constraints = new ArrayList<>();
        for (CandidateEncoding first : previousCandidates) {
            constraints.add(bmgr.implication(first.selector(), order.upperBound(first.candidate().event(), separator)));
            for (Event access : first.candidate().constrainedAccesses()) {
                if (nextEvents.contains(access)) {
                    for (CandidateEncoding second : nextCandidates) {
                        if (second.candidate().event() != access) {
                            constraints.add(bmgr.implication(
                                    bmgr.and(first.selector(), second.selector(), context.execution(access)),
                                    order.before(access, second.candidate().event())));
                        }
                    }
                } else {
                    constraints.add(bmgr.implication(bmgr.and(first.selector(), context.execution(access)),
                            order.upperBound(access, separator)));
                }
            }
        }
        for (CandidateEncoding second : nextCandidates) {
            constraints.add(bmgr.implication(second.selector(),
                    order.lowerBound(second.candidate().event(), separator)));
            for (Event access : second.candidate().constrainedAccesses()) {
                if (previousEvents.contains(access)) {
                    for (CandidateEncoding first : previousCandidates) {
                        if (first.candidate().event() != access) {
                            constraints.add(bmgr.implication(
                                    bmgr.and(first.selector(), second.selector(), context.execution(access)),
                                    order.before(first.candidate().event(), access)));
                        }
                    }
                } else {
                    constraints.add(bmgr.implication(bmgr.and(second.selector(), context.execution(access)),
                            order.lowerBound(access, separator)));
                }
            }
        }
        return bmgr.and(constraints);
    }

    private static List<CandidateEncoding> candidatesOf(SegmentEncoding segment) {
        return segment.waypoints().stream().flatMap(waypoint -> waypoint.candidates().values().stream()).toList();
    }

    private static Set<Event> eventsOf(List<CandidateEncoding> candidates) {
        return candidates.stream().map(candidate -> candidate.candidate().event()).collect(Collectors.toSet());
    }

    private BooleanFormula encodeWaypoint(ResolvedWaypoint waypoint, Candidate candidate,
            Map<String, ResolvedVariable> variables) {
        if (!(waypoint.waypoint() instanceof Assumption assumption)) {
            // For targets, SvcompWitnessPropertyEncoder encodes what else makes them a violation.
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

    // An equality holds if the last executed write to its variable (including initialization) before 'position'
    // in the witness clock wrote its value. All equalities of a conjunction refer to the same position.
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
