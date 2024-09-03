package com.dat3m.dartagnan.spirv.benchmarks;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
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
public class SpirvAssertionsTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvAssertionsTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/benchmarks/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"caslock-1.1.2.spv.dis", 2, PASS},
                {"caslock-2.1.1.spv.dis", 2, PASS},
                {"caslock-acq2rx.spv.dis", 1, FAIL},
                {"caslock-rel2rx.spv.dis", 1, FAIL},
                {"caslock-dv2wg-2.1.1.spv.dis", 2, PASS},
                {"caslock-dv2wg-1.1.2.spv.dis", 1, FAIL},
                {"CORR.spv.dis", 1, PASS},
                {"IRIW.spv.dis", 1, PASS},
                {"MP.spv.dis", 1, PASS},
                {"MP-acq2rx.spv.dis", 1, FAIL},
                {"MP-rel2rx.spv.dis", 1, FAIL},
                {"SB.spv.dis", 1, PASS},
                {"ticketlock-1.1.2.spv.dis", 1, PASS},
                {"ticketlock-2.1.1.spv.dis", 1, PASS},
                {"ticketlock-acq2rx.spv.dis", 1, FAIL},
                {"ticketlock-rel2rx.spv.dis", 1, FAIL},
                {"ticketlock-dv2wg-2.1.1.spv.dis", 2, PASS},
                {"ticketlock-dv2wg-1.1.2.spv.dis", 1, FAIL},
                {"ttaslock-1.1.2.spv.dis", 2, PASS},
                {"ttaslock-2.1.1.spv.dis", 2, PASS},
                {"ttaslock-acq2rx.spv.dis", 1, FAIL},
                {"ttaslock-rel2rx.spv.dis", 1, FAIL},
                {"ttaslock-dv2wg-2.1.1.spv.dis", 2, PASS},
                {"ttaslock-dv2wg-1.1.2.spv.dis", 1, FAIL},

                {"xf-barrier-2.1.2.spv.dis", 4, PASS},
                // Slow test
                // {"xf-barrier-3.1.3.spv.dis", 9, PASS},
                // TODO: IMO should pass (spinloop handling?)
                // {"xf-barrier-1.1.2.spv.dis", 2, PASS},
                {"xf-barrier-2.1.1.spv.dis", 2, PASS},
                {"xf-barrier-fail1.spv.dis", 4, FAIL},
                {"xf-barrier-fail2.spv.dis", 4, FAIL},
                {"xf-barrier-fail3.spv.dis", 4, FAIL},
                {"xf-barrier-fail4.spv.dis", 4, FAIL},
                {"xf-barrier-weakest.spv.dis", 4, FAIL},

                {"xf-barrier-local-2.1.2.spv.dis", 4, FAIL},
                // Slow test
                // {"xf-barrier-local-3.1.3.spv.dis", 9, FAIL},
                // TODO: ??
                // {"xf-barrier-local-1.1.2.spv.dis", 2, FAIL},
                {"xf-barrier-local-2.1.1.spv.dis", 2, FAIL},
                {"xf-barrier-local-fail1.spv.dis", 4, FAIL},
                {"xf-barrier-local-fail2.spv.dis", 4, FAIL},
                {"xf-barrier-local-fail3.spv.dis", 4, FAIL},
                {"xf-barrier-local-fail4.spv.dis", 4, FAIL},
                {"xf-barrier-local-weakest.spv.dis", 4, FAIL},

                {"xf-barrier-zero-2.1.2.spv.dis", 4, FAIL},
                // Slow test
                // {"xf-barrier-zero-3.1.3.spv.dis", 9, FAIL},
                // TODO: ??
                // {"xf-barrier-zero-1.1.2.spv.dis", 2, FAIL},
                {"xf-barrier-zero-2.1.1.spv.dis", 2, FAIL},
                {"xf-barrier-zero-fail1.spv.dis", 4, FAIL},
                {"xf-barrier-zero-fail2.spv.dis", 4, FAIL},
                {"xf-barrier-zero-fail3.spv.dis", 4, FAIL},
                {"xf-barrier-zero-fail4.spv.dis", 4, FAIL},
                {"xf-barrier-zero-weakest.spv.dis", 4, FAIL},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        /* TODO: Implementation
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
             assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }*/
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
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

    private ProverEnvironment mkProver(SolverContext ctx) {
        return ctx.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().build())
                .withBound(bound)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }
}
