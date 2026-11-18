package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

@RunWith(Parameterized.class)
public class LivenessTest extends AbstractCTest {

    public LivenessTest(String name, Arch target, VerificationStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected long getTimeoutSeconds() { return 60; }

    @Override
    protected int getBound() { return 2; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.TERMINATION); }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"lkmm/qspinlock-liveness", LKMM, FAIL},
                {"lkmm/qspinlock-liveness", ARM8, PASS},
                {"lkmm/qspinlock-liveness", POWER, PASS},
                {"lkmm/qspinlock-liveness", RISCV, PASS},
                {"locks/deadlock", TSO, FAIL},
                {"locks/deadlock", ARM8, FAIL},
                {"locks/deadlock", POWER, FAIL},
                {"locks/deadlock", RISCV, FAIL},
                // Side-effectful nontermination
                {"nontermination/nontermination_sanity", TSO, UNKNOWN},
                {"nontermination/nontermination", TSO, FAIL},
                {"nontermination/nontermination_xchg", TSO, FAIL},
                {"nontermination/nontermination_zero_effect", TSO, FAIL},
                {"nontermination/nontermination_complex", TSO, FAIL},
                {"nontermination/nontermination_weak", TSO, PASS},
                {"nontermination/nontermination_weak", ARM8, FAIL},
                {"nontermination/nontermination_asymmetric", TSO, FAIL},
                {"nontermination/nontermination_oscillation_simple", TSO, FAIL},
                {"nontermination/nontermination_oscillation_long", TSO, FAIL},
                {"nontermination/nontermination_unstructured_spin", TSO, PASS},
                {"nontermination/termination_repetition", TSO, UNKNOWN},
                {"nontermination/locks_abort", IMM, PASS},
                // Termination tests related to pthread_join() modeling
                {"nontermination/nontermination_pthread_join_1", IMM, PASS},
                {"nontermination/nontermination_pthread_join_2", IMM, PASS},
                {"nontermination/nontermination_pthread_join_3", IMM, PASS},
                {"nontermination/nontermination_pthread_join_4", IMM, FAIL},
                {"nontermination/nontermination_pthread_join_5", IMM, FAIL}
        });
    }
}