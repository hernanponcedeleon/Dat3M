package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

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
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(Property.LIVENESS);
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"locks/ttas", TSO, UNKNOWN},
                {"locks/ttas", ARM8, UNKNOWN},
                {"locks/ttas", POWER, UNKNOWN},
                {"locks/ttas", RISCV, UNKNOWN},
                {"locks/ttas-acq2rx", TSO, UNKNOWN},
                {"locks/ttas-acq2rx", ARM8, UNKNOWN},
                {"locks/ttas-acq2rx", POWER, UNKNOWN},
                {"locks/ttas-acq2rx", RISCV, UNKNOWN},
                {"locks/ttas-rel2rx", TSO, UNKNOWN},
                {"locks/ttas-rel2rx", ARM8, UNKNOWN},
                {"locks/ttas-rel2rx", POWER, UNKNOWN},
                {"locks/ttas-rel2rx", RISCV, UNKNOWN},
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
                {"locks/mutex", TSO, UNKNOWN},
                {"locks/mutex", ARM8, UNKNOWN},
                {"locks/mutex", POWER, UNKNOWN},
                {"locks/mutex", RISCV, UNKNOWN},
                {"locks/mutex-acq2rx_futex", TSO, UNKNOWN},
                {"locks/mutex-acq2rx_futex", ARM8, FAIL},
                {"locks/mutex-acq2rx_futex", POWER, FAIL},
                {"locks/mutex-acq2rx_futex", RISCV, FAIL},
                {"locks/mutex-acq2rx_lock", TSO, UNKNOWN},
                {"locks/mutex-acq2rx_lock", ARM8, UNKNOWN},
                {"locks/mutex-acq2rx_lock", POWER, UNKNOWN},
                {"locks/mutex-acq2rx_lock", RISCV, UNKNOWN},
                {"locks/mutex-rel2rx_futex", TSO, UNKNOWN},
                {"locks/mutex-rel2rx_futex", ARM8, FAIL},
                {"locks/mutex-rel2rx_futex", POWER, FAIL},
                {"locks/mutex-rel2rx_futex", RISCV, FAIL},
                {"locks/mutex-rel2rx_unlock", TSO, UNKNOWN},
                {"locks/mutex-rel2rx_unlock", ARM8, UNKNOWN},
                {"locks/mutex-rel2rx_unlock", POWER, UNKNOWN},
                {"locks/mutex-rel2rx_unlock", RISCV, UNKNOWN},
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
                {"locks/linuxrwlock", TSO, UNKNOWN},
                {"locks/linuxrwlock", ARM8, UNKNOWN},
                {"locks/linuxrwlock", POWER, UNKNOWN},
                {"locks/linuxrwlock", RISCV, UNKNOWN},
                {"locks/linuxrwlock-acq2rx", TSO, UNKNOWN},
                {"locks/linuxrwlock-acq2rx", ARM8, UNKNOWN},
                {"locks/linuxrwlock-acq2rx", POWER, UNKNOWN},
                {"locks/linuxrwlock-acq2rx", RISCV, UNKNOWN},
                {"locks/linuxrwlock-rel2rx", TSO, UNKNOWN},
                {"locks/linuxrwlock-rel2rx", ARM8, UNKNOWN},
                {"locks/linuxrwlock-rel2rx", POWER, UNKNOWN},
                {"locks/linuxrwlock-rel2rx", RISCV, UNKNOWN},
                {"locks/mutex_musl", TSO, UNKNOWN},
                {"locks/mutex_musl", ARM8, UNKNOWN},
                {"locks/mutex_musl", POWER, UNKNOWN},
                {"locks/mutex_musl", RISCV, UNKNOWN},
                {"locks/mutex_musl-acq2rx_futex", TSO, UNKNOWN},
                {"locks/mutex_musl-acq2rx_futex", ARM8, UNKNOWN},
                {"locks/mutex_musl-acq2rx_futex", POWER, UNKNOWN},
                {"locks/mutex_musl-acq2rx_futex", RISCV, UNKNOWN},
                {"locks/mutex_musl-acq2rx_lock", TSO, UNKNOWN},
                {"locks/mutex_musl-acq2rx_lock", ARM8, UNKNOWN},
                {"locks/mutex_musl-acq2rx_lock", POWER, UNKNOWN},
                {"locks/mutex_musl-acq2rx_lock", RISCV, UNKNOWN},
                {"locks/mutex_musl-rel2rx_futex", TSO, UNKNOWN},
                {"locks/mutex_musl-rel2rx_futex", ARM8, UNKNOWN},
                {"locks/mutex_musl-rel2rx_futex", POWER, UNKNOWN},
                {"locks/mutex_musl-rel2rx_futex", RISCV, UNKNOWN},
                {"locks/mutex_musl-rel2rx_unlock", TSO, UNKNOWN},
                {"locks/mutex_musl-rel2rx_unlock", ARM8, UNKNOWN},
                {"locks/mutex_musl-rel2rx_unlock", POWER, UNKNOWN},
                {"locks/mutex_musl-rel2rx_unlock", RISCV, UNKNOWN},
                {"locks/seqlock", TSO, PASS},
                {"locks/seqlock", ARM8, PASS},
                {"locks/seqlock", POWER, PASS},
                {"locks/seqlock", RISCV, PASS},
                {"lkmm/qspinlock-liveness", LKMM, FAIL},
                {"lkmm/qspinlock-liveness", ARM8, PASS},
                {"lkmm/qspinlock-liveness", POWER, PASS},
                {"lkmm/qspinlock-liveness", RISCV, PASS},
        });
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}