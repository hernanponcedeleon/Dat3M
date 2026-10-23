package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.metadata.SourceLocation.SourcePath;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.utils.EnvironmentInfo;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.event.AssertModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.event.LoadModel;
import com.dat3m.dartagnan.verification.model.event.MemoryEventModel;
import com.google.common.base.VerifyException;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.DATA_RACE;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.DATA_RACE_AXIOM;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.HB_RELATION;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.UNREACH_CALL;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.fromAssertionError;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static java.nio.file.Files.readAllBytes;

/**
 * Generates SV-COMP witnesses: violation witnesses by projecting an {@link ExecutionModelNext},
 * correctness witnesses from a task whose properties hold.
 */
public final class SvcompWitnessExtractor {

    private static final Pattern C_IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_]*");

    private SvcompWitnessExtractor() { }

    public static Optional<SvcompCorrectnessWitness> forCorrectness(Program program, SvcompProperty property)
            throws IOException {
        if (!property.supportsCorrectnessWitness()) {
            return Optional.empty();
        }
        return Optional.of(new SvcompCorrectnessWitness(metadata(programFile(program), property.specification())));
    }

    public static Optional<SvcompViolationWitness> forViolation(ExecutionModelNext model, Program program)
            throws IOException {
        final Map<SvcompProperty, SvcompViolation> violations = new EnumMap<>(SvcompProperty.class);
        if (model.isViolated(PROGRAM_SPEC)) {
            findAssertionViolations(model)
                    .forEach(violation -> violations.putIfAbsent(violation.property(), violation));
        }
        if (model.isViolated(CAT_SPEC)) {
            findDataRaceViolation(model)
                    .ifPresent(violation -> violations.putIfAbsent(violation.property(), violation));
        }
        return switch (violations.size()) {
            case 0 -> Optional.empty();
            case 1 -> Optional.of(extract(model, program, violations.values().iterator().next()));
            default -> throw new IOException("Cannot generate an SV-COMP witness for an execution that violates "
                    + "multiple SV-COMP properties: " + violations.keySet());
        };
    }

    private static List<SvcompViolation> findAssertionViolations(ExecutionModelNext model) {
        return model.getEventModels().stream()
                .filter(AssertModel.class::isInstance).map(AssertModel.class::cast)
                .filter(assertion -> !assertion.getResult())
                .map(assertion -> new SvcompViolation(
                        fromAssertionError(((Assert) assertion.getEvent()).getErrorMessage()), List.of(assertion)))
                .toList();
    }

    private static Optional<SvcompViolation> findDataRaceViolation(ExecutionModelNext model) {
        return model.getFlaggedAxioms().stream()
                .filter(axiom -> DATA_RACE_AXIOM.equals(axiom.getName()))
                .findFirst()
                .flatMap(axiom -> model.getRelationModel(axiom.getRelation()))
                .flatMap(relation -> relation.getEdgeModels().stream().findFirst())
                .map(edge -> new SvcompViolation(DATA_RACE, List.of(edge.from(), edge.to())));
    }

    private static SvcompViolationWitness extract(ExecutionModelNext model, Program program, SvcompViolation violation)
            throws IOException {
        final Path programFile = programFile(program);
        final SyntacticContextAnalysis context = SyntacticContextAnalysis.newInstance(program);

        final Map<ThreadModel, Integer> threadIds = new HashMap<>();
        final List<Segment> segments = new ArrayList<>();
        final RelationModel hb = findRelationModel(model, HB_RELATION)
                .orElseThrow(() -> new VerifyException(
                        "Execution model does not contain relation '%s'".formatted(HB_RELATION)));
        final List<EventModel> linearized = ExecutionLinearizer.linearize(model, hb);
        final Map<Event, ThreadModel> spawnedThreads = new HashMap<>();
        for (ThreadModel thread : model.getThreadModels()) {
            final ThreadStart start = thread.getThread().getEntry();
            if (start.isSpawned()) {
                spawnedThreads.put(start.getCreator(), thread);
            }
        }
        final Map<EventModel, SourcePoint> sourcePoints = sourcePoints(model, programFile, spawnedThreads.keySet());
        final Map<SourcePoint, AssumptionExpression> assumptions = assumptionWaypoints(model, sourcePoints);
        final Set<SourcePoint> creationPoints = linearized.stream()
                .filter(event -> spawnedThreads.containsKey(event.getEvent()))
                .map(sourcePoints::get).collect(Collectors.toSet());
        final Set<SourcePoint> visited = new HashSet<>();
        for (EventModel event : linearized) {
            // Keep both race targets in the final segment.
            if (violation.targets().contains(event)) {
                break;
            }
            final ThreadModel spawned = spawnedThreads.get(event.getEvent());
            if (spawned != null) {
                registerThread(segments, spawned, threadIds, model, programFile);
            }
            final SourcePoint point = sourcePoints.get(event);
            // A source point may span several events; emit its waypoint only at the first one.
            if (point == null || creationPoints.contains(point) || !visited.add(point)) {
                continue;
            }
            final ThreadModel thread = event.getThreadModel();
            registerThread(segments, thread, threadIds, model, programFile);
            segments.add(new Segment(List.of(new Assumption(threadIds.get(thread),
                    assumptions.getOrDefault(point, new BooleanConstant(true)), point.location()))));
        }
        for (EventModel target : violation.targets()) {
            registerThread(segments, target.getThreadModel(), threadIds, model, programFile);
        }
        final List<Waypoint> targetWaypoints = violation.targets().stream()
                .<Waypoint>map(target -> new Target(threadIds.get(target.getThreadModel()),
                        targetLocation(target, violation.property(), programFile, context)))
                .toList();
        segments.add(new Segment(targetWaypoints));

        return new SvcompViolationWitness(metadata(programFile, violation.property().specification()), segments);
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
    private static Map<SourcePoint, AssumptionExpression> assumptionWaypoints(ExecutionModelNext model,
            Map<EventModel, SourcePoint> sourcePoints) {
        // Sorted, so that the order of conjuncts is deterministic.
        final List<LoadModel> crossThreadReads = relationEdges(model, RF).stream()
                .filter(edge -> edge.to() instanceof LoadModel)
                .filter(edge -> !(edge.from().getEvent() instanceof Init))
                .filter(edge -> !edge.from().getThreadModel().equals(edge.to().getThreadModel()))
                .map(edge -> (LoadModel) edge.to())
                .filter(sourcePoints::containsKey)
                .distinct()
                .sorted(Comparator.comparingInt(LoadModel::getId))
                .toList();

        final Map<SourcePoint, AssumptionExpression> result = new HashMap<>();
        for (LoadModel load : crossThreadReads) {
            readValueAssumption(load, model)
                    .ifPresent(equality -> result.merge(sourcePoints.get(load), equality, Conjunction::new));
        }
        return result;
    }

    // Only non-init memory accesses and thread creations get source points; they are the events that matter for waypoints.
    private static Map<EventModel, SourcePoint> sourcePoints(ExecutionModelNext model, Path programFile,
            Set<Event> creators) {
        final Map<EventModel, SourcePoint> result = new HashMap<>();
        for (ThreadModel thread : model.getThreadModels()) {
            for (EventModel event : thread.getEventModels()) {
                final boolean isAccess = event instanceof MemoryEventModel && !(event.getEvent() instanceof Init);
                if (!isAccess && !creators.contains(event.getEvent())) {
                    continue;
                }
                final Location location = inputLocation(event, programFile);
                if (location == null) {
                    // Accesses outside the input program, e.g., in headers, do not become waypoints.
                    if (creators.contains(event.getEvent())) {
                        throw new IllegalArgumentException("Thread creation has no source location in the input program");
                    }
                    continue;
                }
                // Events of the same statement instance, as defined for validation, share a source point.
                final List<Event> earlier = SvcompSourceMatching.earlierInStatementInstance(location, event.getEvent());
                final Event start = earlier.isEmpty() ? event.getEvent() : earlier.getFirst();
                result.put(event, new SourcePoint(thread, start, location));
            }
        }
        return result;
    }

    private static Optional<VariableEquality> readValueAssumption(LoadModel load, ExecutionModelNext model) {
        final MemoryCoreEvent event = (MemoryCoreEvent) load.getEvent();
        if (!(event.getAccessType() instanceof IntegerType) && !(event.getAccessType() instanceof BooleanType)) {
            return Optional.empty();
        }
        final int accessSize = TypeFactory.getInstance().getMemorySizeInBytes(event.getAccessType());
        final Optional<MemoryObjectModel> object = model.getMemoryLayoutMap().values().stream()
                .filter(memory -> memory.object().isStaticallyAllocated() && memory.object().hasName())
                .filter(memory -> C_IDENTIFIER.matcher(memory.object().getName()).matches())
                .filter(memory -> memory.address().equals(load.getAccessedAddress()))
                .filter(memory -> memory.size().equals(BigInteger.valueOf(accessSize)))
                .findFirst();
        if (object.isEmpty()) {
            return Optional.empty();
        }
        final Optional<BigInteger> literal = switch (load.getValue().value()) {
            case Boolean booleanValue -> Optional.of(booleanValue ? BigInteger.ONE : BigInteger.ZERO);
            case Number number -> Optional.of(new BigInteger(number.toString()));
            case null, default -> Optional.empty();
        };
        return literal.map(l -> new VariableEquality(object.get().object().getName(), l));
    }

    private static Set<EdgeModel> relationEdges(ExecutionModelNext model, String name) {
        return findRelationModel(model, name)
                .map(RelationModel::getEdgeModels)
                .orElse(Set.of());
    }

    private static Optional<RelationModel> findRelationModel(ExecutionModelNext model, String name) {
        return model.getRelationModels().stream()
                .filter(relation -> relation.getRelation().hasName(name))
                .findFirst();
    }

    private static Location targetLocation(EventModel target, SvcompProperty property, Path programFile,
            SyntacticContextAnalysis context) {
        if (property == UNREACH_CALL) {
            final List<SyntacticContextAnalysis.CallContext> calls = context.getContextInfo(target.getEvent())
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
    private record SourcePoint(ThreadModel thread, Event start, Location location) { }

    private static void registerThread(List<Segment> segments, ThreadModel thread,
            Map<ThreadModel, Integer> threadIds, ExecutionModelNext model, Path programFile) {
        if (threadIds.containsKey(thread)) {
            return;
        }
        final ThreadStart start = thread.getThread().getEntry();
        if (!start.isSpawned()) {
            threadIds.put(thread, 0);
            return;
        }
        final Location location = inputLocation(start.getCreator(), programFile);
        if (location == null) {
            throw new IllegalArgumentException("Thread creation has no source location in the input program");
        }
        final ThreadModel creator = threadOf(start.getCreator(), model);
        registerThread(segments, creator, threadIds, model, programFile);
        final int id = threadIds.size();
        segments.add(new Segment(List.of(new FunctionEnter(threadIds.get(creator), location))));
        threadIds.put(thread, id);
    }

    private static ThreadModel threadOf(Event event, ExecutionModelNext model) {
        return model.getThreadModels().stream().filter(thread -> thread.getThread().equals(event.getThread()))
                .findFirst().orElseThrow(() -> new IllegalArgumentException("Thread creator is not part of the execution model"));
    }

    private static Location requireInputLocation(EventModel event, Path programFile) {
        final Location location = inputLocation(event, programFile);
        if (location == null) {
            throw new IllegalArgumentException("Violation target has no source location in the input program");
        }
        return location;
    }

    private static Location inputLocation(EventModel event, Path programFile) {
        return inputLocation(event.getEvent(), programFile);
    }

    private static Location inputLocation(Event event, Path programFile) {
        if (!(event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic generic)
                || generic.lineNumber() < 1) {
            return null;
        }
        final Location location = new Location(programFile, generic.lineNumber());
        return SvcompSourceMatching.matches(location, event) ? location : null;
    }

    // The targets identify the event(s) constituting the violation and become the final target waypoints.
    private record SvcompViolation(SvcompProperty property, List<EventModel> targets) {

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
