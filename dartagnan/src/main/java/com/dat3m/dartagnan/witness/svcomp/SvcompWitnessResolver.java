package com.dat3m.dartagnan.witness.svcomp;

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
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;

/**
 * Resolves the waypoints of a violation witness to the events of a bounded program.
 *
 * Threads: witness ID 0 identifies the main thread. A function_enter waypoint gives the
 * parent's witness ID and the thread-creation location. The thread created there
 * receives the next witness ID (1, 2, ...). Each witness ID identifies one program thread,
 * and each program thread receives at most one witness ID.
 *
 * Locations: events are matched by source line and file name, ignoring directories.
 * Multiple events can match a location, for example after loop unrolling.
 * Every waypoint must match at least one event; unmatched waypoints are rejected.
 *
 * Variables: each variable of an assumption must be a bare identifier naming a unique,
 * statically allocated, initialized scalar memory object of integral type, all of whose
 * writes have the type of the object. Array indexing, member access, pointer dereferences,
 * register-only variables, and partial writes are currently unsupported.
 */
public final class SvcompWitnessResolver {

    private static final Logger logger = LoggerFactory.getLogger(SvcompWitnessResolver.class);

    /** The resolved non-empty segments, and the variables of all assumptions. */
    public record ResolvedWitness(List<ResolvedSegment> segments, Map<String, ResolvedVariable> variables) {
        public ResolvedWitness {
            segments = List.copyOf(segments);
            variables = ImmutableMap.copyOf(variables);
        }

        public boolean hasValueConstraints() {
            return !variables.isEmpty();
        }
    }

    public record ResolvedSegment(List<ResolvedWaypoint> waypoints) {
        public ResolvedSegment {
            waypoints = List.copyOf(waypoints);
        }
    }

    public record ResolvedWaypoint(Waypoint waypoint, List<Candidate> candidates) {
        public ResolvedWaypoint {
            Objects.requireNonNull(waypoint);
            candidates = List.copyOf(candidates);
        }
    }

    /**
     * An event that may satisfy a waypoint. A statement instance is a maximal run of consecutive events in program
     * order at the waypoint's location, e.g., one loop iteration of the statement. For assumptions, the candidate is
     * the first executed event of its statement instance: {@code earlierInStatementInstance} are the events of that
     * instance before the candidate, in program order, and {@code constrainedAccesses} are the accesses to the
     * constrained variables within the instance.
     */
    public record Candidate(Event event, List<Event> earlierInStatementInstance, Set<Event> constrainedAccesses) {
        public Candidate {
            Objects.requireNonNull(event);
            earlierInStatementInstance = List.copyOf(earlierInStatementInstance);
            constrainedAccesses = ImmutableSet.copyOf(constrainedAccesses);
        }
    }

    /** The memory object named by a witness variable and every write that may target it. */
    public record ResolvedVariable(MemoryObject object, List<Store> writes) {
        public ResolvedVariable {
            Objects.requireNonNull(object);
            writes = List.copyOf(writes);
        }
    }

    private final Program program;
    private final AliasAnalysis alias;

    private SvcompWitnessResolver(Program program, AliasAnalysis alias) {
        this.program = program;
        this.alias = alias;
    }

    /**
     * Returns empty if the witness creates more threads at some location than the bounded program contains.
     * Throws {@link IllegalArgumentException} if the witness does not fit the program for any bound.
     */
    public static Optional<ResolvedWitness> resolve(SvcompViolationWitness witness, Program program,
            AliasAnalysis alias) {
        return new SvcompWitnessResolver(program, alias).resolve(witness);
    }

    /** Events are matched by source line and file name, ignoring directories. */
    public static boolean matches(Location location, Event event) {
        return event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic generic
                && generic.lineNumber() == location.line()
                && generic.sourcePath().getFileName().equals(location.fileName().getFileName());
    }

    private Optional<ResolvedWitness> resolve(SvcompViolationWitness witness) {
        final Optional<ResolvedThreads> resolvedThreads = resolveThreads(witness);
        if (resolvedThreads.isEmpty()) {
            return Optional.empty();
        }
        final ResolvedThreads threads = resolvedThreads.get();
        final Map<String, ResolvedVariable> variables = new LinkedHashMap<>();
        for (Segment segment : witness.segments()) {
            for (Waypoint waypoint : segment.waypoints()) {
                if (waypoint instanceof Assumption assumption) {
                    collectVariables(assumption.expression(), variables);
                }
            }
        }
        final List<ResolvedSegment> segments = new ArrayList<>();
        for (Segment segment : witness.segments()) {
            final List<ResolvedWaypoint> waypoints = new ArrayList<>();
            for (Waypoint waypoint : segment.waypoints()) {
                final List<Candidate> candidates = eventsForWaypoint(waypoint, threads).stream()
                        .map(event -> candidate(waypoint, event, variables))
                        .toList();
                waypoints.add(new ResolvedWaypoint(waypoint, candidates));
            }
            if (!waypoints.isEmpty()) {
                segments.add(new ResolvedSegment(waypoints));
            }
        }
        return Optional.of(new ResolvedWitness(segments, variables));
    }

    // ------------------------------------------------------------------------------------------------------
    // Threads

    // Witness thread IDs and the program threads entered by function_enter waypoints.
    private record ResolvedThreads(Map<Integer, Thread> byId, Map<FunctionEnter, Thread> entered) { }

    private Optional<ResolvedThreads> resolveThreads(SvcompViolationWitness witness) {
        final Map<Integer, Thread> result = new HashMap<>();
        final Map<FunctionEnter, Thread> entered = new IdentityHashMap<>();
        result.put(0, program.getMainThread().orElseThrow(
                () -> new IllegalArgumentException("Witness validation requires a designated main thread")));
        final List<Thread> spawnedThreads = program.getThreads().stream()
                .filter(thread -> thread.getEntry().isSpawned()).toList();
        final List<Thread> remainingThreads = new ArrayList<>(spawnedThreads);
        final List<FunctionEnter> entries = witness.segments().stream()
                .flatMap(segment -> segment.waypoints().stream())
                .filter(FunctionEnter.class::isInstance)
                .map(FunctionEnter.class::cast)
                .toList();
        for (FunctionEnter enter : entries) {
            final Thread parent = Optional.ofNullable(result.get(enter.threadId()))
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Witness creates a thread from unknown thread " + enter.threadId()));
            final Predicate<Thread> matchesCreation = thread -> {
                final ThreadCreate createEvent = thread.getEntry().getCreator();
                return createEvent.getThread().equals(parent) && matches(enter.location(), createEvent);
            };
            final Optional<Thread> availableChild = remainingThreads.stream().filter(matchesCreation).findFirst();
            if (availableChild.isEmpty() && spawnedThreads.stream().anyMatch(matchesCreation)) {
                logger.info("Witness requires another child of thread {} at {}:{} absent from the bounded program",
                        enter.threadId(), enter.location().fileName(), enter.location().line());
                return Optional.empty();
            }
            final Thread child = availableChild
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Witness function entry at %s:%d matches no thread creation"
                                    .formatted(enter.location().fileName(), enter.location().line())));
            result.put(result.size(), child);
            entered.put(enter, child);
            remainingThreads.remove(child);
        }
        return Optional.of(new ResolvedThreads(result, entered));
    }

    // ------------------------------------------------------------------------------------------------------
    // Candidate events

    private List<Event> eventsForWaypoint(Waypoint waypoint, ResolvedThreads threads) {
        if (waypoint instanceof FunctionEnter enter) {
            return List.of(threads.entered().get(enter).getEntry());
        }
        final Thread thread = Optional.ofNullable(threads.byId().get(waypoint.threadId()))
                .orElseThrow(() -> new IllegalArgumentException(
                        "Witness refers to unknown thread " + waypoint.threadId()));
        final List<Event> candidates = thread.getEvents().stream()
                .filter(event -> !(waypoint instanceof Assumption) || !(event instanceof FunReturnMarker))
                .filter(event -> matches(waypoint.location(), event)).toList();
        if (candidates.isEmpty()) {
            final String type = waypoint instanceof Assumption ? "assumption" : "target";
            throw new IllegalArgumentException("Witness %s at %s:%d matches no event"
                    .formatted(type, waypoint.location().fileName(), waypoint.location().line()));
        }
        return candidates;
    }

    private Candidate candidate(Waypoint waypoint, Event event, Map<String, ResolvedVariable> variables) {
        if (!(waypoint instanceof Assumption assumption)) {
            return new Candidate(event, List.of(), Set.of());
        }
        final List<Event> earlier = new ArrayList<>();
        for (Event previous = event.getPredecessor(); previous != null
                && matches(assumption.location(), previous); previous = previous.getPredecessor()) {
            earlier.addFirst(previous);
        }
        return new Candidate(event, earlier, accessesOfConstrainedVariables(assumption, event, variables));
    }

    // Memory accesses to the variables named in the constraint, within the statement instance starting at 'first'.
    private Set<Event> accessesOfConstrainedVariables(Assumption assumption, Event first,
            Map<String, ResolvedVariable> variables) {
        final Set<MemoryObject> objects = new HashSet<>();
        variableNames(assumption.expression(), name -> objects.add(variables.get(name).object()));
        final Set<Event> accesses = new LinkedHashSet<>();
        if (objects.isEmpty()) {
            return accesses;
        }
        for (Event event = first; event != null && matches(assumption.location(), event); event = event.getSuccessor()) {
            if (event instanceof MemoryCoreEvent access && !(event instanceof Init)
                    && !Collections.disjoint(alias.addressableObjects(access), objects)) {
                accesses.add(event);
            }
        }
        return accesses;
    }

    // ------------------------------------------------------------------------------------------------------
    // Variables

    private void collectVariables(AssumptionExpression expression, Map<String, ResolvedVariable> variables) {
        variableNames(expression, name -> variables.computeIfAbsent(name, this::resolveVariable));
    }

    private static void variableNames(AssumptionExpression expression, Consumer<String> action) {
        switch (expression) {
            case BooleanConstant _ -> { }
            case VariableEquality equality -> action.accept(equality.variable());
            case Conjunction(AssumptionExpression left, AssumptionExpression right) -> {
                variableNames(left, action);
                variableNames(right, action);
            }
        }
    }

    private ResolvedVariable resolveVariable(String variable) {
        final MemoryObject object = namedObject(variable);
        return new ResolvedVariable(object, writesForObject(object));
    }

    private MemoryObject namedObject(String variable) {
        final List<MemoryObject> objects = program.getMemory().getObjects().stream()
                .filter(object -> object.hasName() && object.getName().equals(variable)).toList();
        if (objects.size() != 1) {
            throw new IllegalArgumentException("Witness variable '%s' does not identify a unique memory object"
                    .formatted(variable));
        }
        return objects.getFirst();
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
        final List<Store> writes = program.getThreadEvents(Store.class).stream()
                .filter(write -> alias.addressableObjects(write).contains(object)).toList();
        for (Store write : writes) {
            if (!write.getAccessType().equals(type)) {
                throw new IllegalArgumentException("Witness variable has unsupported partial or differently typed writes: " + object);
            }
        }
        return writes;
    }
}
