package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.ThreadCreation;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.Candidate;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedVariable;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWaypoint;
import com.dat3m.dartagnan.witness.svcomp.SvcompWitnessResolver.ResolvedWitness;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.math.BigInteger;
import java.nio.file.Path;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;
import static org.junit.Assert.*;

public class SvcompWitnessResolverTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType INT = types.getIntegerType(32);

    // Source lines of the test program, see build().
    private static final int CREATE_LINE = 3;
    private static final int READ_LINE = 4;
    private static final int WRITE_LINE = 5;
    private static final int WORKER_LINE = 9;

    /**
     * Builds the program
     * <pre>
     * 3: create(worker);
     * 4: y = x;
     * 5: x = 2;
     * 9: worker() { x = 1; }
     * </pre>
     * where line 4 consists of a load of x followed by a store to y.
     * Creating the worker {@code workers} times on line 3 models a loop unrolled to that bound.
     */
    private record TestProgram(Program program, AliasAnalysis alias, MemoryObject x) {

        static TestProgram build(int workers) throws Exception {
            final FunctionType mainType = types.getFunctionType(types.getArchType(), List.of());
            final FunctionType workerType = types.getFunctionType(types.getVoidType(), List.of());
            final ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
            final MemoryObject x = builder.newMemoryObject("x", 4);
            final MemoryObject y = builder.newMemoryObject("y", 4);
            final Function main = builder.newFunction("main", 0, mainType, List.of());
            final Function worker = builder.newFunction("worker", 1, workerType, List.of());
            for (int i = 0; i < workers; i++) {
                final Register id = builder.getOrNewRegister(0, "id" + i);
                add(builder, 0, CREATE_LINE, EventFactory.newDynamicThreadCreate(id, workerType, worker, List.of()));
            }
            final Register value = builder.getOrNewRegister(0, "value", INT);
            add(builder, 0, READ_LINE, EventFactory.newLoad(value, x));
            add(builder, 0, READ_LINE, EventFactory.newStore(y, value));
            add(builder, 0, WRITE_LINE, EventFactory.newStore(x, expressions.makeValue(2, INT)));
            add(builder, 1, WORKER_LINE, EventFactory.newStore(x, expressions.makeValue(1, INT)));
            final Program program = builder.build();
            program.setEntrypoint(new Entrypoint.Simple(main));
            ThreadCreation.fromConfig(Configuration.defaultConfiguration()).run(program);
            return new TestProgram(program, analyze(program), x);
        }

        private static void add(ProgramBuilder builder, int function, int line, Event event) {
            builder.addChildWithoutSourceLoc(function, event);
            event.setMetadata(new SourceLocation.Generic("dir/test.c", line));
        }

        private static AliasAnalysis analyze(Program program) throws Exception {
            final Configuration config = Configuration.builder()
                    .setOption(ALIAS_METHOD, Alias.getDefault().asStringOption())
                    .build();
            program.setArch(Arch.C11);
            program.markAsUnrolled(1);
            program.markAsCompiled();
            final Context context = Context.create();
            context.register(EventDomainRepository.class, EventDomainRepository.forProgram(program));
            context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
            context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(
                    program, ProgressModel.uniform(ProgressModel.FAIR), context, config));
            context.register(ReachingDefinitionsAnalysis.class,
                    ReachingDefinitionsAnalysis.fromConfig(program, context, config));
            return AliasAnalysis.fromConfig(program, context, config, false);
        }

        Thread main() {
            return program.getMainThread().orElseThrow();
        }

        List<Thread> workers() {
            return program.getThreads().stream().filter(thread -> thread.getEntry().isSpawned()).toList();
        }

        List<Event> mainEventsAt(int line) {
            return main().getEvents().stream().filter(event -> isAt(event, line)).toList();
        }

        ResolvedWitness resolve(Waypoint... segments) {
            final List<Segment> content = Arrays.stream(segments)
                    .map(waypoint -> new Segment(List.of(waypoint))).toList();
            return SvcompWitnessResolver.resolve(new SvcompViolationWitness(METADATA, content), program, alias);
        }
    }

    private static final Metadata METADATA = new Metadata("2.2", "uuid", Instant.EPOCH,
            new Producer("test", "1"), new Task(Path.of("test.c"), "hash", "spec", "ILP32", "C"));

    private static Location at(int line) {
        return new Location(Path.of("test.c"), line);
    }

    private static boolean isAt(Event event, int line) {
        return event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic generic
                && generic.lineNumber() == line;
    }

    private static List<Event> events(ResolvedWaypoint waypoint) {
        return waypoint.candidates().stream().map(Candidate::event).toList();
    }

    // ------------------------------------------------------------------------------------------------------

    @Test
    public void matchesIgnoreDirectories() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final Event write = test.mainEventsAt(WRITE_LINE).getFirst();
        assertTrue(SvcompWitnessResolver.matches(new Location(Path.of("other/test.c"), WRITE_LINE), write));
        assertFalse(SvcompWitnessResolver.matches(new Location(Path.of("other.c"), WRITE_LINE), write));
        assertFalse(SvcompWitnessResolver.matches(new Location(Path.of("test.c"), WRITE_LINE + 1), write));
    }

    @Test
    public void functionEnterResolvesToEntryOfCreatedThread() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final ResolvedWitness witness = test.resolve(new FunctionEnter(0, at(CREATE_LINE)));
        final ResolvedWaypoint enter = witness.segments().getFirst().waypoints().getFirst();
        assertEquals(1, enter.threadId());
        assertEquals(List.of(test.workers().getFirst().getEntry()), events(enter));
        assertEquals(List.of(test.main()), witness.threads().get(0));
        assertEquals(test.workers(), witness.threads().get(1));
    }

    @Test
    public void functionEnterKeepsEveryThreadCreatedAtTheLocation() throws Exception {
        // E.g., a loop whose first iteration skips the creation: the binding is left to the encoding.
        final TestProgram test = TestProgram.build(2);
        final ResolvedWitness witness = test.resolve(new FunctionEnter(0, at(CREATE_LINE)));
        assertEquals(2, test.workers().size());
        assertEquals(test.workers(), witness.threads().get(1));
        assertEquals(test.workers().stream().map(Thread::getEntry).toList(),
                events(witness.segments().getFirst().waypoints().getFirst()));
    }

    @Test
    public void createdThreadReceivesNextWitnessId() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final ResolvedWitness witness = test.resolve(
                new FunctionEnter(0, at(CREATE_LINE)), new Target(1, at(WORKER_LINE)));
        final ResolvedWaypoint target = witness.segments().get(1).waypoints().getFirst();
        assertEquals(1, target.threadId());
        final List<Event> targets = events(target);
        assertFalse(targets.isEmpty());
        assertTrue(targets.stream().allMatch(event -> event.getThread() == test.workers().getFirst()));
    }

    @Test
    public void threadsCreatedAtTheSameLocationShareCandidates() throws Exception {
        // With a single creation, both IDs can only bind the same thread; the encoding rejects this,
        // which lets the solver retry with higher bounds.
        final TestProgram test = TestProgram.build(1);
        final ResolvedWitness witness = test.resolve(
                new FunctionEnter(0, at(CREATE_LINE)), new FunctionEnter(0, at(CREATE_LINE)));
        assertEquals(test.workers(), witness.threads().get(1));
        assertEquals(test.workers(), witness.threads().get(2));
    }

    @Test
    public void functionEnterWithoutThreadCreationIsRejected() throws Exception {
        final TestProgram test = TestProgram.build(1);
        assertThrows(IllegalArgumentException.class, () -> test.resolve(new FunctionEnter(0, at(WRITE_LINE))));
    }

    @Test
    public void waypointOfUnknownThreadIsRejected() throws Exception {
        final TestProgram test = TestProgram.build(1);
        assertThrows(IllegalArgumentException.class, () -> test.resolve(new Target(1, at(WORKER_LINE))));
    }

    @Test
    public void waypointWithoutMatchingEventIsRejected() throws Exception {
        final TestProgram test = TestProgram.build(1);
        assertThrows(IllegalArgumentException.class, () -> test.resolve(new Target(0, at(WORKER_LINE))));
    }

    @Test
    public void targetCandidatesAreAllEventsAtTheLocation() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final ResolvedWitness witness = test.resolve(new Target(0, at(READ_LINE)));
        final ResolvedWaypoint target = witness.segments().getFirst().waypoints().getFirst();
        assertEquals(test.mainEventsAt(READ_LINE), events(target));
        assertTrue(target.candidates().stream().allMatch(candidate -> candidate.earlierInStatementInstance().isEmpty()
                && candidate.constrainedAccesses().isEmpty()));
        assertFalse(witness.hasValueConstraints());
    }

    @Test
    public void assumptionCandidatesKnowTheirStatementInstance() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final AssumptionExpression xIsOne = new VariableEquality("x", BigInteger.ONE);
        final ResolvedWitness witness = test.resolve(new Assumption(0, xIsOne, at(READ_LINE)));
        final List<Event> statement = test.mainEventsAt(READ_LINE);
        final Event load = statement.getFirst();
        final List<Candidate> candidates = witness.segments().getFirst().waypoints().getFirst().candidates();

        assertEquals(statement, candidates.stream().map(Candidate::event).toList());
        final Candidate first = candidates.getFirst();
        assertEquals(List.of(), first.earlierInStatementInstance());
        assertEquals(Set.of(load), first.constrainedAccesses());
        final Candidate last = candidates.getLast();
        assertEquals(statement.subList(0, statement.size() - 1), last.earlierInStatementInstance());
        assertEquals(Set.of(), last.constrainedAccesses());
    }

    @Test
    public void variablesResolveToTheirObjectAndWrites() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final AssumptionExpression expression = new Conjunction(
                new VariableEquality("x", BigInteger.ONE), new BooleanConstant(true));
        final ResolvedWitness witness = test.resolve(new Assumption(0, expression, at(READ_LINE)));

        assertTrue(witness.hasValueConstraints());
        assertEquals(Set.of("x"), witness.variables().keySet());
        final ResolvedVariable x = witness.variables().get("x");
        assertSame(test.x(), x.object());
        assertEquals(Set.of(WRITE_LINE, WORKER_LINE), x.writes().stream()
                .filter(write -> write.hasMetadata(SourceLocation.class))
                .map(write -> ((SourceLocation.Generic) write.getMetadata(SourceLocation.class)).lineNumber())
                .collect(Collectors.toSet()));
    }

    @Test
    public void unknownVariableIsRejected() throws Exception {
        final TestProgram test = TestProgram.build(1);
        final AssumptionExpression zIsOne = new VariableEquality("z", BigInteger.ONE);
        assertThrows(IllegalArgumentException.class, () -> test.resolve(new Assumption(0, zIsOne, at(READ_LINE))));
    }
}
