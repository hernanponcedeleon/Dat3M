package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.google.common.collect.ImmutableList;

import java.util.List;
import java.util.function.BiPredicate;

public class Intrinsics {

    public record Info(
            String groupName, // Can end with a "*", in which case the variants are treated as prefixes
            List<String> variants,
            boolean writesMemory,
            boolean readsMemory,
            boolean alwaysReturns
    ) {
        public Info(String name, boolean writesMemory, boolean readsMemory, boolean alwaysReturns) {
            this(name, List.of(name), writesMemory, readsMemory, alwaysReturns);
        }

        private boolean matches(String funcName) {
            BiPredicate<String, String> matchingFunction = groupName.endsWith("*") ? String::startsWith : String::equals;
            return variants.stream().anyMatch(v -> matchingFunction.test(funcName, v));
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
            new Info("__VERIFIER_nondet",
                    List.of("__VERIFIER_nondet_bool",
                    "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                    "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                    "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                    "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar"),
                    false, false, true
            ),
            // --------------------------- LLVM ---------------------------
            new Info("llvm.*",
                    List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin", "llvm.ctlz"),
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
            new Info("assert", List.of("__assert_fail", "__assert_rtn"),
                    false, false, false),
            new Info("exit", false, false, false),
            new Info("abort", false, false, false),
            new Info("printf", false, false, true),
            new Info("puts", false, false, true)
    ));


    public static ProgramProcessor markIntrinsicsPass() {
        return program -> {
            for (Function func : program.getFunctions()) {
                if (!func.hasBody()) {
                    final String funcName = func.getName();
                    final Info intrinsicsInfo = INTRINSICS.stream()
                            .filter(info -> info.matches(funcName))
                            .findFirst()
                            .orElseThrow(() -> new UnsupportedOperationException("Unknown intrinsic function " + funcName ));
                    func.setIntrinsicInfo(intrinsicsInfo);
                }
            }
        };
    }
}
