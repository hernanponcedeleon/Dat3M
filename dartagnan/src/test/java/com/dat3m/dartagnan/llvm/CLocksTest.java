package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.verification.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.Result.*;

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
                {"ttas", TSO, BOUNDED},
                {"ttas", ARM8, BOUNDED},
                {"ttas", POWER, BOUNDED},
                {"ttas", RISCV, BOUNDED},
                {"ttas-acq2rx", TSO, BOUNDED},
                {"ttas-acq2rx", ARM8, FAIL},
                {"ttas-acq2rx", POWER, FAIL},
                {"ttas-acq2rx", RISCV, FAIL},
                {"ttas-rel2rx", TSO, BOUNDED},
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
                {"mutex", TSO, BOUNDED},
                {"mutex", ARM8, BOUNDED},
                {"mutex", POWER, BOUNDED},
                {"mutex", RISCV, BOUNDED},
                {"mutex-acq2rx_futex", TSO, BOUNDED},
                {"mutex-acq2rx_futex", ARM8, BOUNDED},
                {"mutex-acq2rx_futex", POWER, BOUNDED},
                {"mutex-acq2rx_futex", RISCV, BOUNDED},
                {"mutex-acq2rx_lock", TSO, BOUNDED},
                {"mutex-acq2rx_lock", ARM8, FAIL},
                {"mutex-acq2rx_lock", POWER, FAIL},
                {"mutex-acq2rx_lock", RISCV, FAIL},
                {"mutex-rel2rx_futex", TSO, BOUNDED},
                {"mutex-rel2rx_futex", ARM8, BOUNDED},
                {"mutex-rel2rx_futex", POWER, BOUNDED},
                {"mutex-rel2rx_futex", RISCV, BOUNDED},
                {"mutex-rel2rx_unlock", TSO, BOUNDED},
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
                {"linuxrwlock", TSO, BOUNDED},
                {"linuxrwlock", ARM8, BOUNDED},
                {"linuxrwlock", POWER, BOUNDED},
                {"linuxrwlock", RISCV, BOUNDED},
                {"linuxrwlock-acq2rx", TSO, BOUNDED},
                {"linuxrwlock-acq2rx", ARM8, FAIL},
                {"linuxrwlock-acq2rx", POWER, FAIL},
                {"linuxrwlock-acq2rx", RISCV, FAIL},
                {"linuxrwlock-rel2rx", TSO, BOUNDED},
                {"linuxrwlock-rel2rx", ARM8, FAIL},
                {"linuxrwlock-rel2rx", POWER, FAIL},
                {"linuxrwlock-rel2rx", RISCV, FAIL},
                {"mutex_musl", TSO, BOUNDED},
                {"mutex_musl", ARM8, BOUNDED},
                {"mutex_musl", POWER, BOUNDED},
                {"mutex_musl", RISCV, BOUNDED},
                {"mutex_musl-acq2rx_futex", TSO, BOUNDED},
                {"mutex_musl-acq2rx_futex", ARM8, BOUNDED},
                {"mutex_musl-acq2rx_futex", POWER, BOUNDED},
                {"mutex_musl-acq2rx_futex", RISCV, BOUNDED},
                {"mutex_musl-acq2rx_lock", TSO, BOUNDED},
                {"mutex_musl-acq2rx_lock", ARM8, FAIL},
                {"mutex_musl-acq2rx_lock", POWER, FAIL},
                {"mutex_musl-acq2rx_lock", RISCV, FAIL},
                {"mutex_musl-rel2rx_futex", TSO, BOUNDED},
                {"mutex_musl-rel2rx_futex", ARM8, BOUNDED},
                {"mutex_musl-rel2rx_futex", POWER, BOUNDED},
                {"mutex_musl-rel2rx_futex", RISCV, BOUNDED},
                {"mutex_musl-rel2rx_unlock", TSO, BOUNDED},
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
                {"clh_mutex", TSO, BOUNDED},
                {"clh_mutex-acq2rx", TSO, BOUNDED},
                {"clh_mutex", ARM8, BOUNDED},
                {"clh_mutex-acq2rx", ARM8, FAIL},
                {"clh_mutex", POWER, BOUNDED},
                {"clh_mutex-acq2rx", POWER, FAIL},
                {"clh_mutex", RISCV, BOUNDED},
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
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testSolver(Method.LAZY);
    }
}