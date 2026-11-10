package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.memory.ToMemoryCast;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationResult;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.task.verification.VerificationTask;
import com.dat3m.dartagnan.task.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.IOException;
import java.io.StringWriter;
import java.nio.file.Path;
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
import static org.junit.Assert.*;
import static org.junit.Assume.assumeTrue;

/*
    Cross-checks executions extracted from SMT models against the models themselves, and checks that the
    extracted executions remain usable after the solver (and thus the model) has been closed.
 */
@RunWith(Parameterized.class)
public class ExecutionTest {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final Arch arch;
    private final Path programPath;
    private final String wmmName;
    private final Property property;
    private final int bound;

    public ExecutionTest(String name, Arch arch, Path programPath, String wmmName, Property property, int bound) {
        this.arch = arch;
        this.programPath = programPath;
        this.wmmName = wmmName;
        this.property = property;
        this.bound = bound;
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        final List<Object[]> data = new ArrayList<>();

        // Litmus tests whose encoding is satisfiable, so that the solver produces an execution.
        addLitmusTests(data, Arch.TSO, "TSO", null, Property.PROGRAM_SPEC, List.of(
                "X86/R+po+po-po-pos", "X86/SB+mfence+po-rfi-po", "X86/classic", "X86/intel.paul-tso",
                "X86/m44i"));
        addLitmusTests(data, Arch.ARM8, "ARM8", null, Property.PROGRAM_SPEC, List.of(
                "AARCH64/EXTRA/ARMARM04+TER", "AARCH64/PPO/MP+dmb.sy+addr-fri-[ws-rf]-ctrl-pos",
                "AARCH64/SYS/2+2W+dmb.stpl+po", "AARCH64/dart/ATOM05-02", "AARCH64/mixed/PPOCA-MIXED-5"));
        addLitmusTests(data, Arch.POWER, "PPC", null, Property.PROGRAM_SPEC, List.of(
                "PPC/DETOUR0386", "PPC/DETOUR0868", "PPC/DETOUR1321", "PPC/W+RWC+lwsync+po+po",
                "PPC/Z6.5+sync+sync+lwsync"));
        addLitmusTests(data, Arch.C11, "RC11", "rc11", Property.PROGRAM_SPEC, List.of(
                "C11/auto/a1+Wna+rel", "C11/auto/a1_reorder+sc+Racq", "C11/auto/a3+sc+Racq",
                "C11/auto/a3_reorder+Wna+acq", "C11/auto/b_reorder+sc+acq"));
        addLitmusTests(data, Arch.LKMM, "LKMM-DR", "linux-kernel", Property.CAT_SPEC, List.of(
                "LKMM/auto/C-LB-Lrw+R-A+R-Od+R-D", "LKMM/auto/C-LB-Lwr+R-A+R-A+R-A", "LKMM/auto/C-LB-Lwr+R-Oc+R-D",
                "LKMM/auto/C-LB-Lww+R-A+R-Od+R-Od", "LKMM/lockfree/Michael-Scott"));
        // Coherence is not total in PTX, so the final value must come from the right co-maximal store.
        addLitmusTests(data, Arch.PTX, "PTX", "ptx-v7.5", Property.PROGRAM_SPEC, List.of(
                "PTX/Memalloy/IRWIW_gl_cta"));
        // Virtual addressing: accesses to distinct virtual addresses of the same physical location.
        addLitmusTests(data, Arch.PTX, "PTX", "ptx-v7.5", Property.PROGRAM_SPEC, List.of(
                "PTX/Nvidia/proxy/Proxy-SingleThread-rf-surW-genR", "PTX/Nvidia/proxy/Proxy-MP-gpu2"));
        // Threads blocked at a barrier.
        addLitmusTests(data, Arch.VULKAN, "VULKAN", "vulkan", Property.TERMINATION, List.of(
                "VULKAN/Barrier/quorum1-hang"));

        // SPIR-V programs whose encoding is satisfiable: violated forall specifications, exists specifications
        // that hold, and data races.
        addSpirvTest(data, "vulkan/benchmarks/caslock-acq2rx", Arch.VULKAN, Property.PROGRAM_SPEC);
        addSpirvTest(data, "vulkan/patterns/mp-acq2rx", Arch.VULKAN, Property.PROGRAM_SPEC);
        addSpirvTest(data, "vulkan/patterns/sb", Arch.VULKAN, Property.PROGRAM_SPEC);
        addSpirvTest(data, "vulkan/barrier/scope/barrier-not-inscope-wg", Arch.VULKAN, Property.CAT_SPEC);
        addSpirvTest(data, "vulkan/benchmarks/ticketlock-dv2wg-1.1.2", Arch.VULKAN, Property.CAT_SPEC);
        addSpirvTest(data, "opencl/benchmarks/ticketlock-acq2rx", Arch.OPENCL, Property.PROGRAM_SPEC);
        addSpirvTest(data, "opencl/patterns/mp-rel2rx", Arch.OPENCL, Property.PROGRAM_SPEC);
        addSpirvTest(data, "opencl/barrier/inlining/barrier-inlining-1-exists-correct", Arch.OPENCL, Property.PROGRAM_SPEC);
        addSpirvTest(data, "opencl/barrier/scope/barrier-not-inscope-wg", Arch.OPENCL, Property.CAT_SPEC);
        addSpirvTest(data, "opencl/benchmarks/caslock-dv2wg-1.1.2", Arch.OPENCL, Property.CAT_SPEC);

        // LLVM programs: dynamic memory (incl. free), floats, nondeterminism, threads
        addLlvmTest(data, "locks/clh_mutex-acq2rx", Arch.IMM, 2);
        addLlvmTest(data, "locks/ticket_awnsb_mutex-acq2rx", Arch.IMM, 2);
        for (String name : List.of("idd_dynamic", "idd_dynamic_2", "propagatableSideEffects", "verifierAssert")) {
            addLlvmTest(data, "miscellaneous/" + name, Arch.ARM8, 1);
        }
        for (String name : List.of("MP_atomic_bool_weak", "nondet_loop", "thread_loop", "thread_invalid_join_self",
                "thread_invalid_join_uninit", "uninitRead", "nondet_alloc", "unknown_function", "floats_5_f",
                "floats_6_f", "floats_15_f", "floats_16_f", "alias-shrinkToBounds")) {
            addLlvmTest(data, "miscellaneous/" + name, Arch.IMM, 1);
        }
        return data;
    }

    private static void addLitmusTests(List<Object[]> data, Arch arch, String suite, String wmmName,
                                       Property property, List<String> names) {
        for (String name : names) {
            final Path path = ResourceHelper.getRootPath("litmus/" + name + ".litmus");
            data.add(new Object[]{ suite + ":" + path.getFileName(), arch, path, wmmName, property, 1 });
        }
    }

    private static void addSpirvTest(List<Object[]> data, String name, Arch arch, Property property) {
        final Path path = ResourceHelper.getTestResourcePath("spirv/" + name + ".spvasm");
        data.add(new Object[]{ "spirv/" + name + ":" + property, arch, path, null, property, 1 });
    }

    private static void addLlvmTest(List<Object[]> data, String name, Arch arch, int bound) {
        final Path path = ResourceHelper.getTestResourcePath(name + ".ll");
        data.add(new Object[]{ name, arch, path, null, Property.PROGRAM_SPEC, bound });
    }

    @Test
    public void testEager() throws Exception {
        test(Method.EAGER);
    }

    @Test
    public void testLazy() throws Exception {
        test(Method.LAZY);
    }

    private void test(Method method) throws Exception {
        final VerificationTask task = Task.builder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withBound(bound)
                .withTarget(arch)
                .withOption(PHANTOM_REFERENCES, "true")
                // Same options as the litmus and LLVM suites use
                .withOption(INITIALIZE_REGISTERS, String.valueOf(programPath.toString().endsWith(".litmus")))
                .build(TestHelper.parseProgram(programPath),
                        TestHelper.parseWmm(ResourceHelper.getCatPath(arch, wmmName)),
                        EnumSet.of(property));

        final VerificationResult result;
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, method)) {
            solver.run();
            result = solver.getResult();
        }
        // Reachability specs report satisfiable encodings as PASS, so we only require a conclusive execution.
        assumeTrue(result.getStatus() != VerificationStatus.UNKNOWN && result.hasExecution());

        // The solver is closed now, the execution must still work.
        final Execution execution = result.getExecution();
        checkAgainstVerdict(execution, result);
        checkConsistency(execution);
        checkGraphvizWitness(execution);

    }

    // The violations reported by the solver must be visible in the execution.
    private void checkAgainstVerdict(Execution execution, VerificationResult result) {
        final Program program = execution.getProgram();

        if (result.isViolated(Property.CAT_SPEC)) {
            assertFalse("No flag raised", execution.getRaisedFlags().isEmpty());
        }

        if (result.isViolated(Property.TERMINATION)) {
            final boolean isStuck = execution.getThreads().stream().anyMatch(ThreadExecution::isBlocked)
                    || execution.getEvents(CondJump.class).stream()
                            .anyMatch(j -> j.hasTag(Tag.NONTERMINATION) && execution.jumpTaken(j));
            assertTrue("No thread is stuck", isStuck);
        }
        for (ThreadExecution thread : execution.getThreads()) {
            for (BlockingEvent blocked : thread.getBlockedEvents()) {
                assertTrue(execution.isBlocked(blocked));
                assertFalse("Blocked event " + blocked + " is executed", execution.isExecuted(blocked));
            }
        }

        if (result.isViolated(Property.PROGRAM_SPEC) && program.getFormat() == Program.SourceLanguage.LLVM) {
            assertTrue("No assertion violated",
                    execution.getEvents(Assert.class).stream().anyMatch(execution::assertionViolated));
        }

        if (property == Property.PROGRAM_SPEC && program.getFormat() != Program.SourceLanguage.LLVM) {
            final Optional<Boolean> expected = expectedSpecValue(program.getSpecificationType(), result.getStatus());
            if (expected.isPresent()) {
                assertEquals("Specification " + program.getSpecification(), expected,
                        execution.evaluateBooleanFinal(program.getSpecification()));
            }
            assertEquals(Optional.of(true), execution.evaluateBooleanFinal(program.getFilterSpecification()));
        }
    }

    // The value the specification must have in an execution that leads to the given verdict.
    private static Optional<Boolean> expectedSpecValue(Program.SpecificationType type, VerificationStatus status) {
        return switch (type) {
            case EXISTS -> Optional.of(status == VerificationStatus.PASS);
            case NOT_EXISTS -> Optional.of(status == VerificationStatus.FAIL);
            case FORALL -> Optional.of(status != VerificationStatus.FAIL);
            case ASSERT -> Optional.empty();
        };
    }

    // Checks that values recomputed by the execution's own expression evaluation agree with the extracted values.
    private void checkConsistency(Execution execution) {
        // rf and co are subsets of loc (virtual addressing is correctly handled)
        final EventGraph loc = execution.getRelation(LOC).orElseThrow();
        for (String name : List.of(RF, CO)) {
            execution.getRelation(name).ifPresent(graph -> graph.apply((e1, e2) ->
                    assertTrue(name + " edge (" + e1 + ", " + e2 + ") is not in loc", loc.contains(e1, e2))));
        }
        for (Relation relation : execution.getMemoryModel().getRelations()) {
            if (RelationEvaluator.isBase(relation)) {
                assertFalse("Mutable graph for " + relation, execution.getRelation(relation) instanceof MutableEventGraph);
            }
        }
        for (Axiom axiom : execution.getMemoryModel().getAxioms()) {
            if (!axiom.isFlagged()) {
                assertTrue("Axiom violated: " + axiom, execution.isSatisfied(axiom));
            }
        }
        for (MemoryCoreEvent e : execution.getEvents(MemoryCoreEvent.class)) {
            assertSameValue("address of " + e, e.getAddress(), execution.address(e), execution.evaluateAt(e.getAddress(), e));
        }
        for (Store store : execution.getEvents(Store.class)) {
            assertSameValue("value of " + store, store.getMemValue(), execution.value(store),
                    execution.evaluateAt(store.getMemValue(), store));
        }
        for (Assert assertion : execution.getEvents(Assert.class)) {
            assertSameValue("assertion " + assertion, assertion.getExpression(),
                    expressions.makeValue(!execution.assertionViolated(assertion)),
                    execution.evaluateAt(assertion.getExpression(), assertion));
        }
        for (CondJump jump : execution.getEvents(CondJump.class)) {
            assertSameValue("guard of " + jump, jump.getGuard(), expressions.makeValue(execution.jumpTaken(jump)),
                    execution.evaluateAt(jump.getGuard(), jump));
        }
    }

    private static void checkGraphvizWitness(Execution execution) throws IOException {
        final StringWriter writer = new StringWriter();
        new ExecutionGraphVisualizer().generateGraphOfExecution(writer, "witness", execution);
        final String dot = writer.toString();
        assertTrue(dot.startsWith("digraph"));
        // Every edge endpoint must be a declared node (or an inline init node).
        final Set<String> nodes = new HashSet<>();
        final java.util.regex.Matcher nodeMatcher = java.util.regex.Pattern.compile("(?m)^\\s*(e\\d+) \\[").matcher(dot);
        while (nodeMatcher.find()) {
            nodes.add(nodeMatcher.group(1));
        }
        final java.util.regex.Matcher edgeMatcher = java.util.regex.Pattern.compile("(e\\d+) -> (e\\d+)").matcher(dot);
        while (edgeMatcher.find()) {
            assertTrue("Undeclared node in edge " + edgeMatcher.group(), nodes.contains(edgeMatcher.group(1)));
            assertTrue("Undeclared node in edge " + edgeMatcher.group(), nodes.contains(edgeMatcher.group(2)));
        }
    }

    private static void assertSameValue(String what, Expression expr, Expression expected, Optional<Expression> actual) {
        if (actual.isEmpty()) {
            // Known limitation: ExprSimplifier does not fold floating-point operations.
            assertTrue(what + " not evaluable", involvesFloats(expr));
            return;
        }
        if (isIntegerConstant(expected) && isIntegerConstant(actual.get())) {
            assertEquals(what, expected.getType(), actual.get().getType());
            assertEquals(what, ExpressionHelper.toUnsignedValue(expected), ExpressionHelper.toUnsignedValue(actual.get()));
        } else {
            assertEquals(what, expected, actual.get());
        }
    }

    private static boolean isIntegerConstant(Expression e) {
        return e instanceof IntLiteral || e instanceof ToMemoryCast cast && cast.getOperand() instanceof IntLiteral;
    }

    private static boolean involvesFloats(Expression expr) {
        return expr.getType() instanceof FloatType
                || expr.getOperands().stream().anyMatch(ExecutionTest::involvesFloats);
    }
}
