package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.IncrementalSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.verification.solving.TwoSolvers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvTest {

    // TODO: Replace with Vulkan when RA is fixed
    private final String modelPath = getRootPath("cat/sc.cat");
    private final String programPath;
    private final Result expected;

    public SpirvTest(String file, Result expected) {
        this.programPath = getTestResourcePath("spirv/" + file);
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"empty-forall.spv.dis", PASS},
                {"empty-exists.spv.dis", PASS},
                {"empty-not-exists.spv.dis", FAIL},
                {"empty-forall-false.spv.dis", FAIL},
                {"empty-exists-false.spv.dis", FAIL},
                {"empty-not-exists-false.spv.dis", PASS},
                {"init.spv.dis", PASS},
                {"init1.spv.dis", PASS},
                {"init2.spv.dis", PASS},
                {"init3.spv.dis", FAIL},
                {"read-write.spv.dis", PASS},
                {"vector-init.spv.dis", PASS},
                {"vector.spv.dis", PASS},
                {"array.spv.dis", PASS},
                {"array-of-vector.spv.dis", PASS},
                {"array-of-vector1.spv.dis", PASS},
                {"vector-read-write.spv.dis", PASS},
                {"ids.spv.dis", PASS},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        // TODO: Remove time printing
        long start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, IncrementalSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("1: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("2: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }

        System.out.println("3: " + (System.currentTimeMillis() - start));
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover1 = mkProver(ctx);
             ProverEnvironment prover2 = mkProver(ctx)) {
            assertEquals(expected, TwoSolvers.run(ctx, prover1, prover2, mkTask()).getResult());
        }
        System.out.println("4: " + (System.currentTimeMillis() - start));
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverEnvironment mkProver(SolverContext ctx) {
        return ctx.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder().withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
