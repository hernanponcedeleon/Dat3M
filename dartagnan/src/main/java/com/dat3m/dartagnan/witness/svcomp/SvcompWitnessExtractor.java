package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.encoding.IREvaluator;
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
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.event.AssertModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.event.LoadModel;
import com.dat3m.dartagnan.verification.model.event.MemoryEventModel;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Verify;
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
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.UNREACH_CALL;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.fromAssertionError;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static java.nio.file.Files.readAllBytes;

/** Projects an {@link ExecutionModelNext} into an SV-COMP witness. */
public final class SvcompWitnessExtractor {

    private static final String DATA_RACE_AXIOM = "data-race";
    private static final String HB = "hb-consistency";
    private static final Pattern C_IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_]*");

    private SvcompWitnessExtractor() { }

    public static Optional<SvcompWitness> forViolation(
            ExecutionModelNext model, VerificationTask task, IREvaluator evaluator)
            throws IOException {
        final Optional<SvcompWitness> assertionViolation = findAssertionViolation(model, task, evaluator);
        return assertionViolation.isPresent()
                ? assertionViolation
                : findDataRaceViolation(model, task, evaluator);
    }

    private static Optional<SvcompWitness> findAssertionViolation(
            ExecutionModelNext model, VerificationTask task, IREvaluator evaluator) throws IOException {
        if (!task.getProperties().contains(PROGRAM_SPEC) || !evaluator.propertyViolated(PROGRAM_SPEC)) {
            return Optional.empty();
        }
        final AssertModel assertionViolation = model.getEventModels().stream()
                .filter(AssertModel.class::isInstance).map(AssertModel.class::cast)
                .filter(assertion -> !assertion.getResult()).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Execution model contains no violated assertion"));
        final Assert assertion = (Assert) assertionViolation.getEvent();
        final SvcompViolation violation = new SvcompViolation(
                fromAssertionError(assertion.getErrorMessage()), List.of(assertionViolation));
        return Optional.of(extract(model, task.getProgram(), violation));
    }

    private static Optional<SvcompWitness> findDataRaceViolation(
            ExecutionModelNext model, VerificationTask task, IREvaluator evaluator) throws IOException {
        if (!task.getProperties().contains(CAT_SPEC)) {
            return Optional.empty();
        }
        final Optional<EdgeModel> dataRace = task.getMemoryModel().getAxioms().stream()
                .filter(Axiom::isFlagged)
                .filter(axiom -> DATA_RACE_AXIOM.equals(axiom.getName()))
                .filter(evaluator::isFlaggedAxiomViolated)
                .map(Axiom::getRelation)
                .flatMap(relation -> model.getRelationModels().stream()
                        .filter(relationModel -> relationModel.getRelation().equals(relation))
                        .flatMap(relationModel -> relationModel.getEdgeModels().stream()))
                .findFirst();
        if (dataRace.isEmpty()) {
            return Optional.empty();
        }
        final EdgeModel edge = dataRace.get();
        final EventModel first = edge.from();
        final EventModel second = edge.to();
        if (!(first instanceof MemoryEventModel) || !(second instanceof MemoryEventModel)) {
            throw new IllegalArgumentException("Data-race targets are not memory accesses");
        }
        if (first.getThreadModel().equals(second.getThreadModel())) {
            throw new IllegalArgumentException("Data-race targets belong to the same thread");
        }
        final SvcompViolation violation = new SvcompViolation(DATA_RACE, List.of(first, second));
        return Optional.of(extract(model, task.getProgram(), violation));
    }

    private static SvcompWitness extract(ExecutionModelNext model, Program program, SvcompViolation violation)
            throws IOException {
        if (!program.hasMetadata(SourcePath.class)) {
            throw new IOException("Cannot generate an SV-COMP witness without program source metadata");
        }
        final Path programFile = program.getMetadata(SourcePath.class).sourcePath();
        final SyntacticContextAnalysis context = SyntacticContextAnalysis.newInstance(program);

        final Map<ThreadModel, Integer> threadIds = new HashMap<>();
        final List<Segment> segments = new ArrayList<>();
        final List<EventModel> linearized = linearize(model);
        final Map<EventModel, String> assumptions = assumptionWaypoints(linearized, model, programFile);
        final Set<EventModel> prefix = eventsBefore(violation.targets());
        for (EventModel event : linearized) {
            if (!prefix.contains(event)) {
                continue;
            }
            final ThreadModel thread = event.getThreadModel();
            registerThread(segments, thread, threadIds, model, programFile);
            final String assumption = assumptions.get(event);
            if (assumption != null) {
                final Location location = inputLocation(event, programFile);
                segments.add(new Segment(List.of(new Assumption(
                        threadIds.get(thread), assumption, "c_expression", location))));
            }
        }
        for (EventModel target : violation.targets()) {
            registerThread(segments, target.getThreadModel(), threadIds, model, programFile);
        }
        final List<Waypoint> targetWaypoints = violation.targets().stream()
                .<Waypoint>map(target -> new Target(threadIds.get(target.getThreadModel()),
                        targetLocation(target, violation.property(), programFile, context)))
                .toList();
        segments.add(new Segment(targetWaypoints));

        return new SvcompWitness(new Metadata("2.2", UUID.randomUUID().toString(), Instant.now(),
                new Producer("Dartagnan", EnvironmentInfo.getVersion()),
                new Task(programFile, sha256(programFile), violation.property().specification(), "ILP32", "C")), segments);
    }

    /*
     * Version 2.2 has no direct representation of rf or co. Instead, a concurrent execution is described by an
     * ordered sequence of thread-tagged waypoints. We only constrain reads that actually read from another thread.
     * This keeps the witness coarse while recording the observable part of rf/co.
     */
    private static Map<EventModel, String> assumptionWaypoints(List<EventModel> linearized, ExecutionModelNext model,
            Path programFile) {
        final Map<EventModel, SourcePoint> sourcePoints = sourcePoints(model, programFile);
        final Set<EventModel> crossThreadReads = relationEdges(model, RF).stream()
                .filter(edge -> edge.to() instanceof LoadModel)
                .filter(edge -> !(edge.from().getEvent() instanceof Init))
                .filter(edge -> !edge.from().getThreadModel().equals(edge.to().getThreadModel()))
                .map(EdgeModel::to)
                .collect(Collectors.toSet());

        final Map<SourcePoint, EventModel> representatives = new HashMap<>();
        final Map<SourcePoint, Set<String>> constraints = new HashMap<>();
        for (EventModel event : linearized) {
            final SourcePoint point = sourcePoints.get(event);
            if (!(event instanceof LoadModel load) || !crossThreadReads.contains(event)
                    || point == null) {
                continue;
            }
            final Optional<String> constraint = readValueAssumption(load, model);
            if (constraint.isPresent()) {
                representatives.putIfAbsent(point, event);
                constraints.computeIfAbsent(point, ignored -> new LinkedHashSet<>()).add(constraint.get());
            }
        }

        final Map<EventModel, String> result = new HashMap<>();
        constraints.forEach((point, values) ->
                result.put(representatives.get(point), String.join(" && ", values)));
        return result;
    }

    private static Map<EventModel, SourcePoint> sourcePoints(ExecutionModelNext model, Path programFile) {
        final Map<EventModel, SourcePoint> result = new HashMap<>();
        for (ThreadModel thread : model.getThreadModels()) {
            Location previous = null;
            int occurrence = 0;
            for (EventModel event : thread.getEventModels()) {
                final Location location = inputLocation(event, programFile);
                if (location == null) {
                    continue;
                }
                if (!location.equals(previous)) {
                    occurrence++;
                    previous = location;
                }
                result.put(event, new SourcePoint(thread, occurrence, location));
            }
        }
        return result;
    }

    private static Optional<String> readValueAssumption(LoadModel load, ExecutionModelNext model) {
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
        final Object value = load.getValue().value();
        final String literal;
        if (value instanceof Boolean booleanValue) {
            literal = booleanValue ? "1" : "0";
        } else if (value instanceof Number) {
            literal = value.toString();
        } else {
            return Optional.empty();
        }
        return Optional.of(String.format("(%s == %s)", object.get().object().getName(), literal));
    }

    private static Set<EdgeModel> relationEdges(ExecutionModelNext model, String name) {
        return model.getRelationModels().stream()
                .filter(relation -> relation.getRelation().hasName(name))
                .findFirst()
                .map(RelationModel::getEdgeModels)
                .orElse(Set.of());
    }

    private static List<EventModel> linearize(ExecutionModelNext model) {
        final RelationModel hb = model.getRelationModels().stream()
                .filter(relation -> relation.getRelation().hasName(HB))
                .findFirst()
                .orElseThrow(() -> new VerifyException(
                        "Execution model does not contain relation '%s'".formatted(HB)));

        final List<EventModel> events = model.getEventModels();
        final Map<EventModel, Set<EventModel>> predecessors = new HashMap<>();
        for (EdgeModel edge : hb.getEdgeModels()) {
            Verify.verify(edge.from() != edge.to(), "svcomp.cat produced a non-SC execution");
            predecessors.computeIfAbsent(edge.to(), ignored -> new HashSet<>()).add(edge.from());
        }

        final DependencyGraph<EventModel> dependencyGraph = DependencyGraph.from(events, predecessors);
        Verify.verify(dependencyGraph.getSCCs().size() == events.size(),
                "svcomp.cat produced a non-SC execution");
        return dependencyGraph.getNodeContents();
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

    private record SourcePoint(ThreadModel thread, int occurrence, Location location) { }

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

    private static Set<EventModel> eventsBefore(List<EventModel> targets) {
        final Set<EventModel> result = new HashSet<>();
        for (EventModel target : targets) {
            final List<EventModel> events = target.getThreadModel().getEventModels();
            final int index = events.indexOf(target);
            if (index < 0) {
                throw new IllegalArgumentException("Violation target is not part of the execution model");
            }
            result.addAll(events.subList(0, index));
        }
        return result;
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
        final SourceLocation location = event.getMetadata(SourceLocation.class);
        if (!(location instanceof SourceLocation.Generic generic) || generic.lineNumber() < 1
                || !generic.sourcePath().getFileName().equals(programFile.getFileName())) {
            return null;
        }
        return new Location(programFile, generic.lineNumber());
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
