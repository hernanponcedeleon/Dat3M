package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static org.junit.Assert.assertEquals;
import static com.dat3m.dartagnan.configuration.Property.*;

@RunWith(Parameterized.class)
public class LibvsyncTest extends AbstractCTest {

    public LibvsyncTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("libvsync/" + name + "-opt.ll");
    }

    @Override
    protected Configuration getConfiguration(){
        return Configuration.defaultConfiguration();
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(PROGRAM_SPEC, LIVENESS, CAT_SPEC);
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "vmm");
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"caslock", C11, UNKNOWN},
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

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}