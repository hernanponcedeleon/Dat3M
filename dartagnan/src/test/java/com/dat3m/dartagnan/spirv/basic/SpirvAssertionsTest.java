package com.dat3m.dartagnan.spirv.basic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.OPENCL;
import static com.dat3m.dartagnan.configuration.Arch.VULKAN;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest {

    private final String vulkanModelPath = getRootPath("cat/spirv.cat");
    private final String openCLModelPath = getRootPath("cat/opencl.cat");
    private final Arch model;
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvAssertionsTest(String file, Arch model, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/basic/" + file);
        this.model = model;
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}, {3}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"empty-exists-false.spv.dis", VULKAN, 1, FAIL},
                {"empty-exists-true.spv.dis", VULKAN, 1, PASS},
                {"empty-forall-false.spv.dis", VULKAN, 1, FAIL},
                {"empty-forall-true.spv.dis", VULKAN, 1, PASS},
                {"empty-not-exists-false.spv.dis", VULKAN, 1, PASS},
                {"empty-not-exists-true.spv.dis", VULKAN, 1, FAIL},
                {"init-forall.spv.dis", VULKAN, 1, PASS},
                {"init-forall-split.spv.dis", VULKAN, 1, PASS},
                {"init-forall-not-exists.spv.dis", VULKAN, 1, PASS},
                {"init-forall-not-exists-fail.spv.dis", VULKAN, 1, FAIL},
                {"uninitialized-exists.spv.dis", VULKAN, 1, PASS},
                {"uninitialized-forall.spv.dis", VULKAN, 1, FAIL},
                {"uninitialized-private-exists.spv.dis", VULKAN, 1, PASS},
                {"uninitialized-private-forall.spv.dis", VULKAN, 1, FAIL},
                {"undef-exists.spv.dis", VULKAN, 1, PASS},
                {"undef-forall.spv.dis", VULKAN, 1, FAIL},
                {"read-write.spv.dis", VULKAN, 1, PASS},
                {"vector-init.spv.dis", VULKAN, 1, PASS},
                {"vector.spv.dis", VULKAN, 1, PASS},
                {"vector-aligned.spv.dis", OPENCL, 1, PASS},
                {"array.spv.dis", VULKAN, 1, PASS},
                {"array-of-vector.spv.dis", VULKAN, 1, PASS},
                {"array-of-vector1.spv.dis", VULKAN, 1, PASS},
                {"vector-read-write.spv.dis", VULKAN, 1, PASS},
                {"composite-extract.spv.dis", VULKAN, 1, PASS},
                {"composite-initial.spv.dis", VULKAN, 1, PASS},
                {"composite-insert.spv.dis", VULKAN, 1, PASS},
                {"spec-id-integer.spv.dis", VULKAN, 1, PASS},
                {"spec-id-boolean.spv.dis", VULKAN, 1, PASS},
                {"mixed-size.spv.dis", VULKAN, 1, PASS},
                {"ids.spv.dis", VULKAN, 1, PASS},
                {"builtin-constant.spv.dis", VULKAN, 1, PASS},
                {"builtin-variable.spv.dis", VULKAN, 1, PASS},
                {"builtin-default-config.spv.dis", VULKAN, 1, PASS},
                {"builtin-all-123.spv.dis", VULKAN, 1, PASS},
                {"builtin-all-321.spv.dis", VULKAN, 1, PASS},
                {"branch-cond-ff.spv.dis", VULKAN, 1, PASS},
                {"branch-cond-ff-inverted.spv.dis", VULKAN, 1, PASS},
                {"branch-cond-bf.spv.dis", VULKAN, 1, UNKNOWN},
                {"branch-cond-bf.spv.dis", VULKAN, 2, PASS},
                {"branch-cond-fb.spv.dis", VULKAN, 1, UNKNOWN},
                {"branch-cond-fb.spv.dis", VULKAN, 2, PASS},
                {"branch-race.spv.dis", VULKAN, 1, PASS},
                {"branch-loop.spv.dis", VULKAN, 2, UNKNOWN},
                {"branch-loop.spv.dis", VULKAN, 3, PASS},
                {"branch-struct-if.spv.dis", VULKAN, 1, PASS},
                {"branch-struct-if-inverted.spv.dis", VULKAN, 1, PASS},
                {"branch-struct-if-else.spv.dis", VULKAN, 1, PASS},
                {"branch-struct-if-else-inverted.spv.dis", VULKAN, 1, PASS},
                {"loop-struct-cond.spv.dis", VULKAN, 1, UNKNOWN},
                {"loop-struct-cond.spv.dis", VULKAN, 2, PASS},
                {"loop-struct-cond-suffix.spv.dis", VULKAN, 1, UNKNOWN},
                {"loop-struct-cond-suffix.spv.dis", VULKAN, 2, PASS},
                {"loop-struct-cond-sequence.spv.dis", VULKAN, 2, UNKNOWN},
                {"loop-struct-cond-sequence.spv.dis", VULKAN, 3, PASS},
                {"loop-struct-cond-nested.spv.dis", VULKAN, 2, UNKNOWN},
                {"loop-struct-cond-nested.spv.dis", VULKAN, 3, PASS},
                {"phi.spv.dis", VULKAN, 1, PASS},
                {"phi-unstruct-true.spv.dis", VULKAN, 1, PASS},
                {"phi-unstruct-false.spv.dis", VULKAN, 1, PASS},
                {"cmpxchg-const-const.spv.dis", VULKAN, 1, PASS},
                {"cmpxchg-const-reg.spv.dis", VULKAN, 1, PASS},
                {"cmpxchg-reg-const.spv.dis", VULKAN, 1, PASS},
                {"cmpxchg-reg-reg.spv.dis", VULKAN, 1, PASS},
                {"memory-scopes.spv.dis", VULKAN, 1, PASS},
                {"rmw-extremum-true.spv.dis", VULKAN, 1, PASS},
                {"rmw-extremum-false.spv.dis", VULKAN, 1, FAIL},
                {"push-constants.spv.dis", VULKAN, 1, PASS},
                {"push-constants-pod.spv.dis", VULKAN, 1, PASS},
                {"push-constant-mixed.spv.dis", VULKAN, 1, PASS},
                {"bitwise-scalar.spv.dis", VULKAN, 1, PASS},
                {"bitwise-vector.spv.dis", VULKAN, 1, PASS},
                {"alignment.spv.dis", OPENCL, 9, PASS},
                {"alignment2.spv.dis", OPENCL, 1, PASS},
                {"alignment3.spv.dis", OPENCL, 1, PASS},
                {"alignment4.spv.dis", OPENCL, 1, PASS},
                {"alignment-mixed-type.spv.dis", OPENCL, 1, PASS},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().build())
                .withBound(bound)
                .withTarget(model);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = model == VULKAN ?
                new ParserCat().parse(new File(vulkanModelPath)) :
                new ParserCat().parse(new File(openCLModelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
