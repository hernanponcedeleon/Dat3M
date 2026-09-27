package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.verification.WitnessValidationTask;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.nio.file.Path;
import java.util.*;

/**
 * Witness data is interpreted as follows:
 *
 * Threads: witness ID 0 identifies the main thread. A function_enter waypoint gives the
 * parent's witness ID and the thread-creation location. The thread created there
 * receives the next witness ID (1, 2, ...) and must start executing. Each witness ID
 * identifies one program thread, and each program thread receives at most one witness ID.
 *
 * Locations: events are matched by source line and file name, ignoring directories.
 * Multiple events can match a location, for example after loop unrolling.
 *
 * Assumptions: supported constraints are Boolean constants, expressions of the form
 * variable == integer_literal, or conjunctions of these. Floating-point assumptions are
 * currently unsupported. Variables must be bare identifiers; array indexing such as
 * v[0], member access, and pointer dereferences are currently unsupported. Each
 * equality requires an executed load at the waypoint location whose alias analysis
 * includes a memory object named variable, with a result equal to integer_literal. If
 * several loads match an equality, at least one must execute and return the required
 * value. Every equality in a conjunction must hold.
 *
 * Targets: at least one event in the specified thread at the
 * target source location must execute.
 *
 * Every waypoint must satisfy the requirement for its type: the child thread starts
 * executing, the assumption holds, or an event at the target executes.
 * This encoder rejects unmatched waypoints.
 *
 * Segment order: to order segments, at least one executed candidate event is selected
 * per segment. These candidates are collected independently of the assumption-value
 * constraints. Integer clocks place selected events from consecutive segments in
 * strictly increasing order. Clocks also respect every encoded hb-consistency edge and
 * program order between executed candidate events in the same thread. Thus, the witness
 * order must be compatible with the memory model, while unrelated events may also be ordered.
 */
public final class SvcompWitnessEncoder {

    private static final Logger logger = LoggerFactory.getLogger(SvcompWitnessEncoder.class);
    private static final String HB_RELATION = "hb-consistency";
    private static final String WITNESS_CLOCK = "witness-hb";

    private final EncodingContext context;
    private final SvcompWitness witness;
    private final Program program;
    private final BooleanFormulaManager bmgr;
    private final Map<FunctionEnter, Thread> enteredThreads = new IdentityHashMap<>();

    private SvcompWitnessEncoder(EncodingContext context, SvcompWitness witness) {
        this.context = context;
        this.witness = witness;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
    }

    public static SvcompWitnessEncoder withContext(EncodingContext context) {
        if (!(context.getTask() instanceof WitnessValidationTask task)) {
            throw new IllegalArgumentException("Witness encoding requires a witness validation task");
        }
        return new SvcompWitnessEncoder(context, task.getWitness());
    }

    public BooleanFormula encode() {
        logger.info("Encoding witness");
        final Map<Integer, Thread> threads = resolveThreads();
        final List<BooleanFormula> constraints = new ArrayList<>();
        final List<List<Event>> segmentEvents = new ArrayList<>();
        for (Segment segment : witness.segments()) {
            final List<BooleanFormula> waypointsEnc = new ArrayList<>();
            final Set<Event> candidates = new LinkedHashSet<>();
            for (Waypoint waypoint : segment.waypoints()) {
                final List<Event> events = eventsForWaypoint(waypoint, threads);
                waypointsEnc.add(encodeWaypoint(waypoint, events));
                candidates.addAll(events);
            }
            if (!waypointsEnc.isEmpty()) {
                constraints.add(bmgr.and(waypointsEnc));
                if (candidates.isEmpty()) {
                    throw new IllegalArgumentException("Witness segment matches no program event: " + segment);
                }
                segmentEvents.add(List.copyOf(candidates));
            }
        }
        if (segmentEvents.size() > 1) {
            constraints.add(encodeSegmentOrder(segmentEvents));
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeSegmentOrder(List<List<Event>> segments) {
        final Relation hb = context.getTask().getMemoryModel().getRelation(HB_RELATION);
        if (hb == null) {
            throw new IllegalArgumentException("Witness ordering requires the '" + HB_RELATION + "' relation");
        }
        if (!context.isEncoded(hb.getDefinition())) {
            throw new IllegalStateException("Witness ordering relation is not encoded: " + HB_RELATION);
        }
        final var imgr = context.getFormulaManager().getIntegerFormulaManager();
        final List<BooleanFormula> constraints = new ArrayList<>();
        final var may = context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(hb).getMaySet();
        final EncodingContext.EdgeEncoder edge = context.edge(hb);
        // The witness supplies a linearization of hb-consistency. Clock values
        // must respect every actual edge, but may also order unrelated events.
        may.apply((first, second) -> constraints.add(bmgr.implication(edge.encode(first, second),
                imgr.lessThan(clock(first), clock(second)))));

        // Some source waypoints map to non-memory events (for example, a thread
        // creation). They need their program order even when they are outside
        // the domain of the memory-model relation.
        final List<Event> segmentCandidates = segments.stream().flatMap(Collection::stream).distinct().toList();
        for (Event first : segmentCandidates) {
            for (Event second : segmentCandidates) {
                if (first != second && first.getThread().equals(second.getThread())
                        && first.getGlobalId() < second.getGlobalId()) {
                    constraints.add(bmgr.implication(context.execution(first, second),
                            imgr.lessThan(clock(first), clock(second))));
                }
            }
        }

        List<BooleanFormula> previousSelectors = List.of();
        List<Event> previousEvents = List.of();
        int segmentIndex = 0;
        for (List<Event> events : segments) {
            final List<BooleanFormula> selected = new ArrayList<>();
            for (Event event : events) {
                final BooleanFormula selector = bmgr.makeVariable("witness-segment " + segmentIndex + " " + event.getGlobalId());
                selected.add(selector);
                constraints.add(bmgr.implication(selector, context.execution(event)));
            }
            constraints.add(bmgr.or(selected));
            for (int i = 0; i < previousSelectors.size(); i++) {
                for (int j = 0; j < selected.size(); j++) {
                    constraints.add(bmgr.implication(bmgr.and(previousSelectors.get(i), selected.get(j)),
                            imgr.lessThan(clock(previousEvents.get(i)), clock(events.get(j)))));
                }
            }
            previousSelectors = selected;
            previousEvents = events;
            segmentIndex++;
        }
        return bmgr.and(constraints);
    }

    private IntegerFormula clock(Event event) {
        return context.clockVariable(WITNESS_CLOCK, event);
    }

    private List<Event> eventsForWaypoint(Waypoint waypoint, Map<Integer, Thread> threads) {
        if (waypoint instanceof FunctionEnter enter) {
            return List.of(enteredThreads.get(enter).getEntry());
        }
        final Thread thread = Optional.ofNullable(threads.get(waypoint.threadId()))
                .orElseThrow(() -> new IllegalArgumentException(
                        "Witness refers to unknown thread " + waypoint.threadId()));
        final boolean loadsOnly = waypoint instanceof Assumption assumption
                && !(assumption.expression() instanceof BooleanConstant constant && constant.value());
        final List<Event> candidates = thread.getEvents().stream()
                .filter(event -> !loadsOnly || event instanceof Load)
                .filter(event -> matches(event, waypoint.location())).toList();
        if (waypoint instanceof Target target && candidates.isEmpty()) {
            throw new IllegalArgumentException("Witness target at %s:%d matches no event"
                    .formatted(target.location().fileName(), target.location().line()));
        }
        return candidates;
    }

    private BooleanFormula encodeWaypoint(Waypoint waypoint, List<Event> events) {
        if (waypoint instanceof Assumption assumption) {
            final List<Load> loads = events.stream().filter(Load.class::isInstance).map(Load.class::cast).toList();
            final Expression expression = resolveAssumption(assumption.expression(), assumption.location(), loads);
            return context.getExpressionEncoder().encodeBooleanFinal(expression).formula();
        }
        return bmgr.or(events.stream().map(context::execution).toList());
    }

    private Map<Integer, Thread> resolveThreads() {
        final Map<Integer, Thread> result = new HashMap<>();
        result.put(0, program.getMainThread().orElseThrow(
                () -> new IllegalArgumentException("Witness validation requires a designated main thread")));
        final List<Thread> remainingThreads = new ArrayList<>(program.getThreads().stream()
                .filter(thread -> thread.getEntry().isSpawned()).toList());
        final List<FunctionEnter> entries = witness.segments().stream()
                .flatMap(segment -> segment.waypoints().stream())
                .filter(FunctionEnter.class::isInstance)
                .map(FunctionEnter.class::cast)
                .toList();
        for (FunctionEnter enter : entries) {
            final Thread parent = Optional.ofNullable(result.get(enter.threadId()))
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Witness creates a thread from unknown thread " + enter.threadId()));
            final Thread child = remainingThreads.stream()
                    .filter(thread -> {
                        final ThreadCreate createEvent = thread.getEntry().getCreator();
                        return createEvent.getThread().equals(parent) && matches(createEvent, enter.location());
                    })
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Witness function entry at %s:%d matches no thread creation"
                                    .formatted(enter.location().fileName(), enter.location().line())));
            result.put(result.size(), child);
            enteredThreads.put(enter, child);
            remainingThreads.remove(child);
        }
        return result;
    }

    private static boolean matches(Event event, Location location) {
        final SourceLocation source = event.getMetadata(SourceLocation.class);
        return source instanceof SourceLocation.Generic generic
                && generic.lineNumber() == location.line()
                && sameFile(generic.sourcePath(), location.fileName());
    }

    private static boolean sameFile(Path first, Path second) {
        return first.getFileName().equals(second.getFileName());
    }

    private Expression resolveAssumption(AssumptionExpression assumption, Location location, List<Load> loads) {
        final ExpressionFactory expressions = context.getExpressionFactory();
        if (assumption instanceof BooleanConstant constant) {
            return expressions.makeValue(constant.value());
        }
        if (assumption instanceof Conjunction conjunction) {
            return expressions.makeAnd(resolveAssumption(conjunction.left(), location, loads),
                    resolveAssumption(conjunction.right(), location, loads));
        }
        final VariableEquality equality = (VariableEquality) assumption;
        final AliasAnalysis alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        final List<Expression> candidates = loads.stream()
                .filter(load -> alias.addressableObjects(load).stream()
                        .anyMatch(object -> object.hasName() && object.getName().equals(equality.variable())))
                .map(load -> expressions.makeAnd(context.getExpressionEncoder().wrap(context.execution(load)),
                        expressions.makeEQ(context.value(load), literal(load, equality.value()))))
                .toList();
        if (candidates.isEmpty()) {
            throw new IllegalArgumentException("Witness assumption for '%s' at %s:%d matches no read"
                    .formatted(equality.variable(), location.fileName(), location.line()));
        }
        return candidates.stream().reduce(expressions::makeOr).orElseThrow();
    }

    private Expression literal(Load load, BigInteger value) {
        final ExpressionFactory expressions = context.getExpressionFactory();
        if (load.getAccessType() instanceof IntegerType type) {
            return expressions.makeValue(value, type);
        }
        if (load.getAccessType() instanceof BooleanType) {
            return expressions.makeValue(value.signum() != 0);
        }
        throw new IllegalArgumentException("Witness constrains a non-integral read at " + load);
    }
}
