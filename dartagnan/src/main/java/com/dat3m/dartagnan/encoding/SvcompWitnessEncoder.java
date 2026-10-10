package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.RMWStore;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.WitnessValidationTask;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;

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
 * equality constrains the value of a uniquely named, statically allocated scalar memory
 * object immediately before the source statement. Its value comes from the last executed
 * write, including initialization, in the SV-COMP execution order. All equalities in a
 * conjunction refer to the same position. Register-only variables and partial writes
 * are currently unsupported.
 *
 * Targets: at least one event in the specified thread at the
 * target source location must execute.
 *
 * Every waypoint must satisfy the requirement for its type: the child thread starts
 * executing, the assumption holds, or an event at the target executes.
 * This encoder rejects unmatched waypoints.
 *
 * Segment order: to order segments, at least one executed candidate event is selected
 * per segment. A selected assumption event must also satisfy its value constraints.
 * Bitvector ranks place selected events from consecutive segments in
 * strictly increasing order. Ranks also respect every encoded hb-consistency edge and
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
    private final BitvectorFormulaManager bvmgr;
    private final int rankWidth;
    private final Map<MemoryObject, List<Store>> writesByObject = new HashMap<>();
    private final Map<FunctionEnter, Thread> enteredThreads = new IdentityHashMap<>();

    private SvcompWitnessEncoder(EncodingContext context, SvcompWitness witness) {
        this.context = context;
        this.witness = witness;
        this.program = context.getTask().getProgram();
        this.bmgr = context.getBooleanFormulaManager();
        this.bvmgr = context.getFormulaManager().getBitvectorFormulaManager();
        // Every integer ordering of N events can be ranked from 0 to N - 1.
        // Use unsigned comparisons without arithmetic, so ranks cannot wrap around.
        this.rankWidth = Math.max(1, Integer.SIZE - Integer.numberOfLeadingZeros(
                program.getThreadEvents().size() - 1));
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
        final List<Map<Event, BooleanFormula>> segmentsEnc = new ArrayList<>();
        for (Segment segment : witness.segments()) {
            final Map<Event, BooleanFormula> segmentEnc = new LinkedHashMap<>();
            for (Waypoint waypoint : segment.waypoints()) {
                final List<BooleanFormula> candidatesEnc = new ArrayList<>();
                for (Event event : eventsForWaypoint(waypoint, threads)) {
                    final BooleanFormula encoding = encodeWaypoint(waypoint, event);
                    candidatesEnc.add(encoding);
                    segmentEnc.merge(event, encoding, bmgr::and);
                }
                constraints.add(bmgr.or(candidatesEnc));
            }
            if (!segment.waypoints().isEmpty()) {
                segmentsEnc.add(segmentEnc);
            }
        }
        if (segmentsEnc.size() > 1 || !writesByObject.isEmpty()) {
            final Set<Event> segmentCandidates = new LinkedHashSet<>();
            segmentsEnc.forEach(segment -> segmentCandidates.addAll(segment.keySet()));
            constraints.add(encodeExecutionOrder(segmentCandidates));
            constraints.add(encodeSegmentOrder(segmentsEnc));
        }
        return bmgr.and(constraints);
    }

    private BooleanFormula encodeExecutionOrder(Set<Event> segmentCandidates) {
        final boolean hasValues = !writesByObject.isEmpty();
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(encodeRelationOrder(HB_RELATION));
        if (hasValues) {
            // Snapshots also respect communication inside atomic sections.
            constraints.add(encodeRelationOrder("com"));
        }

        final Set<Event> waypointEvents = new LinkedHashSet<>(segmentCandidates);
        if (hasValues) {
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                waypointEvents.add(end.getBegin());
                waypointEvents.add(end);
            }
        }
        final Set<Event> orderedEvents = new LinkedHashSet<>(program.getThreadEvents(MemoryCoreEvent.class));
        orderedEvents.addAll(waypointEvents);
        constraints.add(encodeProgramOrder(waypointEvents, orderedEvents));

        if (hasValues) {
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                constraints.add(encodeAtomicInterval(end.getBegin(), end, orderedEvents));
            }
            for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
                constraints.add(encodeAtomicInterval(store.getLoadEvent(), store, orderedEvents));
            }
            for (Init init : writesByObject.values().stream().flatMap(Collection::stream)
                    .filter(Init.class::isInstance).map(Init.class::cast).distinct().toList()) {
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

    private BooleanFormula encodeSegmentOrder(List<Map<Event, BooleanFormula>> segmentsEnc) {
        final List<BooleanFormula> constraints = new ArrayList<>();
        Map<Event, BooleanFormula> previousSelectors = Map.of();
        for (int segmentIndex = 0; segmentIndex < segmentsEnc.size(); segmentIndex++) {
            final Map<Event, BooleanFormula> selectors = new LinkedHashMap<>();
            for (var candidate : segmentsEnc.get(segmentIndex).entrySet()) {
                final Event event = candidate.getKey();
                final BooleanFormula selector = bmgr.makeVariable("witness-segment " + segmentIndex + " " + event.getGlobalId());
                selectors.put(event, selector);
                constraints.add(bmgr.implication(selector, candidate.getValue()));
                for (var previous : previousSelectors.entrySet()) {
                    constraints.add(bmgr.implication(bmgr.and(previous.getValue(), selector),
                            before(previous.getKey(), event)));
                }
            }
            constraints.add(bmgr.or(selectors.values()));
            previousSelectors = selectors;
        }
        return bmgr.and(constraints);
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
        final String name = context.getFormulaManager().escape(WITNESS_CLOCK) + " ";
        return bvmgr.lessThan(bvmgr.makeVariable(rankWidth, name + first.getGlobalId()),
                bvmgr.makeVariable(rankWidth, name + second.getGlobalId()), false);
    }

    private List<Event> eventsForWaypoint(Waypoint waypoint, Map<Integer, Thread> threads) {
        if (waypoint instanceof FunctionEnter enter) {
            return List.of(enteredThreads.get(enter).getEntry());
        }
        final Thread thread = Optional.ofNullable(threads.get(waypoint.threadId()))
                .orElseThrow(() -> new IllegalArgumentException(
                        "Witness refers to unknown thread " + waypoint.threadId()));
        final List<Event> candidates = thread.getEvents().stream()
                .filter(event -> !(waypoint instanceof Assumption) || !(event instanceof FunReturnMarker))
                .filter(event -> matches(event, waypoint.location())).toList();
        if (candidates.isEmpty()) {
            final String type = waypoint instanceof Assumption ? "assumption" : "target";
            throw new IllegalArgumentException("Witness %s at %s:%d matches no event"
                    .formatted(type, waypoint.location().fileName(), waypoint.location().line()));
        }
        return candidates;
    }

    private BooleanFormula encodeWaypoint(Waypoint waypoint, Event event) {
        if (!(waypoint instanceof Assumption assumption)) {
            return context.execution(event);
        }
        final List<BooleanFormula> constraints = new ArrayList<>();
        constraints.add(context.execution(event));
        // Use the first executed event of this occurrence of the source statement.
        for (Event previous = event.getPredecessor(); previous != null
                && matches(previous, assumption.location()); previous = previous.getPredecessor()) {
            constraints.add(bmgr.not(context.execution(previous)));
        }
        constraints.add(resolveAssumption(assumption.expression(), event));
        return bmgr.and(constraints);
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

    private BooleanFormula resolveAssumption(AssumptionExpression assumption, Event position) {
        if (assumption instanceof BooleanConstant constant) {
            return bmgr.makeBoolean(constant.value());
        }
        if (assumption instanceof Conjunction conjunction) {
            return bmgr.and(resolveAssumption(conjunction.left(), position),
                    resolveAssumption(conjunction.right(), position));
        }
        final VariableEquality equality = (VariableEquality) assumption;
        final List<MemoryObject> objects = program.getMemory().getObjects().stream()
                .filter(object -> object.hasName() && object.getName().equals(equality.variable())).toList();
        if (objects.size() != 1) {
            throw new IllegalArgumentException("Witness variable '%s' does not identify a unique memory object"
                    .formatted(equality.variable()));
        }
        final MemoryObject object = objects.get(0);
        final List<Store> writes = writesByObject.computeIfAbsent(object, this::writesForObject);
        return bmgr.or(writes.stream().map(write -> bmgr.and(
                encodeLastWrite(write, object, position, writes),
                context.getExpressionEncoder().equal(context.value(write), literal(write, equality.value())))).toList());
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

    private List<Store> writesForObject(MemoryObject object) {
        if (!object.isStaticallyAllocated() || !object.hasKnownSize()
                || !object.getInitializedFields().equals(Set.of(0))) {
            throw new IllegalArgumentException("Witness variable is not an initialized scalar: " + object);
        }
        final var type = object.getInitialValue(0).getType();
        if (!(type instanceof IntegerType || type instanceof BooleanType)
                || TypeFactory.getInstance().getMemorySizeInBytes(type) != object.getKnownSize()) {
            throw new IllegalArgumentException("Witness variable is not an integral scalar: " + object);
        }
        final AliasAnalysis alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        final List<Store> writes = program.getThreadEvents(Store.class).stream()
                .filter(write -> alias.addressableObjects(write).contains(object)).toList();
        for (Store write : writes) {
            if (!write.getAccessType().equals(type)) {
                throw new IllegalArgumentException("Witness variable has unsupported partial or differently typed writes: " + object);
            }
        }
        return writes;
    }

    private BooleanFormula writesTo(Store write, MemoryObject object) {
        return context.getExpressionEncoder().equal(context.address(write), context.address(object));
    }

    private Expression literal(Store write, BigInteger value) {
        final var expressions = context.getExpressionFactory();
        if (write.getAccessType() instanceof IntegerType type) {
            return expressions.makeValue(value, type);
        }
        if (write.getAccessType() instanceof BooleanType) {
            return expressions.makeValue(value.signum() != 0);
        }
        throw new IllegalArgumentException("Witness constrains a non-integral write at " + write);
    }
}
