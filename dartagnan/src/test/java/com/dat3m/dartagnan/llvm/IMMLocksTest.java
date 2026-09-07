package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class IMMLocksTest extends AbstractCTest {

    public IMMLocksTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected boolean isEagerMethodEnabled() {
        return false;
    }

    @Override
    protected String getProgramPathPrefix() {
        return "locks/";
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"ttas", IMM, UNKNOWN},
                {"ttas-acq2rx", IMM, FAIL},
                {"ttas-rel2rx", IMM, FAIL},
                {"ticketlock", IMM, PASS},
                {"ticketlock-acq2rx", IMM, FAIL},
                {"ticketlock-rel2rx", IMM, FAIL},
                {"mutex", IMM, UNKNOWN},
                {"mutex-acq2rx_futex", IMM, UNKNOWN},
                {"mutex-acq2rx_lock", IMM, FAIL},
                {"mutex-rel2rx_futex", IMM, UNKNOWN},
                {"mutex-rel2rx_unlock", IMM, FAIL},
                {"spinlock", IMM, PASS},
                {"spinlock-acq2rx", IMM, FAIL},
                {"spinlock-rel2rx", IMM, FAIL},
                {"linuxrwlock", IMM, UNKNOWN},
                {"linuxrwlock-acq2rx", IMM, FAIL},
                {"linuxrwlock-rel2rx", IMM, FAIL},
                {"mutex_musl", IMM, UNKNOWN},
                {"mutex_musl-acq2rx_futex", IMM, UNKNOWN},
                {"mutex_musl-acq2rx_lock", IMM, FAIL},
                {"mutex_musl-rel2rx_futex", IMM, UNKNOWN},
                {"mutex_musl-rel2rx_unlock", IMM, FAIL},
                {"seqlock", IMM, PASS},
                {"clh_mutex", IMM, UNKNOWN},
                {"clh_mutex-acq2rx", IMM, FAIL},
                {"ticket_awnsb_mutex", IMM, PASS},
                {"ticket_awnsb_mutex-acq2rx", IMM, FAIL},
        });
    }
}