package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import java.nio.file.Path;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;
import static com.dat3m.dartagnan.verification.ResultStatus.UNKNOWN;

@RunWith(Parameterized.class)
public class LibvsyncTest extends AbstractCTest {

    public LibvsyncTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<Path> getProgramPathProvider() {
        return () -> getTestResourcePath("libvsync/" + name + "-opt.ll");
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> switch (name) {
            case "cachedq" -> 2;
            default -> 1;
        };
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(PROGRAM_SPEC, TERMINATION, CAT_SPEC);
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "vmm");
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
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

    // @Test
    public void testAssume() throws Exception {
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testSolver(Method.LAZY);
    }
}