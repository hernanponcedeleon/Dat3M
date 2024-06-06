package com.dat3m.dartagnan.spirv.gpuverify;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.IncrementalSolver;
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
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvChecksTest {

    private final String modelPath = getRootPath("cat/spirv-check.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvChecksTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/gpuverify/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // Agree with gpu-verify
                {"atomics/atomic_read_race.spv.dis", 1, PASS},
                {"atomics/equality_fail.spv.dis", 1, PASS},
                {"atomics/forloop.spv.dis", 2, UNKNOWN},
                {"atomics/histo.spv.dis", 1, PASS},
                {"barrier_intervals/test1.spv.dis", 1, PASS},
                {"basicbarrier.spv.dis", 1, PASS},
                {"basicglobalarray.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writeafterread_addition.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writeafterread_otherval.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writezero_nobenign.spv.dis", 1, PASS},
                {"benign_race_tests/pass/writezero.spv.dis", 1, PASS},
                {"checkarrays/pass/specifyall.spv.dis", 1, PASS},
                {"divergence/race_and_divergence.spv.dis", 1, PASS},
                {"divergence/race_no_divergence.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/local_id.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag.spv.dis", 1, PASS},
                // Fails check checkRelIsSem for a barrier with semantics 0x8 (rel_acq, no storage class semantics)
                // {"inter_group_and_barrier_flag_tests/fail/no_barrier_flags.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/sync.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/pass_due_to_intra_group_flag.spv.dis", 1, PASS},
                {"localarrayaccess.spv.dis", 1, PASS},
                // Fails check checkRelIsSem for a barrier with semantics 0x8 (rel_acq, no storage class semantics)
                // {"mem_fence.spv.dis", 1, PASS},
                {"misc/fail/miscfail1.spv.dis", 1, PASS},
                {"misc/fail/miscfail3.spv.dis", 1, PASS},
                {"misc/fail/struct_member_race.spv.dis", 1, PASS},
                {"misc/pass/misc13.spv.dis", 1, PASS},
                {"misc/pass/misc2.spv.dis", 1, PASS},
                {"multidimarrays/test5.spv.dis", 1, PASS},
                {"no_log/pass.spv.dis", 1, PASS},
                {"null_pointers/null_pointer_assignment_equal.spv.dis", 1, PASS},
                {"null_pointers/null_pointer_assignment_unequal.spv.dis", 1, PASS},
                {"null_pointers/null_pointer_greater.spv.dis", 1, PASS},
                {"pointertests/test_return_pointer.spv.dis", 1, PASS},
                {"report_global_id/test1.spv.dis", 1, PASS},
                {"report_global_id/test2.spv.dis", 1, PASS},
                {"sourcelocation_tests/barrier_divergence/pass.spv.dis", 1, PASS},
                {"sourcelocation_tests/needs_source_location_ensures.spv.dis", 1, PASS},
                {"sourcelocation_tests/needs_source_location_requires.spv.dis", 1, PASS},
                {"sourcelocation_tests/race_with_loop.spv.dis", 2, UNKNOWN},
                {"sourcelocation_tests/races/fail/read_write.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/fail/write_read.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/fail/write_write/loop.spv.dis", 2, UNKNOWN},
                {"sourcelocation_tests/races/fail/write_write/normal.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/pass/no_race.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/pass/read_read.spv.dis", 1, PASS},
                {"test_2d_global_index_inference.spv.dis", 2, UNKNOWN},
                {"test_2d_local_index_inference_2.spv.dis", 1, PASS},
                {"test_for_benign_read_write_bug.spv.dis", 1, PASS},
                {"test_local_id_inference.spv.dis", 1, PASS},
                {"test_mod_invariants/global_reduce_strength.spv.dis", 2, UNKNOWN},
                {"test_mod_invariants/local_direct.spv.dis", 2, UNKNOWN},
                {"test_part_load_store/store_int_and_short.spv.dis", 1, PASS},
                {"test_structs/use_array_element.spv.dis", 1, PASS},
                {"test_structs/use_element.spv.dis", 1, PASS},
                {"test_structs/use_struct_element.spv.dis", 1, PASS},

                // Fails in gpu-verify, but should pass (even according to the annotation in the test)
                {"saturate/sadd.spv.dis", 1, PASS},
                {"saturate/ssub.spv.dis", 1, PASS},

                // Passes in gpu-verify, but has race (even according to the annotation in the test)
                {"atomics/refined_atomic_abstraction/bad_local_counters.spv.dis", 1, PASS},
                {"atomics/refined_atomic_abstraction/intra_local_counters.spv.dis", 1, PASS},

                // Should pass according to gpu-verify, suspecting a bug in the memory model
                {"atomics/counter.spv.dis", 1, PASS},

                // In gpu-verify fails barrier divergence but not leading to a data race
                {"barrier_intervals/test2.spv.dis", 1, PASS},
                {"sourcelocation_tests/barrier_divergence/fail.spv.dis", 1, PASS},

                // In gpu-verify fails command-line test, no races
                {"global_size/local_size_fail_divide_global_size.spv.dis", 1, PASS},
                {"global_size/mismatch_dims.spv.dis", 1, PASS},
                {"global_size/num_groups_and_global_size.spv.dis", 1, PASS},
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
