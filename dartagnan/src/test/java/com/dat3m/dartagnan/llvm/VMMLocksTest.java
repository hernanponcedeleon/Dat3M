package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class VMMLocksTest extends AbstractCTest {

    public VMMLocksTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathPrefix() {
        return "locks/";
    }

    @Override
    protected long getTimeout() {
        return 600000;
    }

    @Override
    protected EnumSet<Property> getProperty() { return EnumSet.of(PROGRAM_SPEC, TERMINATION, CAT_SPEC); }

    @Override
    protected int getBound() { return 2; }

    @Override
    protected String getWmmName() { return "vmm"; }

    @Override
    protected boolean isEagerMethodEnabled() { return false; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"ttas", C11, UNKNOWN},
                {"ttas-acq2rx", C11, FAIL},
                {"ttas-rel2rx", C11, FAIL},
                {"ticketlock", C11, PASS},
                {"ticketlock-acq2rx", C11, FAIL},
                {"ticketlock-rel2rx", C11, FAIL},
                {"mutex", C11, UNKNOWN},
                {"mutex-acq2rx_futex", C11, FAIL},
                {"mutex-acq2rx_lock", C11, FAIL},
                {"mutex-rel2rx_futex", C11, FAIL},
                {"mutex-rel2rx_unlock", C11, FAIL},
                {"spinlock", C11, PASS},
                {"spinlock-acq2rx", C11, FAIL},
                {"spinlock-rel2rx", C11, FAIL},
                // VMM requires stronger orderings than hardware models (including IMM)
                {"linuxrwlock", C11, FAIL},
                // This one uses the correct orderings for VMM
                {"linuxrwlock-vmm", C11, UNKNOWN},
                {"linuxrwlock-acq2rx", C11, FAIL},
                {"linuxrwlock-rel2rx", C11, FAIL},
                {"mutex_musl", C11, UNKNOWN},
                {"mutex_musl-acq2rx_futex", C11, FAIL},
                {"mutex_musl-acq2rx_lock", C11, FAIL},
                {"mutex_musl-rel2rx_futex", C11, FAIL},
                {"mutex_musl-rel2rx_unlock", C11, FAIL},
                {"seqlock", C11, PASS},
                {"clh_mutex", C11, PASS},
                {"clh_mutex-acq2rx", C11, FAIL},
                {"ticket_awnsb_mutex", C11, PASS},
                {"ticket_awnsb_mutex-acq2rx", C11, FAIL},
        });
    }
}