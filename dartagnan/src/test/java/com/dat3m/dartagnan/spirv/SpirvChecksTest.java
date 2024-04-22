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
                // {"gpu-verify/atomics/definitions_atom_int.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/displaced.spv.dis", 1, PASS},
                // {"gpu-verify/atomics/pointers.spv.dis", 1, PASS},

                // TODO: Implement unrolling for control barriers
                // {"gpu-verify/barrier_intervals/test3.spv.dis", 2, UNKNOWN},
                // {"gpu-verify/barrier_intervals/test4.spv.dis", 2, UNKNOWN},

                // TODO: Support missing semantics
                {"gpu-verify/benign_race_tests/fail/writeafterread_addition.spv.dis", 1, PASS},
                // {"gpu-verify/benign_race_tests/fail/writetiddiv64_offbyone.spv.dis", 1, PASS},
                // {"gpu-verify/benign_race_tests/fail/writewritearray_adversarial.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/bad_read_then_write.spv.dis", 1, PASS},
                // {"gpu-verify/inter_group_and_barrier_flag_tests/fail/bad_write_then_read.spv.dis", 1, PASS},
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

                // Auto-generated tests from gpuverify
                {"gpu-verify-auto/atomics/histo/histo.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/refined_atomic_abstraction/intra_local_counters/intra_local_counters.spv.dis", 1, PASS},
                // {"gpu-verify-auto/casttofloat/casttofloat.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_part_load_store/store_int_and_short/store_int_and_short.spv.dis", 1, PASS},
                // {"gpu-verify-auto/k-induction/amazingreduction/amazingreduction.spv.dis", 1, PASS},
                // {"gpu-verify-auto/floatrelationalop/floatrelationalop.spv.dis", 1, PASS},
                {"gpu-verify-auto/warpsync/intragroup_scan/intragroup_scan.spv.dis", 1, PASS},
                // {"gpu-verify-auto/rightshiftequals/rightshiftequals.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/simple_array/simple_array.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/simple_array_fail_var/simple_array_fail_var.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/simple_array_fail_upper/simple_array_fail_upper.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/needs_source_location_requires/needs_source_location_requires.spv.dis", 1, PASS},
                // {"gpu-verify-auto/bitnot/bitnot.spv.dis", 1, PASS},
                // {"gpu-verify-auto/bitxor/bitxor.spv.dis", 1, PASS},
                // {"gpu-verify-auto/transitiveclosuresimplified/transitiveclosuresimplified.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_mod_invariants/local_direct/local_direct.spv.dis", 1, UNKNOWN},
                {"gpu-verify-auto/array_bounds_tests/realign_simple_fail/realign_simple_fail.spv.dis", 1, PASS},
                // {"gpu-verify-auto/warpsync/shuffle/shuffle.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pow2/64bit_relational/64bit_relational.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/vectorswizzle/vectorswizzle.spv.dis", 1, PASS},
                // {"gpu-verify-auto/barrier_intervals/test4/test4.spv.dis", 2, UNKNOWN},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/read_then_write/read_then_write.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/negative_index_multi_dim_fail/negative_index_multi_dim_fail.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_global_id_inference/test_global_id_inference.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/displaced/displaced.spv.dis", 1, PASS},
                // {"gpu-verify-auto/fail_equality_and_adversarial/fail_equality_and_adversarial.spv.dis", 1, PASS},
                {"gpu-verify-auto/basicglobalarray/basicglobalarray.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_mod_invariants/local_reduce_strength/local_reduce_strength.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/barrier_divergence/pass/pass.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/multi_dim_array_fail_upper/multi_dim_array_fail_upper.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/test_derived_from_binomial_opts/test_derived_from_binomial_opts.spv.dis", 1, PASS},
                // {"gpu-verify-auto/null_pointers/store_to_null_and_non_null/store_to_null_and_non_null.spv.dis", 1, PASS},
                // {"gpu-verify-auto/leftshiftequals/leftshiftequals.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/multi_dim_array/multi_dim_array.spv.dis", 1, PASS},
                // {"gpu-verify-auto/multidimarrays/test3/test3.spv.dis", 1, PASS},
                // {"gpu-verify-auto/annotation_tests/test_axiom/test_axiom.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/float4simpleaccess/float4simpleaccess.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/negative_index_multi_dim/negative_index_multi_dim.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/param_addressof/param_addressof.spv.dis", 1, PASS},
                // {"gpu-verify-auto/return_tests/id_dependent_return/id_dependent_return.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_structs/use_array_element/use_array_element.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_2d_global_index_inference/test_2d_global_index_inference.spv.dis", 1, UNKNOWN},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/global_barrier/global_barrier.spv.dis", 1, PASS},
                // {"gpu-verify-auto/return_tests/multiloop_return_simplified/multiloop_return_simplified.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/test_opencl_local_param/test_opencl_local_param.spv.dis", 1, PASS},
                {"gpu-verify-auto/warpsync/scan_warp/scan_warp.spv.dis", 1, PASS},
                {"gpu-verify-auto/localarrayaccess/localarrayaccess.spv.dis", 1, PASS},
                // {"gpu-verify-auto/bitor/bitor.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_structs/store_array_element/store_array_element.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/definitions_int/definitions_int.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/pass/misc15/misc15.spv.dis", 1, PASS},
                // {"gpu-verify-auto/multiplelocals2/multiplelocals2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/pass/misc3/misc3.spv.dis", 1, PASS},

                // barrier inside loop
                // {"gpu-verify-auto/sourcelocation_tests/barrier_divergence/fail/fail.spv.dis", 1, PASS},

                // {"gpu-verify-auto/unusedreturn/unusedreturn.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/pointerarith/pointerarith.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_2d_local_index_inference/test_2d_local_index_inference.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/float2simpleaccess/float2simpleaccess.spv.dis", 1, PASS},
                {"gpu-verify-auto/barrier_intervals/test1/test1.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/refined_atomic_abstraction/bad_local_counters/bad_local_counters.spv.dis", 1, PASS},
                // {"gpu-verify-auto/derivedfrombinomialoptions2/derivedfrombinomialoptions2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/modifyparam/modifyparam.spv.dis", 1, PASS},
                // {"gpu-verify-auto/derived_from_uniformity_analysis_bug/derived_from_uniformity_analysis_bug.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/counter/counter.spv.dis", 1, PASS},
                // {"gpu-verify-auto/barrier_intervals/test3/test3.spv.dis", 2, UNKNOWN},
                // {"gpu-verify-auto/vectortests/addressofvector/addressofvector.spv.dis", 1, PASS},
                // {"gpu-verify-auto/predicated_undef/predicated_undef.spv.dis", 1, PASS},
                {"gpu-verify-auto/basicbarrier/basicbarrier.spv.dis", 1, PASS},
                // {"gpu-verify-auto/null_pointers/atomic_null/atomic_null.spv.dis", 1, PASS},
                // {"gpu-verify-auto/return_tests/simple_return/simple_return.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_structs/store_struct_element/store_struct_element.spv.dis", 1, PASS},
                // {"gpu-verify-auto/bitand/bitand.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_local_id_inference/test_local_id_inference.spv.dis", 1, PASS},
                // {"gpu-verify-auto/reducedstrengthnonloopbug/reducedstrengthnonloopbug.spv.dis", 1, PASS},
                // {"gpu-verify-auto/simplereturn/simplereturn.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/mismatched_types/int_add_with_float/int_add_with_float.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_address_of_bug/test_address_of_bug.spv.dis", 1, PASS},
                {"gpu-verify-auto/pointertests/test_return_pointer/test_return_pointer.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/realign_simple/realign_simple.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_structs/use_struct_element/use_struct_element.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/definitions_long/definitions_long.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/pass/read_read/read_read.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/vectorsplat/vectorsplat.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/private_array/private_array.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/write_then_read/write_then_read.spv.dis", 1, PASS},
                // {"gpu-verify-auto/null_statement/null_statement.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/pass/misc13/misc13.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_for_ssa_bug/test_for_ssa_bug.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/definitions_atom_int/definitions_atom_int.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/pass/no_race/no_race.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_2d_local_index_inference_2/test_2d_local_index_inference_2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/multidimarrays/test4/test4.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/pass/misc2/misc2.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/equality_fail/equality_fail.spv.dis", 1, PASS},
                // {"gpu-verify-auto/addressofinit/addressofinit.spv.dis", 1, PASS},
                // {"gpu-verify-auto/null_pointers/load_from_null/load_from_null.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/array_in_array_2/array_in_array_2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/simpleparampassing/simpleparampassing.spv.dis", 1, PASS},
                // {"gpu-verify-auto/notunaryoptest/notunaryoptest.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/test_pass_value_from_array/test_pass_value_from_array.spv.dis", 1, PASS},
                // {"gpu-verify-auto/conditional_int_test/conditional_int_test.spv.dis", 1, PASS},
                // {"gpu-verify-auto/alignment/int3int4/int3int4.spv.dis", 1, PASS},
                // {"gpu-verify-auto/basic1/basic1.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/needs_source_location_ensures/needs_source_location_ensures.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_mod_invariants/global_reduce_strength/global_reduce_strength.spv.dis", 4, PASS},
                {"gpu-verify-auto/test_structs/store_element/store_element.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pow2/64bit_loopcounter/64bit_loopcounter.spv.dis", 1, PASS},
                // {"gpu-verify-auto/reducedstrength_generalised/reducedstrength_generalised.spv.dis", 1, PASS},
                {"gpu-verify-auto/barrier_intervals/test2/test2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/skeletonbinomialoptions/skeletonbinomialoptions.spv.dis", 2, UNKNOWN},
                // {"gpu-verify-auto/return_tests/multiloop_return/multiloop_return.spv.dis", 1, PASS},
                // {"gpu-verify-auto/pointertests/test_opencl_local_array/test_opencl_local_array.spv.dis", 1, PASS},
                // Fails check checkRelIsSem for a barrier with semantics 0x8 (rel_acq, no storage class semantics)
                // {"gpu-verify-auto/mem_fence/mem_fence.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/double4simpleaccess/double4simpleaccess.spv.dis", 1, PASS},
                // {"gpu-verify-auto/vectortests/double2simpleaccess/double2simpleaccess.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/pass/misc12/misc12.spv.dis", 2, UNKNOWN},
                // {"gpu-verify-auto/vectortests/int3arrayaccess/int3arrayaccess.spv.dis", 1, PASS},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/local_barrier_flag/local_barrier_flag.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/pass/misc4/misc4.spv.dis", 1, PASS},
                // {"gpu-verify-auto/multiplelocals/multiplelocals.spv.dis", 1, PASS},
                // {"gpu-verify-auto/multidimarrays/test1/test1.spv.dis", 1, PASS},
                // {"gpu-verify-auto/bool_bv_test/bool_bv_test.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/simple_array_fail_lower/simple_array_fail_lower.spv.dis", 1, PASS},
                // {"gpu-verify-auto/simpleprocedurecall/simpleprocedurecall.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/mismatched_types/int_add_with_short/int_add_with_short.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_structs/use_element/use_element.spv.dis", 1, PASS},
                // {"gpu-verify-auto/induction_variable/induction_variable.spv.dis", 1, PASS},
                // {"gpu-verify-auto/float_constant_test2/float_constant_test2.spv.dis", 1, PASS},
                // {"gpu-verify-auto/barrierconditionalkernelparam/barrierconditionalkernelparam.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_float_neq/test_float_neq.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/sync_within_group/sync_within_group.spv.dis", 1, PASS},

                // Race
                {"gpu-verify-auto/sourcelocation_tests/race_with_loop/race_with_loop.spv.dis", 1, UNKNOWN},
                {"gpu-verify-auto/sourcelocation_tests/races/fail/write_write/loop/loop.spv.dis", 1, UNKNOWN},
                {"gpu-verify-auto/divergence/race_and_divergence/race_and_divergence.spv.dis", 1, PASS},
                // {"gpu-verify-auto/shared_int/shared_int.spv.dis", 1, FAIL},
                {"gpu-verify-auto/misc/fail/struct_member_race/struct_member_race.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/fail/read_write/read_write.spv.dis", 1, PASS},
                // {"gpu-verify-auto/benign_race_tests/fail/writewritearray_adversarial/writewritearray_adversarial.spv.dis", 1, PASS},
                // {"gpu-verify-auto/sourcelocation_tests/races/fail/write_write/elem_width_16/elem_width_16.spv.dis", 1, PASS},
                {"gpu-verify-auto/multidimarrays/test5/test5.spv.dis", 1, PASS},
                // {"gpu-verify-auto/warpsync/broken_shuffle/broken_shuffle.spv.dis", 1, PASS},
                {"gpu-verify-auto/null_pointers/null_pointer_assignment_unequal/null_pointer_assignment_unequal.spv.dis", 1, PASS},
                {"gpu-verify-auto/report_global_id/test2/test2.spv.dis", 1, PASS},
                {"gpu-verify-auto/null_pointers/null_pointer_assignment_equal/null_pointer_assignment_equal.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/4d_array_race/4d_array_race.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/sync_within_group_wrong_flag/sync_within_group_wrong_flag.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/atomic_read_race/atomic_read_race.spv.dis", 1, PASS},
                {"gpu-verify-auto/report_global_id/test1/test1.spv.dis", 1, PASS},
                // {"gpu-verify-auto/async_work_group_copy/fail/test13/test13.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/fail/2d_array_race/2d_array_race.spv.dis", 1, PASS},
                {"gpu-verify-auto/no_log/pass/pass.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/missing_global_barrier_flag/missing_global_barrier_flag.spv.dis", 1, PASS},
                {"gpu-verify-auto/benign_race_tests/fail/writezero_nobenign/writezero_nobenign.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/4d_array_with_casting/4d_array_with_casting.spv.dis", 1, PASS},
                // {"gpu-verify-auto/benign_race_tests/pass/writeinloop/writeinloop.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races_from_indirect_calls/races_from_indirect_calls.spv.dis", 1, PASS},
                {"gpu-verify-auto/benign_race_tests/pass/writezero/writezero.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/bad_write_then_read/bad_write_then_read.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/pass/read_read/read_read.spv.dis", 1, PASS},
                {"gpu-verify-auto/divergence/race_no_divergence/race_no_divergence.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/array_in_array/array_in_array.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/miscfail8/miscfail8.spv.dis", 1, PASS},
                // {"gpu-verify-auto/benign_race_tests/pass/writeafterread/writeafterread.spv.dis", 1, PASS},
                // {"gpu-verify-auto/test_line_number_problem/test_line_number_problem.spv.dis", 1, PASS},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/missing_local_barrier_flag/missing_local_barrier_flag.spv.dis", 1, PASS},
                // Fails check checkRelIsSem for a barrier with semantics 0x8 (rel_acq, no storage class semantics)
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/no_barrier_flags/no_barrier_flags.spv.dis", 1, PASS},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/pass_due_to_intra_group_flag/pass_due_to_intra_group_flag.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/pass/no_race/no_race.spv.dis", 1, PASS},
                // {"gpu-verify-auto/atomics/pointers/pointers.spv.dis", 1, PASS},
                // {"gpu-verify-auto/benign_race_tests/fail/writetiddiv64_offbyone/writetiddiv64_offbyone.spv.dis", 1, PASS},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/pass/local_id_benign_write_write/local_id_benign_write_write.spv.dis", 1, PASS},
                {"gpu-verify-auto/test_for_benign_read_write_bug/test_for_benign_read_write_bug.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/race_from_call_in_loop/race_from_call_in_loop.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/miscfail1/miscfail1.spv.dis", 1, PASS},
                {"gpu-verify-auto/atomics/forloop/forloop.spv.dis", 1, UNKNOWN},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/sync/sync.spv.dis", 1, PASS},
                {"gpu-verify-auto/array_bounds_tests/array_in_array_param/array_in_array_param.spv.dis", 1, PASS},
                // {"gpu-verify-auto/alignment/race_location/race_location.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/race_from_call/race_from_call.spv.dis", 1, PASS},
                // {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/bad_read_then_write/bad_read_then_write.spv.dis", 1, PASS},
                // {"gpu-verify-auto/misc/fail/miscfail10/miscfail10.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/fail/write_write/normal/normal.spv.dis", 1, PASS},
                {"gpu-verify-auto/sourcelocation_tests/races/fail/write_read/write_read.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/miscfail3/miscfail3.spv.dis", 1, PASS},
                {"gpu-verify-auto/misc/fail/4d_array_of_structs_race/4d_array_of_structs_race.spv.dis", 1, PASS},
                {"gpu-verify-auto/benign_race_tests/fail/writeafterread_otherval/writeafterread_otherval.spv.dis", 1, PASS},
                {"gpu-verify-auto/inter_group_and_barrier_flag_tests/fail/local_id/local_id.spv.dis", 1, PASS},
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
