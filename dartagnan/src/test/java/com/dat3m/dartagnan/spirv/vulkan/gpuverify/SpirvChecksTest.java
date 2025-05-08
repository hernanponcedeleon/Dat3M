package com.dat3m.dartagnan.spirv.vulkan.gpuverify;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
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
public class SpirvChecksTest {

    private final String modelPath = getRootPath("cat/spirv-check.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public SpirvChecksTest(String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("spirv/vulkan/gpuverify/" + file);
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"atomics/atomic_read_race.spvasm", 1, PASS},
                {"atomics/equality_fail.spvasm", 1, PASS},
                {"atomics/forloop.spvasm", 2, UNKNOWN},
                {"atomics/histo.spvasm", 1, PASS},
                {"barrier_intervals/test1.spvasm", 1, PASS},
                {"barrier_intervals/test3.spvasm", 2, UNKNOWN},
                {"barrier_intervals/test4.spvasm", 2, UNKNOWN},
                {"basicbarrier.spvasm", 1, PASS},
                {"basicglobalarray.spvasm", 1, PASS},
                {"benign_race_tests/fail/writeafterread_addition.spvasm", 1, PASS},
                {"benign_race_tests/fail/writeafterread_otherval.spvasm", 1, PASS},
                {"benign_race_tests/fail/writezero_nobenign.spvasm", 1, PASS},
                {"benign_race_tests/pass/writezero.spvasm", 1, PASS},
                {"checkarrays/pass/specifyall.spvasm", 1, PASS},
                {"divergence/race_and_divergence.spvasm", 1, PASS},
                {"divergence/race_no_divergence.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/local_id.spvasm", 1, PASS},

                // Changed illegal barrier semantics 0x8 (acqrel) to 0x108 (acqrel+semWg)
                {"inter_group_and_barrier_flag_tests/fail/no_barrier_flags.spvasm", 1, PASS},

                {"inter_group_and_barrier_flag_tests/fail/sync.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/pass_due_to_intra_group_flag.spvasm", 1, PASS},
                {"localarrayaccess.spvasm", 1, PASS},

                // Changed illegal fence semantics:
                //  0x2 (acq) -> 0x102 (acq+semWg)
                //  0x4 (rel) -> 0x104 (rel+semWg)
                //  0x8 (acqrel) -> 0x108 (acqrel+semWg)
                {"mem_fence.spvasm", 1, PASS},

                {"misc/fail/miscfail1.spvasm", 1, PASS},
                {"misc/fail/miscfail3.spvasm", 1, PASS},
                {"misc/fail/struct_member_race.spvasm", 1, PASS},
                {"misc/pass/misc2.spvasm", 1, PASS},
                {"misc/pass/misc12.spvasm", 3, PASS},
                {"misc/pass/misc13.spvasm", 1, PASS},
                {"multidimarrays/test5.spvasm", 1, PASS},
                {"no_log/pass.spvasm", 1, PASS},
                {"null_pointers/null_pointer_assignment_equal.spvasm", 1, PASS},
                {"null_pointers/null_pointer_assignment_unequal.spvasm", 1, PASS},
                {"null_pointers/null_pointer_greater.spvasm", 1, PASS},
                {"pointertests/test_return_pointer.spvasm", 1, PASS},
                {"report_global_id/test1.spvasm", 1, PASS},
                {"report_global_id/test2.spvasm", 1, PASS},
                {"skeletonbinomialoptions.spvasm", 2, UNKNOWN},
                {"sourcelocation_tests/barrier_divergence/pass.spvasm", 1, PASS},
                {"sourcelocation_tests/needs_source_location_ensures.spvasm", 1, PASS},
                {"sourcelocation_tests/needs_source_location_requires.spvasm", 1, PASS},
                {"sourcelocation_tests/race_with_loop.spvasm", 2, UNKNOWN},
                {"sourcelocation_tests/races/fail/read_write.spvasm", 1, PASS},
                {"sourcelocation_tests/races/fail/write_read.spvasm", 1, PASS},
                {"sourcelocation_tests/races/fail/write_write/loop.spvasm", 2, UNKNOWN},
                {"sourcelocation_tests/races/fail/write_write/normal.spvasm", 1, PASS},
                {"sourcelocation_tests/races/pass/no_race.spvasm", 1, PASS},
                {"sourcelocation_tests/races/pass/read_read.spvasm", 1, PASS},
                {"test_2d_global_index_inference.spvasm", 2, UNKNOWN},
                {"test_2d_local_index_inference_2.spvasm", 1, PASS},
                {"test_for_benign_read_write_bug.spvasm", 1, PASS},
                {"test_local_id_inference.spvasm", 1, PASS},
                {"test_mod_invariants/global_reduce_strength.spvasm", 2, UNKNOWN},
                {"test_mod_invariants/local_direct.spvasm", 2, UNKNOWN},
                {"test_part_load_store/store_int_and_short.spvasm", 1, PASS},
                {"test_structs/use_array_element.spvasm", 1, PASS},
                {"test_structs/use_element.spvasm", 1, PASS},
                {"test_structs/use_struct_element.spvasm", 1, PASS},

                {"saturate/sadd.spvasm", 1, PASS},
                {"saturate/ssub.spvasm", 1, PASS},

                {"atomics/refined_atomic_abstraction/bad_local_counters.spvasm", 1, PASS},
                {"atomics/refined_atomic_abstraction/intra_local_counters.spvasm", 1, PASS},

                {"atomics/counter.spvasm", 1, PASS},

                {"barrier_intervals/test2.spvasm", 1, PASS},
                {"sourcelocation_tests/barrier_divergence/fail.spvasm", 1, PASS},

                {"global_size/local_size_fail_divide_global_size.spvasm", 1, PASS},
                {"global_size/mismatch_dims.spvasm", 1, PASS},
                {"global_size/num_groups_and_global_size.spvasm", 1, PASS},

                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag_2.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag_3.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag_2.spvasm", 1, PASS},
                {"inter_group_and_barrier_flag_tests/pass/local_barrier_flag_3.spvasm", 1, PASS},

                // Unsupported large array (4K elements) leading to OOM
                // {"misc/fail/2d_array_race.spvasm", 1, PASS},

                // Unsupported null as a pointer
                // {"null_pointers/atomic_null.spvasm", 1, PASS},

                // Unsupported cuda warps
                // {"warpsync/intragroup_scan.spvasm", 1, PASS},
                // {"warpsync/scan_warp.spvasm", 1, PASS},

                // Unsupported non-constant tags
                // {"inter_group_and_barrier_flag_tests/fail/bad_read_then_write.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/bad_write_then_read.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/read_then_write.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/write_then_read.spvasm", 1, PASS},

                // Unsupported vector registers
                // {"annotation_tests/test_axiom.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test13.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test7.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test8.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test9.spvasm", 1, PASS},
                // {"induction_variable.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/missing_global_barrier_flag.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/fail/sync_within_group_wrong_flag.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/global_barrier.spvasm", 1, PASS},
                // {"inter_group_and_barrier_flag_tests/pass/sync_within_group.spvasm", 1, PASS},
                // {"k-induction/amazingreduction.spvasm", 1, PASS},
                // {"reducedstrength_generalised.spvasm", 1, PASS},
                // {"test_2d_local_index_inference.spvasm", 1, PASS},
                // {"test_global_id_inference.spvasm", 1, PASS},
                // {"test_line_number_problem.spvasm", 1, PASS},
                // {"test_mod_invariants/local_reduce_strength.spvasm", 1, PASS},

                // Unsupported control flow
                {"test_for_ssa_bug.spvasm", 8, PASS},
                // {"transitiveclosuresimplified.spvasm", 1, PASS},

                // Unsupported spir-v ops
                // {"alignment/int3int4.spvasm", 1, PASS},
                // {"alignment/race_location.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test1.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test10.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test14.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test15.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test16.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test17.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test18.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test2.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test4.spvasm", 1, PASS},
                // {"async_work_group_copy/fail/test5.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test1.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test2.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test3.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test4.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test5.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test6.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test7.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test8.spvasm", 1, PASS},
                // {"async_work_group_copy/pass/test9.spvasm", 1, PASS},
                // {"atomics/definitions_atom_int.spvasm", 1, PASS},
                // {"atomics/definitions_float.spvasm", 1, PASS},
                // {"atomics/definitions_int.spvasm", 1, PASS},
                // {"atomics/definitions_long.spvasm", 1, PASS},
                // {"atomics/displaced.spvasm", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_float.spvasm", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_long.spvasm", 1, PASS},
                // {"atomics/mismatched_types/int_add_with_short.spvasm", 1, PASS},
                // {"atomics/pointers.spvasm", 1, PASS},
                // {"atomics/refined_atomic_abstraction/many_accesses.spvasm", 1, PASS},
                // {"atomics/refined_atomic_abstraction/one_access.spvasm", 1, PASS},
                // {"atomics/refined_atomic_abstraction/predication.spvasm", 1, PASS},
                // {"barrierconditionalkernelparam.spvasm", 1, PASS},
                // {"benign_race_tests/fail/writetiddiv64_offbyone.spvasm", 1, PASS},
                // {"benign_race_tests/fail/writewritearray_adversarial.spvasm", 1, PASS},
                // {"benign_race_tests/pass/writeinloop.spvasm", 1, PASS},
                // {"ceil.spvasm", 1, PASS},
                // {"constantnotparam.spvasm", 1, PASS},
                // {"derivedfrombinomialoptions.spvasm", 1, PASS},
                // {"floatcastrequired.spvasm", 1, PASS},
                // {"get_global_id.spvasm", 1, PASS},
                // {"globalarray/fail.spvasm", 1, PASS},
                // {"globalarray/pass.spvasm", 1, PASS},
                // {"imagetests/fail2dimagecopy.spvasm", 1, PASS},
                // {"imagetests/test2dimagecopy.spvasm", 1, PASS},
                // {"imagetests/testsampler.spvasm", 1, PASS},
                // {"imagetests/testsampler2.spvasm", 1, PASS},
                // {"misc/fail/4d_array_of_vectors_race.spvasm", 1, PASS},
                // {"misc/fail/miscfail9.spvasm", 1, PASS},
                // {"misc/fail/vector_element_race.spvasm", 1, PASS},
                // {"misc/pass/misc15.spvasm", 1, PASS},
                // {"misc/pass/misc16.spvasm", 1, PASS},
                // {"misc/pass/misc7.spvasm", 1, PASS},
                // {"misc/pass/misc8.spvasm", 1, PASS},
                // {"noraceduetoreturn.spvasm", 1, PASS},
                // {"null_pointers/store_to_null_and_non_null.spvasm", 1, PASS},
                // {"pointeranalysistests/manyprocedures.spvasm", 1, PASS},
                // {"pointeranalysistests/manyproceduresinlined.spvasm", 1, PASS},
                // {"pointeranalysistests/testbasicaliasing.spvasm", 1, PASS},
                // {"pointeranalysistests/testbasicaliasing2.spvasm", 1, PASS},
                // {"pointeranalysistests/testbasicpointerarithmetic.spvasm", 1, PASS},
                // {"pointeranalysistests/testbasicpointerarithmetic2.spvasm", 1, PASS},
                // {"pointeranalysistests/testinterprocedural.spvasm", 1, PASS},
                // {"pointertests/test_copy_between_memory_spaces2.spvasm", 1, PASS},
                // {"pow2/64bit_loopcounter.spvasm", 1, PASS},
                // {"pow2/64bit_relational.spvasm", 1, PASS},
                // {"saturate/uadd.spvasm", 1, PASS},
                // {"saturate/usub.spvasm", 1, PASS},
                // {"shuffle/shuffle.spvasm", 1, PASS},
                // {"simplebinomialoptions.spvasm", 1, PASS},
                // {"sourcelocation_tests/races/fail/write_write/elem_width_16.spvasm", 1, PASS},
                // {"ternarytest.spvasm", 1, PASS},
                // {"ternarytest2.spvasm", 1, PASS},
                // {"test_for_get_group_id.spvasm", 1, PASS},
                // {"vectortests/float4arrayaccess.spvasm", 1, PASS},
                // {"vectortests/int3arrayaccess.spvasm", 1, PASS},
                // {"vectortests/test_paren.spvasm", 1, PASS},
                // {"warpsync/2d.spvasm", 1, PASS},
                // {"warpsync/broken_shuffle.spvasm", 1, PASS},
                // {"warpsync/shuffle.spvasm", 1, PASS},

                // Compiler eliminated reads of unused value
                // {"misc/fail/miscfail8.spvasm", 1, PASS},
                // {"pointertests/test_copy_between_memory_spaces.spvasm", 1, PASS},
                // {"sourcelocation_tests/race_from_call.spvasm", 1, PASS},
                // {"sourcelocation_tests/race_from_call_in_loop.spvasm", 1, PASS},
                // {"sourcelocation_tests/races_from_indirect_calls.spvasm", 1, PASS},

                // Compiler eliminated the whole main function
                // {"addressofinit.spvasm", 1, PASS},
                // {"array_bounds_tests/array_in_array.spvasm", 1, PASS},
                // {"array_bounds_tests/array_in_array_2.spvasm", 1, PASS},
                // {"array_bounds_tests/array_in_array_param.spvasm", 1, PASS},
                // {"array_bounds_tests/multi_dim_array.spvasm", 1, PASS},
                // {"array_bounds_tests/multi_dim_array_fail_upper.spvasm", 1, PASS},
                // {"array_bounds_tests/negative_index_multi_dim.spvasm", 1, PASS},
                // {"array_bounds_tests/negative_index_multi_dim_fail.spvasm", 1, PASS},
                // {"array_bounds_tests/private_array.spvasm", 1, PASS},
                // {"array_bounds_tests/realign_simple.spvasm", 1, PASS},
                // {"array_bounds_tests/realign_simple_fail.spvasm", 1, PASS},
                // {"array_bounds_tests/simple_array.spvasm", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_lower.spvasm", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_upper.spvasm", 1, PASS},
                // {"array_bounds_tests/simple_array_fail_var.spvasm", 1, PASS},
                // {"basic1.spvasm", 1, PASS},
                // {"benign_race_tests/pass/writeafterread.spvasm", 1, PASS},
                // {"bitand.spvasm", 1, PASS},
                // {"bitnot.spvasm", 1, PASS},
                // {"bitor.spvasm", 1, PASS},
                // {"bitxor.spvasm", 1, PASS},
                // {"bool_bv_test.spvasm", 1, PASS},
                // {"casttofloat.spvasm", 1, PASS},
                // {"checkarrays/fail/arraydoesnotexist1.spvasm", 1, PASS},
                // {"checkarrays/fail/arraydoesnotexist2.spvasm", 1, PASS},
                // {"conditional_int_test.spvasm", 1, PASS},
                // {"derived_from_uniformity_analysis_bug.spvasm", 1, PASS},
                // {"derivedfrombinomialoptions2.spvasm", 1, PASS},
                // {"fail_equality_and_adversarial.spvasm", 1, PASS},
                // {"float_constant_test2.spvasm", 1, PASS},
                // {"floatrelationalop.spvasm", 1, PASS},
                // {"leftshiftequals.spvasm", 1, PASS},
                // {"localmultidimarraydecl.spvasm", 1, PASS},
                // {"misc/fail/4d_array_of_structs_race.spvasm", 1, PASS},
                // {"misc/fail/4d_array_race.spvasm", 1, PASS},
                // {"misc/fail/4d_array_with_casting.spvasm", 1, PASS},
                // {"misc/fail/miscfail10.spvasm", 1, PASS},
                // {"misc/pass/misc3.spvasm", 1, PASS},
                // {"misc/pass/misc4.spvasm", 1, PASS},
                // {"modifyparam.spvasm", 1, PASS},
                // {"multidimarrays/test1.spvasm", 1, PASS},
                // {"multidimarrays/test2.spvasm", 1, PASS},
                // {"multidimarrays/test3.spvasm", 1, PASS},
                // {"multidimarrays/test4.spvasm", 1, PASS},
                // {"multiplelocals.spvasm", 1, PASS},
                // {"multiplelocals2.spvasm", 1, PASS},
                // {"notunaryoptest.spvasm", 1, PASS},
                // {"null_pointers/load_from_null.spvasm", 1, PASS},
                // {"null_statement.spvasm", 1, PASS},
                // {"pointertests/param_addressof.spvasm", 1, PASS},
                // {"pointertests/pointerarith.spvasm", 1, PASS},
                // {"pointertests/test_derived_from_binomial_opts.spvasm", 1, PASS},
                // {"pointertests/test_opencl_local_array.spvasm", 1, PASS},
                // {"pointertests/test_opencl_local_param.spvasm", 1, PASS},
                // {"pointertests/test_pass_value_from_array.spvasm", 1, PASS},
                // {"predicated_undef.spvasm", 1, PASS},
                // {"reducedstrengthnonloopbug.spvasm", 1, PASS},
                // {"return_tests/id_dependent_return.spvasm", 1, PASS},
                // {"return_tests/multiloop_return.spvasm", 1, PASS},
                // {"return_tests/multiloop_return_simplified.spvasm", 1, PASS},
                // {"return_tests/simple_return.spvasm", 1, PASS},
                // {"rightshiftequals.spvasm", 1, PASS},
                // {"shared_int.spvasm", 1, PASS},
                // {"simpleparampassing.spvasm", 1, PASS},
                // {"simpleprocedurecall.spvasm", 1, PASS},
                // {"simplereturn.spvasm", 1, PASS},
                // {"test_address_of_bug.spvasm", 1, PASS},
                // {"test_float_neq.spvasm", 1, PASS},
                // {"test_structs/store_array_element.spvasm", 1, PASS},
                // {"test_structs/store_element.spvasm", 1, PASS},
                // {"test_structs/store_struct_element.spvasm", 1, PASS},
                // {"unusedreturn.spvasm", 1, PASS},
                // {"vectortests/addressofvector.spvasm", 1, PASS},
                // {"vectortests/double2simpleaccess.spvasm", 1, PASS},
                // {"vectortests/double4simpleaccess.spvasm", 1, PASS},
                // {"vectortests/float2simpleaccess.spvasm", 1, PASS},
                // {"vectortests/float4simpleaccess.spvasm", 1, PASS},
                // {"vectortests/vectorsplat.spvasm", 1, PASS},
                // {"vectortests/vectorswizzle.spvasm", 1, PASS},
        });
    }

    @Test
    public void test() throws Exception {
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
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(CAT_SPEC));
    }
}
