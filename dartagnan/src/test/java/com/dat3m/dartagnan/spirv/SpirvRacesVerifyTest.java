package com.dat3m.dartagnan.spirv;

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
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvRacesVerifyTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvRacesVerifyTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/benchmarks/gpu-verify-auto/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"atomics/histo/histo.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writeafterread_addition/writeafterread_addition.spv.dis", 1, FAIL},
                {"warpsync/intragroup_scan/intragroup_scan.spv.dis", 1, PASS},
                {"divergence/race_and_divergence/race_and_divergence.spv.dis", 1, FAIL},
                {"array_bounds_tests/simple_array/simple_array.spv.dis", 1, PASS},
                {"array_bounds_tests/simple_array_fail_var/simple_array_fail_var.spv.dis", 1, PASS},
                {"array_bounds_tests/simple_array_fail_upper/simple_array_fail_upper.spv.dis", 1, PASS},
                {"sourcelocation_tests/needs_source_location_requires/needs_source_location_requires.spv.dis", 1, PASS},
                {"multidimarrays/test5/test5.spv.dis", 1, FAIL},
                {"array_bounds_tests/realign_simple_fail/realign_simple_fail.spv.dis", 1, PASS},
                {"null_pointers/null_pointer_assignment_unequal/null_pointer_assignment_unequal.spv.dis", 1, FAIL},
                {"report_global_id/test2/test2.spv.dis", 1, FAIL},
                {"null_pointers/null_pointer_assignment_equal/null_pointer_assignment_equal.spv.dis", 1, FAIL},
                {"array_bounds_tests/negative_index_multi_dim_fail/negative_index_multi_dim_fail.spv.dis", 1, PASS},
                {"sourcelocation_tests/barrier_divergence/pass/pass.spv.dis", 1, PASS},
                {"array_bounds_tests/multi_dim_array_fail_upper/multi_dim_array_fail_upper.spv.dis", 1, PASS},
                {"atomics/atomic_read_race/atomic_read_race.spv.dis", 1, FAIL},
                {"array_bounds_tests/multi_dim_array/multi_dim_array.spv.dis", 1, PASS},
                {"array_bounds_tests/negative_index_multi_dim/negative_index_multi_dim.spv.dis", 1, PASS},
                {"test_structs/use_array_element/use_array_element.spv.dis", 1, PASS},
                {"warpsync/scan_warp/scan_warp.spv.dis", 1, PASS},
                {"localarrayaccess/localarrayaccess.spv.dis", 1, PASS},
                {"test_structs/store_array_element/store_array_element.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writezero_nobenign/writezero_nobenign.spv.dis", 1, FAIL},
                {"barrier_intervals/test1/test1.spv.dis", 1, PASS},
                {"basicbarrier/basicbarrier.spv.dis", 1, PASS},
                {"test_structs/store_struct_element/store_struct_element.spv.dis", 1, PASS},
                {"test_local_id_inference/test_local_id_inference.spv.dis", 1, PASS},
                {"benign_race_tests/pass/writezero/writezero.spv.dis", 1, FAIL},
                {"null_pointers/null_pointer_greater/null_pointer_greater.spv.dis", 1, FAIL},
                {"pointertests/test_return_pointer/test_return_pointer.spv.dis", 1, PASS},
                {"array_bounds_tests/realign_simple/realign_simple.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/pass/read_read/read_read.spv.dis", 1, PASS},
                {"array_bounds_tests/private_array/private_array.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag/missing_local_barrier_flag.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/no_barrier_flags/no_barrier_flags.spv.dis", 1, FAIL},
                {"sourcelocation_tests/races/pass/no_race/no_race.spv.dis", 1, PASS},
                {"test_2d_local_index_inference_2/test_2d_local_index_inference_2.spv.dis", 1, PASS},
                {"misc/pass/misc2/misc2.spv.dis", 1, PASS},
                {"atomics/equality_fail/equality_fail.spv.dis", 1, PASS},
                {"array_bounds_tests/array_in_array_2/array_in_array_2.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write/local_id_benign_write_write.spv.dis", 1, FAIL},
                {"test_for_benign_read_write_bug/test_for_benign_read_write_bug.spv.dis", 1, FAIL},
                {"sourcelocation_tests/needs_source_location_ensures/needs_source_location_ensures.spv.dis", 1, PASS},
                {"test_structs/store_element/store_element.spv.dis", 1, PASS},
                {"misc/fail/miscfail1/miscfail1.spv.dis", 1, FAIL},
                {"atomics/forloop/forloop.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/sync/sync.spv.dis", 1, FAIL},
                {"mem_fence/mem_fence.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag/local_barrier_flag.spv.dis", 1, PASS},
                {"array_bounds_tests/simple_array_fail_lower/simple_array_fail_lower.spv.dis", 1, PASS},
                {"misc/fail/miscfail3/miscfail3.spv.dis", 1, FAIL},
                {"benign_race_tests/fail/writeafterread_otherval/writeafterread_otherval.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/local_id/local_id.spv.dis", 1, FAIL},
                {"barrier_intervals/test4/test4.spv.dis", 3, PASS},

                // TODO: Check
                {"test_structs/use_element/use_element.spv.dis", 1, PASS},
                // {"sourcelocation_tests/races/fail/write_read/write_read.spv.dis", 1, FAIL},
                // {"sourcelocation_tests/races/fail/write_write/normal/normal.spv.dis", 1, FAIL},
                {"test_structs/use_struct_element/use_struct_element.spv.dis", 1, PASS},
                // {"atomics/counter/counter.spv.dis", 1, PASS},
                // {"sourcelocation_tests/races/fail/read_write/read_write.spv.dis", 1, FAIL},
                {"saturate/sadd/sadd.spv.dis", 1, PASS},
                {"checkarrays/pass/specifyall/specifyall.spv.dis", 1, PASS},
                {"saturate/ssub/ssub.spv.dis", 1, PASS},
                {"no_log/pass/pass.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/pass/pass_due_to_intra_group_flag/pass_due_to_intra_group_flag.spv.dis", 1, FAIL},

                // The compiler removes the read in foo(p) since it is never used
                // Trivially DRF
                {"misc/fail/miscfail8/miscfail8.spv.dis", 1, PASS},
                {"sourcelocation_tests/race_from_call/race_from_call.spv.dis", 1, PASS},
                {"sourcelocation_tests/race_from_call_in_loop/race_from_call_in_loop.spv.dis", 1, PASS},
                {"sourcelocation_tests/races_from_indirect_calls/races_from_indirect_calls.spv.dis", 1, PASS},
                {"misc/fail/4d_array_race/4d_array_race.spv.dis", 1, PASS},
                {"misc/fail/4d_array_with_casting/4d_array_with_casting.spv.dis", 1, PASS},

                // Uses get_global_id(X) with X!=0
                // {"report_global_id/test1/test1.spv.dis", 1, FAIL},

                // Should we initialize the variable with as many entries as the number of threads?
                // {"basicglobalarray/basicglobalarray.spv.dis", 1, PASS},
                // {"misc/fail/struct_member_race/struct_member_race.spv.dis", 1, FAIL},

                // Looks like a race to me (H)
                // {"misc/pass/misc13/misc13.spv.dis", 1, PASS},
                // {"atomics/refined_atomic_abstraction/intra_local_counters/intra_local_counters.spv.dis", 1, PASS},
                {"atomics/refined_atomic_abstraction/bad_local_counters/bad_local_counters.spv.dis", 1, FAIL},
                // {"divergence/race_no_divergence/race_no_divergence.spv.dis", 1, PASS},

                // Needs large bound
                // {"test_mod_invariants/global_reduce_strength/global_reduce_strength.spv.dis", 1, PASS},
                // {"array_bounds_tests/array_in_array/array_in_array.spv.dis", 1, FAIL},
                // {"array_bounds_tests/array_in_array_param/array_in_array_param.spv.dis", 1, FAIL},
                // {"sourcelocation_tests/race_with_loop/race_with_loop.spv.dis", 1, FAIL},
                // {"test_mod_invariants/local_direct/local_direct.spv.dis", 1, PASS},

                // TODO: Support missing semantics
                // {"barrierconditionalkernelparam/barrierconditionalkernelparam.spv.dis", 1, PASS},
                // {"test_float_neq/test_float_neq.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/sync_within_group/sync_within_group.spv.dis", 1, PASS},
                // {"simpleprocedurecall/simpleprocedurecall.spv.dis", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_short/int_add_with_short.spv.dis", 1, PASS},
                // {"induction_variable/induction_variable.spv.dis", 1, PASS},
                // {"float_constant_test2/float_constant_test2.spv.dis", 1, PASS},
                // {"misc/pass/misc4/misc4.spv.dis", 1, PASS},
                // {"multiplelocals/multiplelocals.spv.dis", 1, PASS},
                // {"misc/fail/miscfail10/miscfail10.spv.dis", 1, FAIL},
                // {"multidimarrays/test1/test1.spv.dis", 1, PASS},
                // {"bool_bv_test/bool_bv_test.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/bad_read_then_write/bad_read_then_write.spv.dis", 1, FAIL},
                // {"vectortests/double4simpleaccess/double4simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/double2simpleaccess/double2simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/int3arrayaccess/int3arrayaccess.spv.dis", 1, PASS},
                // {"skeletonbinomialoptions/skeletonbinomialoptions.spv.dis", 1, PASS},
                // {"return_tests/multiloop_return/multiloop_return.spv.dis", 1, PASS},
                // {"alignment/race_location/race_location.spv.dis", 1, FAIL},
                // {"pointertests/test_opencl_local_array/test_opencl_local_array.spv.dis", 1, PASS},
                // {"pow2/64bit_loopcounter/64bit_loopcounter.spv.dis", 1, PASS},
                // {"reducedstrength_generalised/reducedstrength_generalised.spv.dis", 1, PASS},
                // {"alignment/int3int4/int3int4.spv.dis", 1, PASS},
                // {"basic1/basic1.spv.dis", 1, PASS},
                // {"simpleparampassing/simpleparampassing.spv.dis", 1, PASS},
                // {"notunaryoptest/notunaryoptest.spv.dis", 1, PASS},
                // {"pointertests/test_pass_value_from_array/test_pass_value_from_array.spv.dis", 1, PASS},
                // {"benign_race_tests/fail/writetiddiv64_offbyone/writetiddiv64_offbyone.spv.dis", 1, FAIL},
                // {"conditional_int_test/conditional_int_test.spv.dis", 1, PASS},
                // {"addressofinit/addressofinit.spv.dis", 1, PASS},
                // {"null_pointers/load_from_null/load_from_null.spv.dis", 1, PASS},
                // {"atomics/pointers/pointers.spv.dis", 1, FAIL},
                // {"multidimarrays/test4/test4.spv.dis", 1, PASS},
                // {"test_for_ssa_bug/test_for_ssa_bug.spv.dis", 1, PASS},
                // {"atomics/definitions_atom_int/definitions_atom_int.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/write_then_read/write_then_read.spv.dis", 1, PASS},
                // {"benign_race_tests/pass/writeafterread/writeafterread.spv.dis", 1, FAIL},
                // {"null_statement/null_statement.spv.dis", 1, PASS},
                // {"test_line_number_problem/test_line_number_problem.spv.dis", 1, FAIL},
                // {"vectortests/vectorsplat/vectorsplat.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/missing_global_barrier_flag/missing_global_barrier_flag.spv.dis", 1, FAIL},
                // {"multiplelocals2/multiplelocals2.spv.dis", 1, PASS},
                // {"misc/pass/misc3/misc3.spv.dis", 1, PASS},
                // {"unusedreturn/unusedreturn.spv.dis", 1, PASS},
                // {"pointertests/pointerarith/pointerarith.spv.dis", 1, PASS},
                // {"test_2d_local_index_inference/test_2d_local_index_inference.spv.dis", 1, PASS},
                // {"vectortests/float2simpleaccess/float2simpleaccess.spv.dis", 1, PASS},
                // {"derivedfrombinomialoptions2/derivedfrombinomialoptions2.spv.dis", 1, PASS},
                // {"modifyparam/modifyparam.spv.dis", 1, PASS},
                // {"benign_race_tests/pass/writeinloop/writeinloop.spv.dis", 1, FAIL},
                // {"derived_from_uniformity_analysis_bug/derived_from_uniformity_analysis_bug.spv.dis", 1, PASS},
                // {"barrier_intervals/test3/test3.spv.dis", 1, PASS},
                // {"vectortests/addressofvector/addressofvector.spv.dis", 1, PASS},
                // {"predicated_undef/predicated_undef.spv.dis", 1, PASS},
                // {"null_pointers/atomic_null/atomic_null.spv.dis", 1, PASS},
                // {"return_tests/simple_return/simple_return.spv.dis", 1, PASS},
                // {"reducedstrengthnonloopbug/reducedstrengthnonloopbug.spv.dis", 1, PASS},
                // {"simplereturn/simplereturn.spv.dis", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_float/int_add_with_float.spv.dis", 1, PASS},
                // {"test_address_of_bug/test_address_of_bug.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/bad_write_then_read/bad_write_then_read.spv.dis", 1, FAIL},
                // {"atomics/definitions_long/definitions_long.spv.dis", 1, PASS},
                // {"bitand/bitand.spv.dis", 1, PASS},
                // {"multidimarrays/test2/test2.spv.dis", 1, PASS},
                // {"test_global_id_inference/test_global_id_inference.spv.dis", 1, PASS},
                // {"atomics/displaced/displaced.spv.dis", 1, PASS},
                // {"fail_equality_and_adversarial/fail_equality_and_adversarial.spv.dis", 1, PASS},
                // {"test_mod_invariants/local_reduce_strength/local_reduce_strength.spv.dis", 1, PASS},
                // {"pointertests/test_derived_from_binomial_opts/test_derived_from_binomial_opts.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/sync_within_group_wrong_flag/sync_within_group_wrong_flag.spv.dis", 1, FAIL},
                // {"null_pointers/store_to_null_and_non_null/store_to_null_and_non_null.spv.dis", 1, PASS},
                // {"leftshiftequals/leftshiftequals.spv.dis", 1, PASS},
                // {"multidimarrays/test3/test3.spv.dis", 1, PASS},
                // {"annotation_tests/test_axiom/test_axiom.spv.dis", 1, PASS},
                // {"vectortests/float4simpleaccess/float4simpleaccess.spv.dis", 1, PASS},
                // {"pointertests/param_addressof/param_addressof.spv.dis", 1, PASS},
                // {"return_tests/id_dependent_return/id_dependent_return.spv.dis", 1, PASS},
                // {"async_work_group_copy/fail/test13/test13.spv.dis", 1, FAIL},
                // {"inter_group_and_barrier_flag_tests/pass/global_barrier/global_barrier.spv.dis", 1, PASS},
                // {"return_tests/multiloop_return_simplified/multiloop_return_simplified.spv.dis", 1, PASS},
                // {"pointertests/test_opencl_local_param/test_opencl_local_param.spv.dis", 1, PASS},
                // {"bitor/bitor.spv.dis", 1, PASS},
                // {"atomics/definitions_int/definitions_int.spv.dis", 1, PASS},
                // {"misc/pass/misc15/misc15.spv.dis", 1, PASS},
                // {"misc/fail/2d_array_race/2d_array_race.spv.dis", 1, FAIL},
                // {"benign_race_tests/fail/writewritearray_adversarial/writewritearray_adversarial.spv.dis", 1, FAIL},
                // {"bitnot/bitnot.spv.dis", 1, PASS},
                // {"bitxor/bitxor.spv.dis", 1, PASS},
                // {"sourcelocation_tests/races/fail/write_write/elem_width_16/elem_width_16.spv.dis", 1, FAIL},
                // {"transitiveclosuresimplified/transitiveclosuresimplified.spv.dis", 1, PASS},
                // {"shared_int/shared_int.spv.dis", 1, FAIL},
                // {"rightshiftequals/rightshiftequals.spv.dis", 1, PASS},
                // {"casttofloat/casttofloat.spv.dis", 1, PASS},
                // {"test_part_load_store/store_int_and_short/store_int_and_short.spv.dis", 1, PASS},
                // {"k-induction/amazingreduction/amazingreduction.spv.dis", 1, PASS},
                // {"floatrelationalop/floatrelationalop.spv.dis", 1, PASS},
                // {"warpsync/broken_shuffle/broken_shuffle.spv.dis", 1, FAIL},
                // {"pow2/64bit_relational/64bit_relational.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/read_then_write/read_then_write.spv.dis", 1, PASS},
                // {"vectortests/vectorswizzle/vectorswizzle.spv.dis", 1, PASS},
                // {"warpsync/shuffle/shuffle.spv.dis", 1, PASS},
                // {"saturate/uadd/uadd.spv.dis", 1, PASS},
                // {"saturate/usub/usub.spv.dis", 1, PASS},
                // {"shuffle/shuffle/shuffle.spv.dis", 1, PASS},
                // {"imagetests/fail2dimagecopy/fail2dimagecopy.spv.dis", 1, FAIL},
                // {"imagetests/test2dimagecopy/test2dimagecopy.spv.dis", 1, PASS},


                // TODO: Support barrier inside loop
                // {"test_2d_global_index_inference/test_2d_global_index_inference.spv.dis", 1, PASS},
                // {"sourcelocation_tests/barrier_divergence/fail/fail.spv.dis", 1, PASS},
                // {"misc/pass/misc12/misc12.spv.dis", 1, PASS},

                // TODO: UNKNOWN
                // {"sourcelocation_tests/races/fail/write_write/loop/loop.spv.dis", 1, FAIL},


        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, IncrementalSolver.run(ctx, prover, mkTask()).getResult());
        }
        /*
        // Using this solver is useless because the CAAT solver cannot deal with Property.CAT_SPEC
        try (SolverContext ctx = mkCtx(); ProverEnvironment prover = mkProver(ctx)) {
            assertEquals(expected, RefinementSolver.run(ctx, prover, mkTask()).getResult());
        }*/
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
