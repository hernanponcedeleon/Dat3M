package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LibvsyncTest extends AbstractCTest {

    public LibvsyncTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> getTestResourcePath("libvsync/" + name + "-opt.ll"));
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

    @Override
    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.defaultConfiguration());
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.PROGRAM_SPEC, Property.LIVENESS));
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(getRootPath("cat/imm.cat"))));
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"caslock", IMM, UNKNOWN},
                {"mcslock", IMM, UNKNOWN},
                {"rec_mcslock", IMM, UNKNOWN},
                {"rec_spinlock", IMM, UNKNOWN},
                {"rec_ticketlock", IMM, UNKNOWN},
                {"rwlock", IMM, UNKNOWN},
                {"semaphore", IMM, UNKNOWN},
                {"seqcount", IMM, PASS},
                {"seqlock", IMM, UNKNOWN},
                {"ticketlock", IMM, UNKNOWN},
                {"ttaslock", IMM, UNKNOWN},
                {"bounded_mpmc_check_empty", IMM, UNKNOWN},
                {"bounded_mpmc_check_full", IMM, UNKNOWN},
                {"bounded_spsc", IMM, UNKNOWN},
        });
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}