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
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static com.dat3m.dartagnan.verification.ResultStatus.UNKNOWN;

@RunWith(Parameterized.class)
public class LibvsyncTest extends AbstractCTest {

    public LibvsyncTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathString() {
        return "libvsync/%s-opt.ll";
    }

    @Override
    protected int getBound() {
        return switch (name) {
            case "cachedq" -> 2;
            default -> 1;
        };
    }

    @Override
    protected long getTimeoutSeconds() { return 300; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(PROGRAM_SPEC, TERMINATION, CAT_SPEC); }

    @Override
    protected String getWmmName() { return "vmm"; }

    @Override
    protected boolean isEagerMethodEnabled() { return false; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"caslock", C11, UNKNOWN},
                {"cachedq", C11, PASS},
                {"mcslock", C11, UNKNOWN},
                {"rec_mcslock", C11, UNKNOWN},
                {"rec_spinlock", C11, UNKNOWN},
                {"rec_ticketlock", C11, UNKNOWN},
                {"rwlock", C11, UNKNOWN},
                {"semaphore", C11, UNKNOWN},
                {"seqcount", C11, PASS},
                {"seqlock", C11, UNKNOWN},
                {"ticketlock", C11, UNKNOWN},
                {"ttaslock", C11, UNKNOWN},
                {"bounded_mpmc_check_empty", C11, UNKNOWN},
                {"bounded_mpmc_check_full", C11, UNKNOWN},
                {"bounded_spsc", C11, UNKNOWN},
        });
    }
}