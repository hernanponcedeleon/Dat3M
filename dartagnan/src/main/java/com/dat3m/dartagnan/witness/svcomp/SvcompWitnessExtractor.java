package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
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
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
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

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.DATA_RACE;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.UNREACH_CALL;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.fromAssertionError;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static java.nio.file.Files.readAllBytes;

/**
 * Generates SV-COMP witnesses: violation witnesses by projecting an {@link Execution},
 * correctness witnesses from a task whose properties hold.
 */
public final class SvcompWitnessExtractor {

    private static final String DATA_RACE_AXIOM = "data-race";
    private static final String HB = "hb-consistency";
    private static final Pattern C_IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_]*");

    private SvcompWitnessExtractor() { }

    public static Optional<SvcompCorrectnessWitness> forCorrectness(Program program, SvcompProperty property)
            throws IOException {
        if (!property.supportsCorrectnessWitness()) {
            return Optional.empty();
        }
        return Optional.of(new SvcompCorrectnessWitness(metadata(programFile(program), property.specification())));
    }

    /**
     * @param properties The properties checked by the task. Only violations of these properties are reported.
     */
    public static Optional<SvcompViolationWitness> forViolation(Execution execution, Set<Property> properties)
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

    private static SvcompViolationWitness extract(Execution execution, SvcompViolation violation)
            throws IOException {
        final Program program = execution.getProgram();
        final Path programFile = programFile(program);
        final SyntacticContextAnalysis context = SyntacticContextAnalysis.newInstance(program);

        final Map<Thread, Integer> threadIds = new HashMap<>();
        final List<Segment> segments = new ArrayList<>();
        final List<Event> linearized = linearize(execution);
        final Map<Event, String> assumptions = assumptionWaypoints(linearized, execution, programFile);
        final Set<Event> prefix = eventsBefore(violation.targets(), execution);
        for (Event event : linearized) {
            if (!prefix.contains(event)) {
                continue;
            }
            final Thread thread = event.getThread();
            registerThread(segments, thread, threadIds, execution, programFile);
            final String assumption = assumptions.get(event);
            if (assumption != null) {
                final Location location = inputLocation(event, programFile);
                segments.add(new Segment(List.of(new Assumption(
                        threadIds.get(thread), assumption, "c_expression", location))));
            }
        }
        for (Event target : violation.targets()) {
            registerThread(segments, target.getThread(), threadIds, execution, programFile);
        }
        final List<Waypoint> targetWaypoints = violation.targets().stream()
                .<Waypoint>map(target -> new Target(threadIds.get(target.getThread()),
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
     * ordered sequence of thread-tagged waypoints. We only constrain reads that actually read from another thread.
     * This keeps the witness coarse while recording the observable part of rf/co.
     */
    private static Map<Event, String> assumptionWaypoints(List<Event> linearized, Execution execution,
            Path programFile) {
        final Map<Event, SourcePoint> sourcePoints = sourcePoints(execution, programFile);
        final EventGraph rf = execution.getRelation(RF).orElse(EventGraph.empty());
        final Set<Event> crossThreadReads = new HashSet<>();
        rf.apply((write, read) -> {
            if (read instanceof Load && !(write instanceof Init) && write.getThread() != read.getThread()) {
                crossThreadReads.add(read);
            }
        });

        final Map<SourcePoint, Event> representatives = new HashMap<>();
        final Map<SourcePoint, Set<String>> constraints = new HashMap<>();
        for (Event event : linearized) {
            final SourcePoint point = sourcePoints.get(event);
            if (!(event instanceof Load load) || !crossThreadReads.contains(event) || point == null) {
                continue;
            }
            final Optional<String> constraint = readValueAssumption(load, execution);
            if (constraint.isPresent()) {
                representatives.putIfAbsent(point, event);
                constraints.computeIfAbsent(point, _ -> new LinkedHashSet<>()).add(constraint.get());
            }
        }

        final Map<Event, String> result = new HashMap<>();
        constraints.forEach((point, values) ->
                result.put(representatives.get(point), String.join(" && ", values)));
        return result;
    }

    private static Map<Event, SourcePoint> sourcePoints(Execution execution, Path programFile) {
        final Map<Event, SourcePoint> result = new HashMap<>();
        for (ThreadExecution thread : execution.getThreads()) {
            Location previous = null;
            int occurrence = 0;
            for (Event event : tracedEvents(thread)) {
                final Location location = inputLocation(event, programFile);
                if (location == null) {
                    continue;
                }
                if (!location.equals(previous)) {
                    occurrence++;
                    previous = location;
                }
                result.put(event, new SourcePoint(thread.getThread(), occurrence, location));
            }
        }
        return result;
    }

    // The events relevant for the witness: memory accesses and events that carry control/data flow.
    private static boolean isTraced(Event e) {
        return e instanceof Load || e instanceof Store || e instanceof GenericVisibleEvent
                || e instanceof Local || e instanceof Assert || e instanceof CondJump;
    }

    private static List<Event> tracedEvents(ThreadExecution thread) {
        return thread.getTrace().stream().filter(SvcompWitnessExtractor::isTraced).toList();
    }

    private static Optional<String> readValueAssumption(Load load, Execution execution) {
        if (!(load.getAccessType() instanceof IntegerType) && !(load.getAccessType() instanceof BooleanType)) {
            return Optional.empty();
        }
        final int accessSize = TypeFactory.getInstance().getMemorySizeInBytes(load.getAccessType());
        final Optional<MemoryObject> object = execution.location(load)
                .filter(location -> location.offset().signum() == 0)
                .map(MemoryLayout.Location::base)
                .filter(memory -> memory.size().equals(BigInteger.valueOf(accessSize)))
                .map(MemoryLayout.AllocatedObject::object)
                .filter(memory -> memory.isStaticallyAllocated() && memory.hasName())
                .filter(memory -> C_IDENTIFIER.matcher(memory.getName()).matches());
        if (object.isEmpty()) {
            return Optional.empty();
        }
        final Optional<String> literal = switch (execution.value(load)) {
            case BoolLiteral b -> Optional.of(b.getValue() ? "1" : "0");
            case IntLiteral i -> Optional.of(i.getValue().toString());
            default -> Optional.empty();
        };
        return literal.map(l -> String.format("(%s == %s)", object.get().getName(), l));
    }

    private static List<Event> linearize(Execution execution) {
        final EventGraph hb = execution.getRelation(HB)
                .orElseThrow(() -> new VerifyException(
                        "Execution does not contain relation '%s'".formatted(HB)));

        final List<Event> events = execution.getEvents().stream().filter(SvcompWitnessExtractor::isTraced).toList();
        final Map<Event, Set<Event>> predecessors = new HashMap<>();
        hb.apply((from, to) -> {
            Verify.verify(from != to, "svcomp.cat produced a non-SC execution");
            predecessors.computeIfAbsent(to, _ -> new HashSet<>()).add(from);
        });

        final DependencyGraph<Event> dependencyGraph = DependencyGraph.from(events, predecessors);
        Verify.verify(dependencyGraph.getSCCs().size() == dependencyGraph.getNodes().size(),
                "svcomp.cat produced a non-SC execution");
        return dependencyGraph.getNodeContents();
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

    private record SourcePoint(Thread thread, int occurrence, Location location) { }

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

    private static Set<Event> eventsBefore(List<Event> targets, Execution execution) {
        final Set<Event> result = new HashSet<>();
        for (Event target : targets) {
            final ThreadExecution thread = execution.getThread(target.getThread());
            thread.getTrace().subList(0, thread.getPosition(target)).stream()
                    .filter(SvcompWitnessExtractor::isTraced)
                    .forEach(result::add);
        }
        return result;
    }

    private static Location requireInputLocation(Event event, Path programFile) {
        final Location location = inputLocation(event, programFile);
        if (location == null) {
            throw new IllegalArgumentException("Violation target has no source location in the input program");
        }
        return location;
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
