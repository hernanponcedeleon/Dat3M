package com.dat3m.dartagnan.spirv.gpuverify;

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

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvRacesTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvRacesTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/gpuverify/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // Agree with gpu-verify
                {"atomics/atomic_read_race.spv.dis", 1, FAIL},
                {"atomics/equality_fail.spv.dis", 1, PASS},
                {"atomics/forloop.spv.dis", 1, FAIL},
                {"atomics/histo.spv.dis", 1, PASS},
                {"barrier_intervals/test1.spv.dis", 1, PASS},
                {"basicbarrier.spv.dis", 1, PASS},
                {"basicglobalarray.spv.dis", 1, PASS},
                {"benign_race_tests/fail/writeafterread_addition.spv.dis", 1, FAIL},
                {"benign_race_tests/fail/writeafterread_otherval.spv.dis", 1, FAIL},
                {"benign_race_tests/fail/writezero_nobenign.spv.dis", 1, FAIL},
                {"benign_race_tests/pass/writezero.spv.dis", 1, FAIL},
                {"checkarrays/pass/specifyall.spv.dis", 1, PASS},
                {"divergence/race_and_divergence.spv.dis", 1, FAIL},
                {"divergence/race_no_divergence.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/local_id.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/no_barrier_flags.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/fail/sync.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag.spv.dis", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write.spv.dis", 1, FAIL},
                {"inter_group_and_barrier_flag_tests/pass/pass_due_to_intra_group_flag.spv.dis", 1, FAIL},
                {"localarrayaccess.spv.dis", 1, PASS},
                {"mem_fence.spv.dis", 1, PASS},
                {"misc/fail/miscfail1.spv.dis", 1, FAIL},
                {"misc/fail/miscfail3.spv.dis", 1, FAIL},
                {"misc/fail/struct_member_race.spv.dis", 1, FAIL},
                {"misc/pass/misc13.spv.dis", 1, PASS},
                {"misc/pass/misc2.spv.dis", 1, PASS},
                {"multidimarrays/test5.spv.dis", 1, FAIL},
                {"no_log/pass.spv.dis", 1, FAIL},
                {"null_pointers/null_pointer_assignment_equal.spv.dis", 1, FAIL},
                {"null_pointers/null_pointer_assignment_unequal.spv.dis", 1, FAIL},
                {"null_pointers/null_pointer_greater.spv.dis", 1, FAIL},
                {"pointertests/test_return_pointer.spv.dis", 1, PASS},
                {"report_global_id/test1.spv.dis", 1, PASS},
                {"report_global_id/test2.spv.dis", 1, FAIL},
                {"sourcelocation_tests/barrier_divergence/pass.spv.dis", 1, PASS},
                {"sourcelocation_tests/needs_source_location_ensures.spv.dis", 1, PASS},
                {"sourcelocation_tests/needs_source_location_requires.spv.dis", 1, PASS},
                {"sourcelocation_tests/race_with_loop.spv.dis", 2, UNKNOWN},
                {"sourcelocation_tests/races/fail/read_write.spv.dis", 1, FAIL},
                {"sourcelocation_tests/races/fail/write_read.spv.dis", 1, FAIL},
                {"sourcelocation_tests/races/fail/write_write/loop.spv.dis", 1, FAIL},
                {"sourcelocation_tests/races/fail/write_write/normal.spv.dis", 1, FAIL},
                {"sourcelocation_tests/races/pass/no_race.spv.dis", 1, PASS},
                {"sourcelocation_tests/races/pass/read_read.spv.dis", 1, PASS},
                {"test_2d_global_index_inference.spv.dis", 2, UNKNOWN},
                {"test_2d_local_index_inference_2.spv.dis", 1, PASS},
                {"test_for_benign_read_write_bug.spv.dis", 1, FAIL},
                {"test_local_id_inference.spv.dis", 1, PASS},
                {"test_mod_invariants/global_reduce_strength.spv.dis", 1, UNKNOWN},
                {"test_part_load_store/store_int_and_short.spv.dis", 1, PASS},
                {"test_for_ssa_bug.spv.dis", 2, PASS},
                {"test_structs/use_array_element.spv.dis", 1, PASS},
                {"test_structs/use_element.spv.dis", 1, PASS},
                {"test_structs/use_struct_element.spv.dis", 1, PASS},

                // Fails in gpu-verify, but should pass (even according to the annotation in the test)
                {"saturate/sadd.spv.dis", 1, PASS},
                {"saturate/ssub.spv.dis", 1, PASS},

                // Passes in gpu-verify, but has race (even according to the annotation in the test)
                {"atomics/refined_atomic_abstraction/bad_local_counters.spv.dis", 1, FAIL},
                {"atomics/refined_atomic_abstraction/intra_local_counters.spv.dis", 1, FAIL},

                // Should pass according to gpu-verify, suspecting a bug in the memory model
                {"atomics/counter.spv.dis", 1, FAIL},

                // In gpu-verify fails barrier divergence but not leading to a data race
                {"barrier_intervals/test2.spv.dis", 1, PASS},
                {"sourcelocation_tests/barrier_divergence/fail.spv.dis", 1, PASS},

                // In gpu-verify fails command-line test, no races
                {"global_size/local_size_fail_divide_global_size.spv.dis", 1, PASS},
                {"global_size/mismatch_dims.spv.dis", 1, PASS},
                {"global_size/num_groups_and_global_size.spv.dis", 1, PASS},

                // Unsupported large array (4K elements) leading to OOM
                // {"misc/fail/2d_array_race.spv.dis", 1, FAIL},

                // Unsupported (array size too large)
                // TODO: Analyze
                // {"test_mod_invariants/local_direct.spv.dis", 1, UNKNOWN},

                // Unsupported null as a pointer
                // {"null_pointers/atomic_null.spv.dis", 1, ??},

                // Unsupported cuda warps
                // {"warpsync/intragroup_scan.spv.dis", 1, FAIL},
                // {"warpsync/scan_warp.spv.dis", 1, FAIL},

                // Unsupported barriers in a loop
                // {"barrier_intervals/test3.spv.dis", 1, PASS},
                // {"barrier_intervals/test4.spv.dis", 1, PASS},
                // {"misc/pass/misc12.spv.dis", 1, PASS},
                // {"skeletonbinomialoptions.spv.dis", 1, PASS},

                // Unsupported non-constant tags
                // {"inter_group_and_barrier_flag_tests/fail/bad_read_then_write.spv.dis", 1, FAIL},
                // {"inter_group_and_barrier_flag_tests/fail/bad_write_then_read.spv.dis", 1, FAIL},
                // {"inter_group_and_barrier_flag_tests/pass/read_then_write.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/write_then_read.spv.dis", 1, PASS},

                // Unsupported vector registers
                // {"annotation_tests/test_axiom.spv.dis", 1, PASS},
                // {"async_work_group_copy/fail/test13.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test7.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test8.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test9.spv.dis", 1, ??},
                // {"induction_variable.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/missing_global_barrier_flag.spv.dis", 1, FAIL},
                // {"inter_group_and_barrier_flag_tests/fail/sync_within_group_wrong_flag.spv.dis", 1, FAIL},
                // {"inter_group_and_barrier_flag_tests/pass/global_barrier.spv.dis", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/sync_within_group.spv.dis", 1, PASS},
                // {"k-induction/amazingreduction.spv.dis", 1, FAIL},
                // {"reducedstrength_generalised.spv.dis", 1, PASS},
                // {"test_2d_local_index_inference.spv.dis", 1, PASS},
                // {"test_global_id_inference.spv.dis", 1, PASS},
                // {"test_line_number_problem.spv.dis", 1, FAIL},
                // {"test_mod_invariants/local_reduce_strength.spv.dis", 1, PASS},

                // Unsupported spir-v ops
                // {"alignment/int3int4.spv.dis", 1, PASS},
                // {"alignment/race_location.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test1.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test10.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test14.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test15.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test16.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test17.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test18.spv.dis", 1, ??},
                // {"async_work_group_copy/fail/test2.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test4.spv.dis", 1, FAIL},
                // {"async_work_group_copy/fail/test5.spv.dis", 1, FAIL},
                // {"async_work_group_copy/pass/test1.spv.dis", 1, PASS},
                // {"async_work_group_copy/pass/test2.spv.dis", 1, PASS},
                // {"async_work_group_copy/pass/test3.spv.dis", 1, PASS},
                // {"async_work_group_copy/pass/test4.spv.dis", 1, PASS},
                // {"async_work_group_copy/pass/test5.spv.dis", 1, PASS},
                // {"async_work_group_copy/pass/test6.spv.dis", 1, ??},
                // {"async_work_group_copy/pass/test7.spv.dis", 1, ??},
                // {"async_work_group_copy/pass/test8.spv.dis", 1, ??},
                // {"async_work_group_copy/pass/test9.spv.dis", 1, ??},
                // {"atomics/definitions_atom_int.spv.dis", 1, PASS},
                // {"atomics/definitions_float.spv.dis", 1, PASS},
                // {"atomics/definitions_int.spv.dis", 1, PASS},
                // {"atomics/definitions_long.spv.dis", 1, PASS},
                // {"atomics/displaced.spv.dis", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_float.spv.dis", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_long.spv.dis", 1, ??},
                // {"atomics/mismatched_types/int_add_with_short.spv.dis", 1, PASS},
                // {"atomics/pointers.spv.dis", 1, FAIL},
                // {"atomics/refined_atomic_abstraction/many_accesses.spv.dis", 1, PASS},
                // {"atomics/refined_atomic_abstraction/one_access.spv.dis", 1, PASS},
                // {"atomics/refined_atomic_abstraction/predication.spv.dis", 1, FAIL},
                // {"barrierconditionalkernelparam.spv.dis", 1, PASS},
                // {"benign_race_tests/fail/writetiddiv64_offbyone.spv.dis", 1, FAIL},
                // {"benign_race_tests/fail/writewritearray_adversarial.spv.dis", 1, FAIL},
                // {"benign_race_tests/pass/writeinloop.spv.dis", 1, FAIL},
                // {"ceil.spv.dis", 1, PASS},
                // {"constantnotparam.spv.dis", 1, PASS},
                // {"derivedfrombinomialoptions.spv.dis", 1, PASS},
                // {"floatcastrequired.spv.dis", 1, PASS},
                // {"get_global_id.spv.dis", 1, PASS},
                // {"globalarray/fail.spv.dis", 1, FAIL},
                // {"globalarray/pass.spv.dis", 1, PASS},
                // {"imagetests/fail2dimagecopy.spv.dis", 1, FAIL},
                // {"imagetests/test2dimagecopy.spv.dis", 1, PASS},
                // {"imagetests/testsampler.spv.dis", 1, PASS},
                // {"imagetests/testsampler2.spv.dis", 1, PASS},
                // {"misc/fail/4d_array_of_vectors_race.spv.dis", 1, FAIL},
                // {"misc/fail/miscfail9.spv.dis", 1, FAIL},
                // {"misc/fail/vector_element_race.spv.dis", 1, FAIL},
                // {"misc/pass/misc15.spv.dis", 1, FAIL},
                // {"misc/pass/misc16.spv.dis", 1, PASS},
                // {"misc/pass/misc7.spv.dis", 1, PASS},
                // {"misc/pass/misc8.spv.dis", 1, PASS},
                // {"noraceduetoreturn.spv.dis", 1, PASS},
                // {"null_pointers/store_to_null_and_non_null.spv.dis", 1, ??},
                // {"pointeranalysistests/manyprocedures.spv.dis", 1, PASS},
                // {"pointeranalysistests/manyproceduresinlined.spv.dis", 1, PASS},
                // {"pointeranalysistests/testbasicaliasing.spv.dis", 1, PASS},
                // {"pointeranalysistests/testbasicaliasing2.spv.dis", 1, PASS},
                // {"pointeranalysistests/testbasicpointerarithmetic.spv.dis", 1, PASS},
                // {"pointeranalysistests/testbasicpointerarithmetic2.spv.dis", 1, PASS},
                // {"pointeranalysistests/testinterprocedural.spv.dis", 1, PASS},
                // {"pointertests/test_copy_between_memory_spaces2.spv.dis", 1, FAIL},
                // {"pow2/64bit_loopcounter.spv.dis", 1, PASS},
                // {"pow2/64bit_relational.spv.dis", 1, PASS},
                // {"saturate/uadd.spv.dis", 1, ??},
                // {"saturate/usub.spv.dis", 1, ??},
                // {"shuffle/shuffle.spv.dis", 1, PASS},
                // {"simplebinomialoptions.spv.dis", 1, PASS},
                // {"sourcelocation_tests/races/fail/write_write/elem_width_16.spv.dis", 1, FAIL},
                // {"ternarytest.spv.dis", 1, PASS},
                // {"ternarytest2.spv.dis", 1, PASS},
                // {"test_for_get_group_id.spv.dis", 1, PASS},
                // {"transitiveclosuresimplified.spv.dis", 1, PASS},
                // {"vectortests/float4arrayaccess.spv.dis", 1, PASS},
                // {"vectortests/int3arrayaccess.spv.dis", 1, PASS},
                // {"vectortests/test_paren.spv.dis", 1, FAIL},
                // {"warpsync/2d.spv.dis", 1, FAIL},
                // {"warpsync/broken_shuffle.spv.dis", 1, FAIL},
                // {"warpsync/shuffle.spv.dis", 1, FAIL},

                // Compiler eliminated reads of unused value
                // {"misc/fail/miscfail8.spv.dis", 1, FAIL},
                // {"pointertests/test_copy_between_memory_spaces.spv.dis", 1, FAIL},
                // {"sourcelocation_tests/race_from_call.spv.dis", 1, FAIL},
                // {"sourcelocation_tests/race_from_call_in_loop.spv.dis", 1, FAIL},
                // {"sourcelocation_tests/races_from_indirect_calls.spv.dis", 1, FAIL},

                // Compiler eliminated the whole main function
                // {"addressofinit.spv.dis", 1, PASS},
                // {"array_bounds_tests/array_in_array.spv.dis", 1, FAIL},
                // {"array_bounds_tests/array_in_array_2.spv.dis", 1, PASS},
                // {"array_bounds_tests/array_in_array_param.spv.dis", 1, FAIL},
                // {"array_bounds_tests/multi_dim_array.spv.dis", 1, PASS},
                // {"array_bounds_tests/multi_dim_array_fail_upper.spv.dis", 1, PASS},
                // {"array_bounds_tests/negative_index_multi_dim.spv.dis", 1, PASS},
                // {"array_bounds_tests/negative_index_multi_dim_fail.spv.dis", 1, PASS},
                // {"array_bounds_tests/private_array.spv.dis", 1, PASS},
                // {"array_bounds_tests/realign_simple.spv.dis", 1, PASS},
                // {"array_bounds_tests/realign_simple_fail.spv.dis", 1, PASS},
                // {"array_bounds_tests/simple_array.spv.dis", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_lower.spv.dis", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_upper.spv.dis", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_var.spv.dis", 1, PASS},
                // {"basic1.spv.dis", 1, PASS},
                // {"benign_race_tests/pass/writeafterread.spv.dis", 1, FAIL},
                // {"bitand.spv.dis", 1, PASS},
                // {"bitnot.spv.dis", 1, PASS},
                // {"bitor.spv.dis", 1, PASS},
                // {"bitxor.spv.dis", 1, PASS},
                // {"bool_bv_test.spv.dis", 1, PASS},
                // {"casttofloat.spv.dis", 1, PASS},
                // {"checkarrays/fail/arraydoesnotexist1.spv.dis", 1, PASS},
                // {"checkarrays/fail/arraydoesnotexist2.spv.dis", 1, PASS},
                // {"conditional_int_test.spv.dis", 1, PASS},
                // {"derived_from_uniformity_analysis_bug.spv.dis", 1, PASS},
                // {"derivedfrombinomialoptions2.spv.dis", 1, PASS},
                // {"fail_equality_and_adversarial.spv.dis", 1, PASS},
                // {"float_constant_test2.spv.dis", 1, PASS},
                // {"floatrelationalop.spv.dis", 1, PASS},
                // {"leftshiftequals.spv.dis", 1, PASS},
                // {"localmultidimarraydecl.spv.dis", 1, PASS},
                // {"misc/fail/4d_array_of_structs_race.spv.dis", 1, FAIL},
                // {"misc/fail/4d_array_race.spv.dis", 1, FAIL},
                // {"misc/fail/4d_array_with_casting.spv.dis", 1, FAIL},
                // {"misc/fail/miscfail10.spv.dis", 1, FAIL},
                // {"misc/pass/misc3.spv.dis", 1, PASS},
                // {"misc/pass/misc4.spv.dis", 1, PASS},
                // {"modifyparam.spv.dis", 1, PASS},
                // {"multidimarrays/test1.spv.dis", 1, PASS},
                // {"multidimarrays/test2.spv.dis", 1, PASS},
                // {"multidimarrays/test3.spv.dis", 1, PASS},
                // {"multidimarrays/test4.spv.dis", 1, PASS},
                // {"multiplelocals.spv.dis", 1, PASS},
                // {"multiplelocals2.spv.dis", 1, PASS},
                // {"notunaryoptest.spv.dis", 1, PASS},
                // {"null_pointers/load_from_null.spv.dis", 1, ??},
                // {"null_statement.spv.dis", 1, PASS},
                // {"pointertests/param_addressof.spv.dis", 1, PASS},
                // {"pointertests/pointerarith.spv.dis", 1, PASS},
                // {"pointertests/test_derived_from_binomial_opts.spv.dis", 1, PASS},
                // {"pointertests/test_opencl_local_array.spv.dis", 1, ??},
                // {"pointertests/test_opencl_local_param.spv.dis", 1, ??},
                // {"pointertests/test_pass_value_from_array.spv.dis", 1, PASS},
                // {"predicated_undef.spv.dis", 1, PASS},
                // {"reducedstrengthnonloopbug.spv.dis", 1, PASS},
                // {"return_tests/id_dependent_return.spv.dis", 1, PASS},
                // {"return_tests/multiloop_return.spv.dis", 1, PASS},
                // {"return_tests/multiloop_return_simplified.spv.dis", 1, PASS},
                // {"return_tests/simple_return.spv.dis", 1, PASS},
                // {"rightshiftequals.spv.dis", 1, PASS},
                // {"shared_int.spv.dis", 1, FAIL},
                // {"simpleparampassing.spv.dis", 1, PASS},
                // {"simpleprocedurecall.spv.dis", 1, PASS},
                // {"simplereturn.spv.dis", 1, PASS},
                // {"test_address_of_bug.spv.dis", 1, PASS},
                // {"test_float_neq.spv.dis", 1, PASS},
                // {"test_structs/store_array_element.spv.dis", 1, PASS},
                // {"test_structs/store_element.spv.dis", 1, PASS},
                // {"test_structs/store_struct_element.spv.dis", 1, PASS},
                // {"unusedreturn.spv.dis", 1, PASS},
                // {"vectortests/addressofvector.spv.dis", 1, PASS},
                // {"vectortests/double2simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/double4simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/float2simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/float4simpleaccess.spv.dis", 1, PASS},
                // {"vectortests/vectorsplat.spv.dis", 1, PASS},
                // {"vectortests/vectorswizzle.spv.dis", 1, PASS},
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
                Configuration.builder().build(),
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
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }
}
