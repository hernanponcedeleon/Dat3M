package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.Result.PASS;
import static com.dat3m.dartagnan.verification.Result.BOUNDED;

@RunWith(Parameterized.class)
public class LibvsyncTest extends AbstractCTest {

    public LibvsyncTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
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
                {"caslock", C11, BOUNDED},
                {"cachedq", C11, PASS},
                {"mcslock", C11, BOUNDED},
                {"rec_mcslock", C11, BOUNDED},
                {"rec_spinlock", C11, BOUNDED},
                {"rec_ticketlock", C11, BOUNDED},
                {"rwlock", C11, BOUNDED},
                {"semaphore", C11, BOUNDED},
                {"seqcount", C11, PASS},
                {"seqlock", C11, BOUNDED},
                {"ticketlock", C11, BOUNDED},
                {"ttaslock", C11, BOUNDED},
                {"bounded_mpmc_check_empty", C11, BOUNDED},
                {"bounded_mpmc_check_full", C11, BOUNDED},
                {"bounded_spsc", C11, BOUNDED},
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