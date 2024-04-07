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

import static com.dat3m.dartagnan.configuration.OptionNames.USE_INTEGERS;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvChecksTest {

    private final String modelPath = getRootPath("cat/spirv-check.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvChecksTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/benchmarks/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // Cannot fully unroll due to spin-loop side effects
                {"caslock.spv.dis", 2, UNKNOWN},
                {"caslock-acq2rx.spv.dis", 2, UNKNOWN},
                {"caslock-rel2rx.spv.dis", 2, UNKNOWN},
                // TODO: Unsupported decoration 'WorkgroupId'
                // {"CORR.spv.dis", 1, PASS},
                {"IRIW.spv.dis", 1, PASS},
                {"MP.spv.dis", 1, PASS},
                {"MP-acq2rx.spv.dis", 1, PASS},
                {"MP-rel2rx.spv.dis", 1, PASS},
                {"SB.spv.dis", 1, PASS},
                {"ticketlock.spv.dis", 1, PASS},
                {"ticketlock-acq2rx.spv.dis", 1, PASS},
                {"ticketlock-rel2rx.spv.dis", 1, PASS},
                // TODO: Why UNKNOWN if concrete result for assertions
                {"ttaslock.spv.dis", 2, UNKNOWN},
                {"ttaslock-acq2rx.spv.dis", 2, UNKNOWN},
                {"ttaslock-rel2rx.spv.dis", 2, UNKNOWN},
                // Unsupported decoration 'WorkgroupId'
                // {"xf-barrier.spv.dis", 1, PASS},
                // {"xf-barrier-opt.spv.dis", 1, PASS},

                // TODO: Support missing semantics
                // {"gpu-verify/atomics/atomic_read_race.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/counter.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/definitions_atom_int.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/displaced.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/forloop.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/pointers.spv.dis", 1, PASS},

                /*
                TODO: Fails checks:
                // flag ~empty scbarinstIsPo as checkScbarinstIsPo
                // flag ~empty scbarinstIsPo2 as checkScbarinstIsPo2
                {"gpu-verify/barrier_intervals/test1.spv.dis", 1, PASS},
                {"gpu-verify/barrier_intervals/test2.spv.dis", 1, PASS},
                {"gpu-verify/barrier_intervals/test3.spv.dis", 2, UNKNOWN},
                {"gpu-verify/barrier_intervals/test4.spv.dis", 2, UNKNOWN},
                 */

                {"gpu-verify/beningn_race_tests/fail/writeafterread_addition.spv.dis", 1, PASS},
                {"gpu-verify/beningn_race_tests/fail/writeafterread_otherval.spv.dis", 1, PASS},
                // TODO: Support missing semantics
                // {"gpu-verify/beningn_race_tests/fail/writetiddiv64_offbyone.spv.dis", 1, PASS},
                {"gpu-verify/beningn_race_tests/fail/writezero_nobening.spv.dis", 1, PASS},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, IncrementalSolver.run(ctx, prover, mkTask()).getResult());
        }
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover1 = mkProver(ctx);
             ProverEnvironment prover2 = mkProver(ctx)) {
            assertEquals(expected, TwoSolvers.run(ctx, prover1, prover2, mkTask()).getResult());
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
        Configuration config = Configuration.builder()
                .setOption(USE_INTEGERS, "true")
                .build();
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(config)
                .withBound(bound)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }
}