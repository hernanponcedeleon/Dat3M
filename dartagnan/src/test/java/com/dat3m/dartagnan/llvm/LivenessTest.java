package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.verification.Result.*;

@RunWith(Parameterized.class)
public class LivenessTest extends AbstractCTest {

    public LivenessTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return () -> 2;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(Property.TERMINATION);
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"locks/ttas", TSO, BOUNDED},
                {"locks/ttas", ARM8, BOUNDED},
                {"locks/ttas", POWER, BOUNDED},
                {"locks/ttas", RISCV, BOUNDED},
                {"locks/ttas-acq2rx", TSO, BOUNDED},
                {"locks/ttas-acq2rx", ARM8, BOUNDED},
                {"locks/ttas-acq2rx", POWER, BOUNDED},
                {"locks/ttas-acq2rx", RISCV, BOUNDED},
                {"locks/ttas-rel2rx", TSO, BOUNDED},
                {"locks/ttas-rel2rx", ARM8, BOUNDED},
                {"locks/ttas-rel2rx", POWER, BOUNDED},
                {"locks/ttas-rel2rx", RISCV, BOUNDED},
                {"locks/ticketlock", TSO, PASS},
                {"locks/ticketlock", ARM8, PASS},
                {"locks/ticketlock", POWER, PASS},
                {"locks/ticketlock", RISCV, PASS},
                {"locks/ticketlock-acq2rx", TSO, PASS},
                {"locks/ticketlock-acq2rx", ARM8, PASS},
                {"locks/ticketlock-acq2rx", POWER, PASS},
                {"locks/ticketlock-acq2rx", RISCV, PASS},
                {"locks/ticketlock-rel2rx", TSO, PASS},
                {"locks/ticketlock-rel2rx", ARM8, PASS},
                {"locks/ticketlock-rel2rx", POWER, PASS},
                {"locks/ticketlock-rel2rx", RISCV, PASS},
                {"locks/mutex", TSO, BOUNDED},
                {"locks/mutex", ARM8, BOUNDED},
                {"locks/mutex", POWER, BOUNDED},
                {"locks/mutex", RISCV, BOUNDED},
                {"locks/mutex-acq2rx_futex", TSO, BOUNDED},
                {"locks/mutex-acq2rx_futex", ARM8, FAIL},
                {"locks/mutex-acq2rx_futex", POWER, FAIL},
                {"locks/mutex-acq2rx_futex", RISCV, FAIL},
                {"locks/mutex-acq2rx_lock", TSO, BOUNDED},
                {"locks/mutex-acq2rx_lock", ARM8, BOUNDED},
                {"locks/mutex-acq2rx_lock", POWER, BOUNDED},
                {"locks/mutex-acq2rx_lock", RISCV, BOUNDED},
                {"locks/mutex-rel2rx_futex", TSO, BOUNDED},
                {"locks/mutex-rel2rx_futex", ARM8, FAIL},
                {"locks/mutex-rel2rx_futex", POWER, FAIL},
                {"locks/mutex-rel2rx_futex", RISCV, FAIL},
                {"locks/mutex-rel2rx_unlock", TSO, BOUNDED},
                {"locks/mutex-rel2rx_unlock", ARM8, BOUNDED},
                {"locks/mutex-rel2rx_unlock", POWER, BOUNDED},
                {"locks/mutex-rel2rx_unlock", RISCV, BOUNDED},
                {"locks/spinlock", TSO, PASS},
                {"locks/spinlock", ARM8, PASS},
                {"locks/spinlock", POWER, PASS},
                {"locks/spinlock", RISCV, PASS},
                {"locks/spinlock-acq2rx", TSO, PASS},
                {"locks/spinlock-acq2rx", ARM8, PASS},
                {"locks/spinlock-acq2rx", POWER, PASS},
                {"locks/spinlock-acq2rx", RISCV, PASS},
                {"locks/spinlock-rel2rx", TSO, PASS},
                {"locks/spinlock-rel2rx", ARM8, PASS},
                {"locks/spinlock-rel2rx", POWER, PASS},
                {"locks/spinlock-rel2rx", RISCV, PASS},
                {"locks/linuxrwlock", TSO, BOUNDED},
                {"locks/linuxrwlock", ARM8, BOUNDED},
                {"locks/linuxrwlock", POWER, BOUNDED},
                {"locks/linuxrwlock", RISCV, BOUNDED},
                {"locks/linuxrwlock-acq2rx", TSO, BOUNDED},
                {"locks/linuxrwlock-acq2rx", ARM8, BOUNDED},
                {"locks/linuxrwlock-acq2rx", POWER, BOUNDED},
                {"locks/linuxrwlock-acq2rx", RISCV, BOUNDED},
                {"locks/linuxrwlock-rel2rx", TSO, BOUNDED},
                {"locks/linuxrwlock-rel2rx", ARM8, BOUNDED},
                {"locks/linuxrwlock-rel2rx", POWER, BOUNDED},
                {"locks/linuxrwlock-rel2rx", RISCV, BOUNDED},
                {"locks/mutex_musl", TSO, BOUNDED},
                {"locks/mutex_musl", ARM8, BOUNDED},
                {"locks/mutex_musl", POWER, BOUNDED},
                {"locks/mutex_musl", RISCV, BOUNDED},
                {"locks/mutex_musl-acq2rx_futex", TSO, BOUNDED},
                {"locks/mutex_musl-acq2rx_futex", ARM8, FAIL},
                {"locks/mutex_musl-acq2rx_futex", POWER, FAIL},
                {"locks/mutex_musl-acq2rx_futex", RISCV, FAIL},
                {"locks/mutex_musl-acq2rx_lock", TSO, BOUNDED},
                {"locks/mutex_musl-acq2rx_lock", ARM8, BOUNDED},
                {"locks/mutex_musl-acq2rx_lock", POWER, BOUNDED},
                {"locks/mutex_musl-acq2rx_lock", RISCV, BOUNDED},
                {"locks/mutex_musl-rel2rx_futex", TSO, BOUNDED},
                {"locks/mutex_musl-rel2rx_futex", ARM8, FAIL},
                {"locks/mutex_musl-rel2rx_futex", POWER, FAIL},
                {"locks/mutex_musl-rel2rx_futex", RISCV, FAIL},
                {"locks/mutex_musl-rel2rx_unlock", TSO, BOUNDED},
                {"locks/mutex_musl-rel2rx_unlock", ARM8, BOUNDED},
                {"locks/mutex_musl-rel2rx_unlock", POWER, BOUNDED},
                {"locks/mutex_musl-rel2rx_unlock", RISCV, BOUNDED},
                {"locks/seqlock", TSO, PASS},
                {"locks/seqlock", ARM8, PASS},
                {"locks/seqlock", POWER, PASS},
                {"locks/seqlock", RISCV, PASS},
                {"lkmm/qspinlock-liveness", LKMM, FAIL},
                {"lkmm/qspinlock-liveness", ARM8, PASS},
                {"lkmm/qspinlock-liveness", POWER, PASS},
                {"lkmm/qspinlock-liveness", RISCV, PASS},
                {"locks/deadlock", TSO, FAIL},
                {"locks/deadlock", ARM8, FAIL},
                {"locks/deadlock", POWER, FAIL},
                {"locks/deadlock", RISCV, FAIL},
                // Side-effectful nontermination
                {"nontermination/nontermination_sanity", TSO, BOUNDED},
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
                {"nontermination/termination_repetition", TSO, BOUNDED},
                {"nontermination/locks_abort", IMM, PASS},
                // Termination tests related to pthread_join() modeling
                {"nontermination/nontermination_pthread_join_1", IMM, PASS},
                {"nontermination/nontermination_pthread_join_2", IMM, PASS},
                {"nontermination/nontermination_pthread_join_3", IMM, PASS},
                {"nontermination/nontermination_pthread_join_4", IMM, FAIL},
                {"nontermination/nontermination_pthread_join_5", IMM, FAIL}
        });
    }

    // @Test
    public void testAssume() throws Exception {
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testSolver(Method.LAZY);
    }
}