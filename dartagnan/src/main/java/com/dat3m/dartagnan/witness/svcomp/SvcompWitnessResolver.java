package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.CallContext;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Maps;

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.witness.svcomp.SvcompSourceMatching.earlierInStatementInstance;
import static com.dat3m.dartagnan.witness.svcomp.SvcompSourceMatching.matches;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;

/**
 * Resolves the waypoints of a violation witness to the events of a bounded program.
 *
 * Threads: witness ID 0 identifies the main thread. A function_enter waypoint gives the
 * parent's witness ID and the thread-creation location. The thread created there
 * receives the next witness ID (1, 2, ...). Several program threads may be created at that
 * location, e.g., one per loop iteration, so each witness ID keeps every program thread
 * compatible with it: a thread created at the location by a thread compatible with the parent.
 * Choosing one of them is left to the encoding.
 *
 * Locations: events are matched by source line and file name, ignoring directories.
 * Multiple events can match a location, for example after loop unrolling. Conversely, a location
 * may match no event, e.g., code reached only beyond the unrolling or recursion bound. Then the
 * waypoint (or witness thread ID) has no candidates and cannot be satisfied, which lets the solver
 * decide whether higher bounds are needed. Only witnesses that are malformed or unsupported for every
 * bound, e.g., referring to undeclared thread IDs, are rejected with an exception.
 *
 * Targets: a target denotes the event at which the property is violated. For assertion-based
 * properties, its candidates are the assertions whose violation sites include the target location:
 * the assertion itself and every call site on its (inlined) call stack. Hence, a target may point to
 * the failing assertion or to any call leading to it, e.g., a call to a function wrapping the
 * assertion. A target matching only other events has no candidates.
 * For other properties, the candidates are all events at the target location.
 *
 * Variables: each variable of an assumption must be a bare identifier naming a unique,
 * statically allocated, initialized scalar memory object of integral type, all of whose
 * writes have the type of the object. A variable naming no memory object is left unresolved,
 * and equalities on it cannot be satisfied: unused objects are removed from the program, e.g.,
 * when all their accesses lie beyond the current bounds. Array indexing, member access, pointer dereferences,
 * register-only variables, and partial writes are currently unsupported.
 */
public final class SvcompWitnessResolver {

    /**
     * The resolved non-empty segments, the variables of all assumptions, and, for each witness thread ID,
     * the program threads it may be bound to.
     */
    public record ResolvedWitness(List<ResolvedSegment> segments, Map<String, ResolvedVariable> variables,
            Map<Integer, List<Thread>> threads) {
        public ResolvedWitness {
            segments = List.copyOf(segments);
            variables = ImmutableMap.copyOf(variables);
            threads = ImmutableMap.copyOf(Maps.transformValues(threads, List::copyOf));
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

    /**
     * The candidates of a waypoint run in a program thread bound to witness thread {@code threadId}. For a
     * function_enter waypoint, this is the ID of the entered thread, not of its parent. For a target,
     * {@code assertionViolation} tells whether its candidates are assertions that must be violated,
     * rather than events that must execute.
     */
    public record ResolvedWaypoint(Waypoint waypoint, int threadId, boolean assertionViolation,
            List<Candidate> candidates) {
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
    private final boolean assertionTargets;
    private SyntacticContextAnalysis callStacks;

    private SvcompWitnessResolver(Program program, AliasAnalysis alias, Property property) {
        this.program = program;
        this.alias = alias;
        this.assertionTargets = property == Property.PROGRAM_SPEC;
    }

    /**
     * Resolves {@code witness} for the validation of {@code property}.
     * Throws {@link IllegalArgumentException} if the witness does not fit the program for any bound.
     */
    public static ResolvedWitness resolve(SvcompViolationWitness witness, Program program,
            AliasAnalysis alias, Property property) {
        return new SvcompWitnessResolver(program, alias, property).resolve(witness);
    }

    private ResolvedWitness resolve(SvcompViolationWitness witness) {
        final ResolvedThreads threads = resolveThreads(witness);
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
                final int threadId = waypoint instanceof FunctionEnter enter
                        ? threads.entered().get(enter)
                        : waypoint.threadId();
                final boolean assertionViolation = waypoint instanceof Target && assertionTargets;
                waypoints.add(new ResolvedWaypoint(waypoint, threadId, assertionViolation, candidates));
            }
            if (!waypoints.isEmpty()) {
                segments.add(new ResolvedSegment(waypoints));
            }
        }
        return new ResolvedWitness(segments, variables, threads.byId());
    }

    // ------------------------------------------------------------------------------------------------------
    // Threads

    // The compatible program threads of each witness thread ID, and the ID entered by each function_enter waypoint.
    private record ResolvedThreads(Map<Integer, List<Thread>> byId, Map<FunctionEnter, Integer> entered) { }

    private ResolvedThreads resolveThreads(SvcompViolationWitness witness) {
        final Map<Integer, List<Thread>> result = new LinkedHashMap<>();
        final Map<FunctionEnter, Integer> entered = new IdentityHashMap<>();
        result.put(0, List.of(program.getMainThread().orElseThrow(
                () -> new IllegalArgumentException("Witness validation requires a designated main thread"))));
        final List<Thread> spawnedThreads = program.getThreads().stream()
                .filter(thread -> thread.getEntry().isSpawned()).toList();
        final List<FunctionEnter> entries = witness.segments().stream()
                .flatMap(segment -> segment.waypoints().stream())
                .filter(FunctionEnter.class::isInstance)
                .map(FunctionEnter.class::cast)
                .toList();
        for (FunctionEnter enter : entries) {
            final List<Thread> parents = Optional.ofNullable(result.get(enter.threadId()))
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Witness creates a thread from unknown thread " + enter.threadId()));
            final List<Thread> children = spawnedThreads.stream()
                    .filter(thread -> {
                        final ThreadCreate createEvent = thread.getEntry().getCreator();
                        return parents.contains(createEvent.getThread()) && matches(enter.location(), createEvent);
                    })
                    .toList();
            final int id = result.size();
            result.put(id, children);
            entered.put(enter, id);
        }
        return new ResolvedThreads(result, entered);
    }

    // ------------------------------------------------------------------------------------------------------
    // Candidate events

    private List<Event> eventsForWaypoint(Waypoint waypoint, ResolvedThreads threads) {
        if (waypoint instanceof FunctionEnter enter) {
            return threads.byId().get(threads.entered().get(enter)).stream().<Event>map(Thread::getEntry).toList();
        }
        final List<Thread> compatible = Optional.ofNullable(threads.byId().get(waypoint.threadId()))
                .orElseThrow(() -> new IllegalArgumentException(
                        "Witness refers to unknown thread " + waypoint.threadId()));
        if (waypoint instanceof Target && assertionTargets) {
            return compatible.stream()
                    .flatMap(thread -> thread.getEvents(Assert.class).stream())
                    .filter(assertion -> violationSites(assertion).anyMatch(site -> matches(waypoint.location(), site)))
                    .map(Event.class::cast)
                    .toList();
        }
        return compatible.stream()
                .flatMap(thread -> thread.getEvents().stream())
                .filter(event -> !(waypoint instanceof Assumption) || !(event instanceof FunReturnMarker))
                .filter(event -> matches(waypoint.location(), event))
                .toList();
    }

    // The assertion and the call sites on its call stack, from the innermost to the outermost.
    private Stream<Event> violationSites(Assert assertion) {
        if (callStacks == null) {
            callStacks = SyntacticContextAnalysis.newInstance(program);
        }
        final List<CallContext> calls = callStacks.getContextInfo(assertion).getContextOfType(CallContext.class);
        return Stream.concat(Stream.of(assertion), calls.reversed().stream().map(CallContext::funCallMarker));
    }

    private Candidate candidate(Waypoint waypoint, Event event, Map<String, ResolvedVariable> variables) {
        if (!(waypoint instanceof Assumption assumption)) {
            return new Candidate(event, List.of(), Set.of());
        }
        return new Candidate(event, earlierInStatementInstance(assumption.location(), event),
                accessesOfConstrainedVariables(assumption, event, variables));
    }

    // Memory accesses to the variables named in the constraint, within the statement instance starting at 'first'.
    private Set<Event> accessesOfConstrainedVariables(Assumption assumption, Event first,
            Map<String, ResolvedVariable> variables) {
        final Set<MemoryObject> objects = new HashSet<>();
        variableNames(assumption.expression(), name -> {
            if (variables.containsKey(name)) {
                objects.add(variables.get(name).object());
            }
        });
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
        variableNames(expression, name -> {
            if (!variables.containsKey(name)) {
                namedObject(name).ifPresent(object -> variables.put(name, resolveVariable(object)));
            }
        });
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

    private ResolvedVariable resolveVariable(MemoryObject object) {
        return new ResolvedVariable(object, writesForObject(object));
    }

    private Optional<MemoryObject> namedObject(String variable) {
        final List<MemoryObject> objects = program.getMemory().getObjects().stream()
                .filter(object -> object.hasName() && object.getName().equals(variable)).toList();
        if (objects.size() > 1) {
            throw new IllegalArgumentException("Witness variable '%s' does not identify a unique memory object"
                    .formatted(variable));
        }
        return objects.stream().findFirst();
    }

    private List<Store> writesForObject(MemoryObject object) {
        final var type = SvcompVariables.scalarType(object).orElseThrow(() -> new IllegalArgumentException(
                "Witness variable is not an initialized integral scalar: " + object));
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
