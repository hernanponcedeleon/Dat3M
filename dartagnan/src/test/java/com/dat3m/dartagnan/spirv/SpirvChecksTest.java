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
import static com.dat3m.dartagnan.utils.Result.FAIL;
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
                {"caslock-1.1.2.spv.dis", 2, PASS},
                {"caslock-2.1.1.spv.dis", 2, PASS},
                {"caslock-acq2rx.spv.dis", 1, PASS},
                {"caslock-rel2rx.spv.dis", 1, PASS},
                {"caslock-dv2wg-2.1.1.spv.dis", 2, PASS},
                {"caslock-dv2wg-1.1.2.spv.dis", 1, PASS},
                {"caslock-dv2wg-2.2.1.spv.dis", 2, PASS},
                {"caslock-dv2wg-2.2.2.spv.dis", 1, PASS},
                {"CORR.spv.dis", 1, PASS},
                {"IRIW.spv.dis", 1, PASS},
                {"MP.spv.dis", 1, PASS},
                {"MP-acq2rx.spv.dis", 1, PASS},
                {"MP-rel2rx.spv.dis", 1, PASS},
                {"SB.spv.dis", 1, PASS},
                {"ticketlock-1.1.2.spv.dis", 2, PASS},
                {"ticketlock-2.1.1.spv.dis", 2, PASS},
                {"ticketlock-acq2rx.spv.dis", 1, PASS},
                {"ticketlock-rel2rx.spv.dis", 1, PASS},
                {"ticketlock-dv2wg-2.1.1.spv.dis", 2, PASS},
                {"ticketlock-dv2wg-1.1.2.spv.dis", 1, PASS},
                {"ticketlock-dv2wg-2.2.1.spv.dis", 2, PASS},
                {"ticketlock-dv2wg-2.2.2.spv.dis", 1, PASS},
                // TODO: Why UNKNOWN if concrete result for assertions
                {"ttaslock-1.1.2.spv.dis", 2, UNKNOWN},
                {"ttaslock-2.1.1.spv.dis", 2, UNKNOWN},
                {"ttaslock-acq2rx.spv.dis", 2, UNKNOWN},
                {"ttaslock-rel2rx.spv.dis", 2, UNKNOWN},
                {"ttaslock-dv2wg-2.1.1.spv.dis", 2, UNKNOWN},
                {"ttaslock-dv2wg-1.1.2.spv.dis", 2, UNKNOWN},
                {"ttaslock-dv2wg-2.2.1.spv.dis", 2, UNKNOWN},
                {"ttaslock-dv2wg-2.2.2.spv.dis", 2, UNKNOWN},

                {"xf-barrier-2.1.2.spv.dis", 4, PASS},
                {"xf-barrier-3.1.3.spv.dis", 9, PASS},
                {"xf-barrier-2.1.1.spv.dis", 2, PASS},
                {"xf-barrier-1.1.2.spv.dis", 2, PASS},
                {"xf-barrier-fail1.spv.dis", 4, PASS},
                {"xf-barrier-fail2.spv.dis", 4, PASS},
                {"xf-barrier-fail3.spv.dis", 4, PASS},
                {"xf-barrier-fail4.spv.dis", 4, PASS},
                {"xf-barrier-weakest.spv.dis", 4, PASS},

                {"xf-barrier-local-2.1.2.spv.dis", 4, PASS},
                {"xf-barrier-local-3.1.3.spv.dis", 9, PASS},
                {"xf-barrier-local-2.1.1.spv.dis", 2, PASS},
                {"xf-barrier-local-1.1.2.spv.dis", 2, PASS},
                {"xf-barrier-local-fail1.spv.dis", 4, PASS},
                {"xf-barrier-local-fail2.spv.dis", 4, PASS},
                {"xf-barrier-local-fail3.spv.dis", 4, PASS},
                {"xf-barrier-local-fail4.spv.dis", 4, PASS},
                {"xf-barrier-local-weakest.spv.dis", 4, PASS},

                // See the comment for no_barrier_flag (below)
                /*
                {"xf-barrier-zero-2.1.2.spv.dis", 4, PASS},
                {"xf-barrier-zero-3.1.3.spv.dis", 9, PASS},
                {"xf-barrier-zero-2.1.1.spv.dis", 2, PASS},
                {"xf-barrier-zero-1.1.2.spv.dis", 2, PASS},
                {"xf-barrier-zero-fail1.spv.dis", 4, PASS},
                {"xf-barrier-zero-fail2.spv.dis", 4, PASS},
                {"xf-barrier-zero-fail3.spv.dis", 4, PASS},
                {"xf-barrier-zero-fail4.spv.dis", 4, PASS},
                {"xf-barrier-zero-weakest.spv.dis", 4, PASS}, */

                // TODO: Support missing semantics
                // {"gpu-verify/alignement/race_location.spv.dis", 1, PASS},
                {"gpu-verify/atomics/atomic_read_race.spv.dis", 1, PASS},
                {"gpu-verify/atomics/counter.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/definitions_atom_int.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/displaced.spv.dis", 1, PASS},
                {"gpu-verify/atomics/forloop.spv.dis", 1, PASS},
                {"gpu-verify/atomics/histo.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/pointers.spv.dis", 1, PASS},
                {"gpu-verify/barrier_intervals/test1.spv.dis", 1, PASS},
                {"gpu-verify/barrier_intervals/test2.spv.dis", 1, PASS},

                // TODO: Implement unrolling for control barriers
                // {"gpu-verify/barrier_intervals/test3.spv.dis", 2, UNKNOWN},
                // {"gpu-verify/barrier_intervals/test4.spv.dis", 2, UNKNOWN},

                // TODO: Support missing semantics
                {"gpu-verify/benign_race_tests/fail/writeafterread_addition.spv.dis", 1, PASS},
                {"gpu-verify/benign_race_tests/fail/writeafterread_otherval.spv.dis", 1, PASS},
                // {"gpu-verify/benign_race_tests/fail/writetiddiv64_offbyone.spv.dis", 1, PASS},
                // {"gpu-verify/benign_race_tests/fail/writewritearray_adversarial.spv.dis", 1, PASS},
                {"gpu-verify/benign_race_tests/fail/writezero_nobening.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/bad_read_then_write.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/bad_write_then_read.spv.dis", 1, PASS},
                {"gpu-verify/inter_group_and_barrier_flag_tests/fail/local_id.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/missing_global_barrier_flag.spv.dis", 1, PASS},
                {"gpu-verify/inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag.spv.dis", 1, PASS},

                // Fails check checkRelIsSem for a barrier with semantics 0x8 (rel_acq, no storage class semantics),
                // which was compiled from OpenCL barrier(0).
                // Was it intended to compile into semantics 0x0, such that it has no OpMemoryBarrier semantics?
                // https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#OpControlBarrier
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/no_barrier_flag.spv.dis", 1, PASS},

                {"gpu-verify/inter_group_and_barrier_flag_tests/fail/sync.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/sync_within_group_wrong_flag.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/pass/global_barrier.spv.dis", 1, PASS},
                {"gpu-verify/inter_group_and_barrier_flag_tests/pass/local_barrier_flag.spv.dis", 1, PASS},
                {"gpu-verify/inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write-1.1.2.spv.dis", 1, PASS},
                {"gpu-verify/inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write-2.1.1.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/pass/read_then_write.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/pass/sync_within_group.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/pass/write_then_read.spv.dis", 1, PASS},
                {"gpu-verify/globalarray-fail.spv.dis", 1, PASS},
                {"gpu-verify/globalarray-pass.spv.dis", 1, PASS},
                {"gpu-verify/globalarray-pass2.spv.dis", 1, PASS},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, IncrementalSolver.run(ctx, prover, mkTask()).getResult());
        }
        // Using this solver is useless because the CAAT solver cannot deal with Property.CAT_SPEC
        // try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
        //     assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        // }
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
