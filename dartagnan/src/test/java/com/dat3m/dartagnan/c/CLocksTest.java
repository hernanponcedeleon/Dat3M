package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CLocksTest extends AbstractCTest {

    public CLocksTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("locks/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"ttas", TSO, UNKNOWN},
                {"ttas", ARM8, UNKNOWN},
                {"ttas", POWER, UNKNOWN},
                {"ttas", RISCV, UNKNOWN},
                {"ttas-acq2rx", TSO, UNKNOWN},
                {"ttas-acq2rx", ARM8, FAIL},
                {"ttas-acq2rx", POWER, FAIL},
                {"ttas-acq2rx", RISCV, FAIL},
                {"ttas-rel2rx", TSO, UNKNOWN},
                {"ttas-rel2rx", ARM8, FAIL},
                {"ttas-rel2rx", POWER, FAIL},
                {"ttas-rel2rx", RISCV, FAIL},
                {"ticketlock", TSO, PASS},
                {"ticketlock", ARM8, PASS},
                {"ticketlock", POWER, PASS},
                {"ticketlock", RISCV, PASS},
                {"ticketlock-acq2rx", TSO, PASS},
                {"ticketlock-acq2rx", ARM8, FAIL},
                {"ticketlock-acq2rx", POWER, FAIL},
                {"ticketlock-acq2rx", RISCV, FAIL},
                {"ticketlock-rel2rx", TSO, PASS},
                {"ticketlock-rel2rx", ARM8, FAIL},
                {"ticketlock-rel2rx", POWER, FAIL},
                {"ticketlock-rel2rx", RISCV, FAIL},
                {"mutex", TSO, UNKNOWN},
                {"mutex", ARM8, UNKNOWN},
                {"mutex", POWER, UNKNOWN},
                {"mutex", RISCV, UNKNOWN},
                {"mutex-acq2rx_futex", TSO, UNKNOWN},
                {"mutex-acq2rx_futex", ARM8, UNKNOWN},
                {"mutex-acq2rx_futex", POWER, UNKNOWN},
                {"mutex-acq2rx_futex", RISCV, UNKNOWN},
                {"mutex-acq2rx_lock", TSO, UNKNOWN},
                {"mutex-acq2rx_lock", ARM8, FAIL},
                {"mutex-acq2rx_lock", POWER, FAIL},
                {"mutex-acq2rx_lock", RISCV, FAIL},
                {"mutex-rel2rx_futex", TSO, UNKNOWN},
                {"mutex-rel2rx_futex", ARM8, UNKNOWN},
                {"mutex-rel2rx_futex", POWER, UNKNOWN},
                {"mutex-rel2rx_futex", RISCV, UNKNOWN},
                {"mutex-rel2rx_unlock", TSO, UNKNOWN},
                {"mutex-rel2rx_unlock", ARM8, FAIL},
                {"mutex-rel2rx_unlock", POWER, FAIL},
                {"mutex-rel2rx_unlock", RISCV, FAIL},
                {"spinlock", TSO, PASS},
                {"spinlock", ARM8, PASS},
                {"spinlock", POWER, PASS},
                {"spinlock", RISCV, PASS},
                {"spinlock-acq2rx", TSO, PASS},
                {"spinlock-acq2rx", ARM8, FAIL},
                {"spinlock-acq2rx", POWER, FAIL},
                {"spinlock-acq2rx", RISCV, FAIL},
                {"spinlock-rel2rx", TSO, PASS},
                {"spinlock-rel2rx", ARM8, FAIL},
                {"spinlock-rel2rx", POWER, FAIL},
                {"spinlock-rel2rx", RISCV, FAIL},
                {"linuxrwlock", TSO, UNKNOWN},
                {"linuxrwlock", ARM8, UNKNOWN},
                {"linuxrwlock", POWER, UNKNOWN},
                {"linuxrwlock", RISCV, UNKNOWN},
                {"linuxrwlock-acq2rx", TSO, UNKNOWN},
                {"linuxrwlock-acq2rx", ARM8, FAIL},
                {"linuxrwlock-acq2rx", POWER, FAIL},
                {"linuxrwlock-acq2rx", RISCV, FAIL},
                {"linuxrwlock-rel2rx", TSO, UNKNOWN},
                {"linuxrwlock-rel2rx", ARM8, FAIL},
                {"linuxrwlock-rel2rx", POWER, FAIL},
                {"linuxrwlock-rel2rx", RISCV, FAIL},
                {"mutex_musl", TSO, UNKNOWN},
                {"mutex_musl", ARM8, UNKNOWN},
                {"mutex_musl", POWER, UNKNOWN},
                {"mutex_musl", RISCV, UNKNOWN},
                {"mutex_musl-acq2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-acq2rx_futex", ARM8, UNKNOWN},
                {"mutex_musl-acq2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-acq2rx_futex", RISCV, UNKNOWN},
                {"mutex_musl-acq2rx_lock", TSO, UNKNOWN},
                {"mutex_musl-acq2rx_lock", ARM8, FAIL},
                {"mutex_musl-acq2rx_lock", POWER, FAIL},
                {"mutex_musl-acq2rx_lock", RISCV, FAIL},
                {"mutex_musl-rel2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-rel2rx_futex", ARM8, UNKNOWN},
                {"mutex_musl-rel2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-rel2rx_futex", RISCV, UNKNOWN},
                {"mutex_musl-rel2rx_unlock", TSO, UNKNOWN},
                {"mutex_musl-rel2rx_unlock", ARM8, FAIL},
                {"mutex_musl-rel2rx_unlock", POWER, FAIL},
                {"mutex_musl-rel2rx_unlock", RISCV, FAIL},
                {"seqlock", TSO, PASS},
                {"seqlock", ARM8, PASS},
                {"seqlock", POWER, PASS},
                {"seqlock", RISCV, PASS},
                {"pthread_mutex", TSO, PASS},
                {"pthread_mutex", ARM8, PASS},
                {"pthread_mutex", POWER, PASS},
                {"pthread_mutex", RISCV, PASS},
                {"clh_mutex", TSO, UNKNOWN},
                {"clh_mutex-acq2rx", TSO, UNKNOWN},
                {"clh_mutex", ARM8, UNKNOWN},
                {"clh_mutex-acq2rx", ARM8, FAIL},
                {"clh_mutex", POWER, UNKNOWN},
                {"clh_mutex-acq2rx", POWER, FAIL},
                {"clh_mutex", RISCV, UNKNOWN},
                {"clh_mutex-acq2rx", RISCV, FAIL},
                {"ticket_awnsb_mutex", TSO, PASS},
                {"ticket_awnsb_mutex-acq2rx", TSO, PASS},
                {"ticket_awnsb_mutex", ARM8, PASS},
                {"ticket_awnsb_mutex-acq2rx", ARM8, FAIL},
                {"ticket_awnsb_mutex", POWER, PASS},
                {"ticket_awnsb_mutex-acq2rx", POWER, FAIL},
                {"ticket_awnsb_mutex", RISCV, PASS},
                {"ticket_awnsb_mutex-acq2rx", RISCV, FAIL},
        });
    }

    // @Test
    public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}