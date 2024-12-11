package com.dat3m.dartagnan.inlineAsm.threads;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import static org.junit.Assert.assertEquals;
import org.sosy_lab.common.log.BasicLogManager;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import com.dat3m.dartagnan.utils.Result;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.verification.VerificationTask;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.LIVENESS;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.wmm.Wmm;

@RunWith(Parameterized.class)
public class InlineAsmTestThreads {

    private final String modelPath = getRootPath("cat/aarch64.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public InlineAsmTestThreads(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("inlineasm/threads/" + file + ".ll");
        this.bound = bound;
        this.expected = expected;
    }

    // protected Provider<Solvers> getSolverProvider() {
    //     return () -> Solvers.YICES2;
    // }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
            {"cnd_test1", 3, PASS},
            {"cnd_test2", 3, PASS},
            {"mutex_musl", 3, PASS},
            {"mutex_slim", 3, PASS},
            // {"mutex_tristate", 4, PASS}, // out of memory heap
            {"mutex_waiters", 3, PASS},
            {"once", 5, PASS}
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        long start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }
        
        System.out.println((System.currentTimeMillis() - start) + " time elapsed Refinment");
        start = System.currentTimeMillis();
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }
        System.out.println((System.currentTimeMillis() - start) + " time elapsed Assume");
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
                .withTarget(Arch.ARM8);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(LIVENESS, PROGRAM_SPEC));
    }
}
