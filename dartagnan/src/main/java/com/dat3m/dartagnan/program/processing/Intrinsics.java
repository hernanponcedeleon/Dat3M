package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.google.common.collect.ImmutableList;

import java.util.List;

public class Intrinsics {

    public record Info(
            String name,
            List<String> variants,
            boolean writesMemory,
            boolean readsMemory,
            boolean alwaysReturns
    ) {
        public Info(String name, boolean writesMemory, boolean readsMemory, boolean alwaysReturns) {
            this(name, List.of(name), writesMemory, readsMemory, alwaysReturns);
        }
    }

    private static final List<Info> INTRINSICS = ImmutableList.copyOf(List.of(
            // --------------------------- pthread threading ---------------------------
            new Info("pthread_create", true, false, true),
            new Info("pthread_exit", false, false, false),
            new Info("pthread_join",
                    List.of("pthread_join", "__pthread_join", "\"\\01_pthread_join\""),
                    false, true, false),
            new Info("pthread_exit", false, false, true),
            // --------------------------- pthread mutex ---------------------------
            new Info("pthread_mutex_init", true, false, true),
            new Info("pthread_mutex_lock", true, true, false),
            new Info("pthread_mutex_unlock", true, false, true),
            new Info("pthread_mutex_destroy", true, false, true),
            // --------------------------- SVCOMP ---------------------------
            new Info("__VERIFIER_atomic_begin", false, false, true),
            new Info("__VERIFIER_atomic_end", false, false, true),
            // --------------------------- __VERIFIER ---------------------------
            new Info("__VERIFIER_loop_begin", false, false, true),
                        new Info("__VERIFIER_loop_bound", false, false, true),
            new Info("__VERIFIER_spin_start", false, false, true),
            new Info("__VERIFIER_spin_end", false, false, true),
            new Info("__VERIFIER_assume",false, false, true),
            new Info("__VERIFIER_assert",false, false, false),
            new Info("__VERIFIER_nondet_",
                    List.of("__VERIFIER_nondet_bool",
                    "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                    "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                    "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                    "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar"),
                    false, false, true
            ),
            // --------------------------- LLVM ---------------------------
            new Info("llvm.minmax",
                    List.of("llvm.smax.i32", "llvm.umax.i32", "llvm.smin.i32", "llvm.umin.i32"),
                    false, false, true),
            // --------------------------- LKMM ---------------------------
            new Info("__LKMM_LOAD", false, true, true),
            new Info("__LKMM_STORE", true, false, true),
            new Info("__LKMM_XCHG", true, true, true),
            new Info("__LKMM_CMPXCHG", true, true, true),
            new Info("__LKMM_ATOMIC_FETCH_OP", true, true, true),
            new Info("__LKMM_ATOMIC_OP", true, true, true),
            new Info("__LKMM_ATOMIC_OP_RETURN", true, true, true),
            new Info("__LKMM_SPIN_LOCK", true, true, false),
            new Info("__LKMM_SPIN_UNLOCK", true, false, true),
            new Info("__LKMM_FENCE", false, false, false),
            // --------------------------- Misc ---------------------------
            new Info("malloc", false, false, true),
            new Info("free", true, false, true),
            new Info("__assert_fail", List.of("__assert_fail", "reach_error", "__assert_rtn"),
                    false, false, false),
            new Info("exit", false, false, false),
            new Info("abort", false, false, false),
            new Info("printf", false, false, true),
            new Info("puts", false, false, true)
    ));


    public static ProgramProcessor MARK_INTRINSICS = program -> {
        for (Function func : program.getFunctions()) {
            if (!func.hasBody()) {
                final String funcName = func.getName();
                final Info intrinsicsInfo = INTRINSICS.stream()
                        .filter(info -> info.variants.contains(funcName))
                        .findFirst()
                        .orElseThrow(() -> new UnsupportedOperationException("Unknown intrinsic function " + funcName ));
                func.setIntrinsicInfo(intrinsicsInfo);
            }
        }
    };
}
