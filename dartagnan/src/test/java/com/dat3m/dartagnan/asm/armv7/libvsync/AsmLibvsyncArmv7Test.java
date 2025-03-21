package com.dat3m.dartagnan.asm.armv7.libvsync;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.configuration.Arch;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.TERMINATION;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import com.dat3m.dartagnan.utils.Result;
import static com.dat3m.dartagnan.utils.Result.PASS;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;

@RunWith(Parameterized.class)
public class AsmLibvsyncArmv7Test {

    private final String modelPath = getRootPath("cat/arm.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public AsmLibvsyncArmv7Test(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("asm/armv7/libvsync/" + file + ".ll");
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
            //bounded_queue
            {"bounded_spsc", 1, PASS},
            {"bounded_mpmc_check_full", 3, PASS},
            {"bounded_mpmc_check_empty", 4, PASS},

            //spinlocks
            // {"caslock", 4, PASS}, // passes Refinement but takes ~10 minutes 
            {"clhlock", 3, PASS},
            // {"cnalock", 5, PASS}, // takes 35 minutes
            {"hemlock", 3, PASS},
            {"mcslock", 3, PASS},
            {"rec_mcslock", 3, PASS},
            // {"rec_seqlock", 3, PASS}, // 25 min to pass
            {"rec_spinlock", 3, PASS},
            {"rwlock", 3, PASS},
            {"semaphore", 3, PASS},
            {"seqcount", 1, PASS},
            {"seqlock", 3, PASS},
            {"ttaslock", 3, PASS},
            {"twalock", 2, PASS},

            //threads 
            {"mutex_musl", 3, PASS},
            {"mutex_slim", 2, PASS},
            {"mutex_waiters", 2, PASS},
            {"once", 2, PASS}
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.YICES2);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().build())
                .withBound(bound)
                .withTarget(Arch.ARM7);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(TERMINATION, PROGRAM_SPEC));
    }
}
