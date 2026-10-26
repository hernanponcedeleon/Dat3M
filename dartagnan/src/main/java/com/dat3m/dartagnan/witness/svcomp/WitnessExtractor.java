package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.metadata.SourceLocation.SourcePath;
import com.dat3m.dartagnan.model.execution.Execution;
import com.dat3m.dartagnan.model.execution.MemoryLayout;
import com.dat3m.dartagnan.model.execution.ThreadExecution;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.utils.EnvironmentInfo;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.VerifyException;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.witness.svcomp.CatNames.DATA_RACE_AXIOM;
import static com.dat3m.dartagnan.witness.svcomp.CatNames.HB_RELATION;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.DATA_RACE;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.UNREACH_CALL;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.fromAssertionError;
import static com.dat3m.dartagnan.witness.svcomp.Witness.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static java.nio.file.Files.readAllBytes;

/**
 * Generates SV-COMP witnesses: violation witnesses by projecting an {@link Execution},
 * correctness witnesses from a task whose properties hold.
 */
public final class WitnessExtractor {


    private WitnessExtractor() { }

    public static Optional<CorrectnessWitness> forCorrectness(Program program, SvcompProperty property)
            throws IOException {
        if (!property.supportsCorrectnessWitness()) {
            return Optional.empty();
        }
        return Optional.of(new CorrectnessWitness(metadata(programFile(program), property.specification())));
    }

    /**
     * @param properties The properties checked by the task. Only violations of these properties are reported.
     */
    public static Optional<ViolationWitness> forViolation(Execution execution, Set<Property> properties)
            throws IOException {
        final Map<SvcompProperty, SvcompViolation> violations = new EnumMap<>(SvcompProperty.class);
        if (properties.contains(PROGRAM_SPEC)) {
            findAssertionViolations(execution)
                    .forEach(violation -> violations.putIfAbsent(violation.property(), violation));
        }
        if (properties.contains(CAT_SPEC)) {
            findDataRaceViolation(execution)
                    .ifPresent(violation -> violations.putIfAbsent(violation.property(), violation));
        }
        return switch (violations.size()) {
            case 0 -> Optional.empty();
            case 1 -> Optional.of(extract(execution, violations.values().iterator().next()));
            default -> throw new IOException("Cannot generate an SV-COMP witness for an execution that violates "
                    + "multiple SV-COMP properties: " + violations.keySet());
        };
    }

    private static List<SvcompViolation> findAssertionViolations(Execution execution) {
        return execution.getEvents(Assert.class).stream()
                .filter(execution::assertionViolated)
                .map(assertion -> new SvcompViolation(
                        fromAssertionError(assertion.getErrorMessage()), List.of(assertion)))
                .toList();
    }

    // Among all racing pairs, we pick the one that completes first in the linearized execution (shortest witness).
    private static Optional<SvcompViolation> findDataRaceViolation(Execution execution) {
        final Optional<EventGraph> race = execution.getRaisedFlags().stream()
                .filter(axiom -> DATA_RACE_AXIOM.equals(axiom.getName()))
                .findFirst()
                .map(axiom -> execution.getRelation(axiom.getRelation()));
        if (race.isEmpty() || race.get().isEmpty()) {
            return Optional.empty();
        }
        final List<Event> linearized = linearize(execution);
        final Map<Event, Integer> rank = new HashMap<>();
        for (int i = 0; i < linearized.size(); i++) {
            rank.put(linearized.get(i), i);
        }
        final List<List<Event>> pairs = new ArrayList<>();
        race.get().apply((a, b) -> {
            if (rank.containsKey(a) && rank.containsKey(b)) {
                pairs.add(rank.get(a) <= rank.get(b) ? List.of(a, b) : List.of(b, a));
            }
        });
        return pairs.stream()
                .min(Comparator.<List<Event>>comparingInt(p -> rank.get(p.get(1)))
                        .thenComparingInt(p -> rank.get(p.get(0))))
                .map(pair -> new SvcompViolation(DATA_RACE, pair));
    }

    private static ViolationWitness extract(Execution execution, SvcompViolation violation)
            throws IOException {
        final Program program = execution.getProgram();
        final Path programFile = programFile(program);
        final SyntacticContextAnalysis context = SyntacticContextAnalysis.newInstance(program);

        final Map<Thread, Integer> threadIds = new HashMap<>();
        final List<Segment> segments = new ArrayList<>();
        final List<Event> linearized = linearize(execution);
        final Map<Event, Thread> spawnedThreads = new HashMap<>();
        for (ThreadExecution thread : execution.getThreads()) {
            final ThreadStart start = thread.getThread().getEntry();
            if (thread.hasStarted() && start.isSpawned()) {
                spawnedThreads.put(start.getCreator(), thread.getThread());
            }
        }
        final Map<Event, SourcePoint> sourcePoints = sourcePoints(execution, programFile, spawnedThreads.keySet());
        final Map<SourcePoint, AssumptionExpression> assumptions = assumptionWaypoints(execution, sourcePoints);
        final Set<SourcePoint> creationPoints = linearized.stream()
                .filter(spawnedThreads::containsKey)
                .map(sourcePoints::get).collect(Collectors.toSet());
        final Set<SourcePoint> visited = new HashSet<>();
        for (Event event : linearized) {
            // Keep both race targets in the final segment.
            if (violation.targets().contains(event)) {
                break;
            }
            final Thread spawned = spawnedThreads.get(event);
            if (spawned != null) {
                registerThread(segments, spawned, threadIds, execution, programFile);
            }
            final SourcePoint point = sourcePoints.get(event);
            // A source point may span several events; emit its waypoint only at the first one.
            if (point == null || creationPoints.contains(point) || !visited.add(point)) {
                continue;
            }
            final Thread thread = event.getThread();
            registerThread(segments, thread, threadIds, execution, programFile);
            segments.add(new Segment(List.of(new Assumption(threadIds.get(thread),
                    assumptions.getOrDefault(point, new BooleanConstant(true)), point.location()))));
        }
        for (Event target : violation.targets()) {
            registerThread(segments, target.getThread(), threadIds, execution, programFile);
        }
        final List<Waypoint> targetWaypoints = violation.targets().stream()
                .<Waypoint>map(target -> new Target(threadIds.get(target.getThread()),
                        targetLocation(target, violation.property(), programFile, context)))
                .toList();
        segments.add(new Segment(targetWaypoints));

        return new ViolationWitness(metadata(programFile, violation.property().specification()), segments);
    }

    private static Path programFile(Program program) throws IOException {
        if (!program.hasMetadata(SourcePath.class)) {
            throw new IOException("Cannot generate an SV-COMP witness without program source metadata");
        }
        return program.getMetadata(SourcePath.class).sourcePath();
    }

    private static Metadata metadata(Path programFile, String specification) throws IOException {
        return new Metadata("2.2", UUID.randomUUID().toString(), Instant.now(),
                new Producer("Dartagnan", EnvironmentInfo.getVersion()),
                new Task(programFile, sha256(programFile), specification, "ILP32", "C"));
    }

    /*
     * Version 2.2 has no direct representation of rf or co. Instead, a concurrent execution is described by an
     * ordered sequence of thread-tagged memory-access waypoints. Value constraints describe reads from other
     * threads; other accesses use a true assumption to record their place in the interleaving.
     */
    private static Map<SourcePoint, AssumptionExpression> assumptionWaypoints(Execution execution,
            Map<Event, SourcePoint> sourcePoints) {
        final EventGraph rf = execution.getRelation(RF).orElse(EventGraph.empty());
        final Set<Load> reads = new HashSet<>();
        rf.apply((write, read) -> {
            if (read instanceof Load load && !(write instanceof Init) && write.getThread() != read.getThread()
                    && sourcePoints.containsKey(read)) {
                reads.add(load);
            }
        });
        // Sorted, so that the order of conjuncts is deterministic.
        final List<Load> crossThreadReads = reads.stream()
                .sorted(Comparator.comparingInt(execution::getId))
                .toList();

        final Map<SourcePoint, AssumptionExpression> result = new HashMap<>();
        for (Load load : crossThreadReads) {
            readValueAssumption(load, execution)
                    .ifPresent(equality -> result.merge(sourcePoints.get(load), equality, Conjunction::new));
        }
        return result;
    }

    // Only non-init memory accesses and thread creations get source points; they are the events that matter for waypoints.
    private static Map<Event, SourcePoint> sourcePoints(Execution execution, Path programFile,
            Set<Event> creators) {
        final Map<Event, SourcePoint> result = new HashMap<>();
        for (ThreadExecution thread : execution.getThreads()) {
            for (Event event : thread.getTrace()) {
                final boolean isAccess = event instanceof MemoryCoreEvent && !(event instanceof Init);
                if (!isAccess && !creators.contains(event)) {
                    continue;
                }
                final Location location = inputLocation(event, programFile);
                if (location == null) {
                    // Accesses outside the input program, e.g., in headers, do not become waypoints.
                    if (creators.contains(event)) {
                        throw new IllegalArgumentException("Thread creation has no source location in the input program");
                    }
                    continue;
                }
                // Events of the same statement instance, as defined for validation, share a source point.
                final List<Event> earlier = SourceMatching.earlierInStatementInstance(location, event);
                final Event start = earlier.isEmpty() ? event : earlier.getFirst();
                result.put(event, new SourcePoint(thread.getThread(), start, location));
            }
        }
        return result;
    }

    private static Optional<VariableEquality> readValueAssumption(Load load, Execution execution) {
        if (!(load.getAccessType() instanceof IntegerType) && !(load.getAccessType() instanceof BooleanType)) {
            return Optional.empty();
        }
        final Optional<MemoryObject> object = execution.location(load)
                .filter(location -> location.offset().signum() == 0)
                .map(location -> location.base().object())
                .filter(Variables::isVariable)
                .filter(memory -> Variables.scalarType(memory).equals(Optional.of(load.getAccessType())));
        if (object.isEmpty()) {
            return Optional.empty();
        }
        final Optional<BigInteger> literal = switch (execution.value(load)) {
            case BoolLiteral b -> Optional.of(b.getValue() ? BigInteger.ONE : BigInteger.ZERO);
            case IntLiteral i -> Optional.of(i.getValue());
            default -> Optional.empty();
        };
        return literal.map(l -> new VariableEquality(object.get().getName(), l));
    }

    private static List<Event> linearize(Execution execution) {
        final EventGraph hb = execution.getRelation(HB_RELATION)
                .orElseThrow(() -> new VerifyException(
                        "Execution does not contain relation '%s'".formatted(HB_RELATION)));
        return ExecutionLinearizer.linearize(execution, hb);
    }

    private static Location targetLocation(Event target, SvcompProperty property, Path programFile,
            SyntacticContextAnalysis context) {
        if (property == UNREACH_CALL) {
            final List<SyntacticContextAnalysis.CallContext> calls = context.getContextInfo(target)
                    .getContextOfType(SyntacticContextAnalysis.CallContext.class);
            for (int i = calls.size() - 1; i >= 0; i--) {
                final SyntacticContextAnalysis.CallContext call = calls.get(i);
                if ("reach_error".equals(call.funCallMarker().getFunctionName())) {
                    final Location location = inputLocation(call.funCallMarker(), programFile);
                    if (location != null) {
                        return location;
                    }
                }
            }
        }
        return requireInputLocation(target, programFile);
    }

    // A statement instance, identified by its first event; each event executes at most once after unrolling.
    private record SourcePoint(Thread thread, Event start, Location location) { }

    private static void registerThread(List<Segment> segments, Thread thread,
            Map<Thread, Integer> threadIds, Execution execution, Path programFile) {
        if (threadIds.containsKey(thread)) {
            return;
        }
        final ThreadStart start = thread.getEntry();
        if (!start.isSpawned()) {
            threadIds.put(thread, 0);
            return;
        }
        final Location location = inputLocation(start.getCreator(), programFile);
        if (location == null) {
            throw new IllegalArgumentException("Thread creation has no source location in the input program");
        }
        final Thread creator = start.getCreator().getThread();
        if (!execution.threadHasStarted(creator)) {
            throw new IllegalArgumentException("Thread creator is not part of the execution");
        }
        registerThread(segments, creator, threadIds, execution, programFile);
        final int id = threadIds.size();
        segments.add(new Segment(List.of(new FunctionEnter(threadIds.get(creator), location))));
        threadIds.put(thread, id);
    }

    private static Location requireInputLocation(Event event, Path programFile) {
        final Location location = inputLocation(event, programFile);
        if (location == null) {
            throw new IllegalArgumentException("Violation target has no source location in the input program");
        }
        return location;
    }

    private static Location inputLocation(Event event, Path programFile) {
        if (!(event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic(var _, int line))
                || line < 1) {
            return null;
        }
        final Location location = new Location(programFile, line);
        return SourceMatching.matches(location, event) ? location : null;
    }

    // The targets identify the event(s) constituting the violation and become the final target waypoints.
    private record SvcompViolation(SvcompProperty property, List<Event> targets) {

        private SvcompViolation {
            targets = List.copyOf(targets);
        }
    }

    private static String sha256(Path file) throws IOException {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(readAllBytes(file)));
        } catch (NoSuchAlgorithmException exception) {
            throw new AssertionError("SHA-256 is unavailable", exception);
        }
    }
}
