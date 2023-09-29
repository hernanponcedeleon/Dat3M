package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LKMMInterruptsTest extends AbstractCTest {

    public LKMMInterruptsTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> getTestResourcePath("interrupts/" + name + ".ll"));
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(getRootPath("cat/linux-kernel.cat"))));
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"c_disable_v1-opt", LKMM, PASS},
                {"c_disable_v2-opt", LKMM, PASS},
                {"c_disable_v3-opt", LKMM, PASS},
                {"lkmm_detour_disable_release-opt", LKMM, PASS},
                {"lkmm_detour-opt", LKMM, FAIL},
                {"lkmm_detour-opt", LKMM, FAIL},
                {"lkmm_oota-opt", LKMM, PASS},
                // {"lkmm_weak_model-opt", LKMM, PASS},
                {"lkmm_with_barrier_dec_barrier-opt", LKMM, PASS},
                {"lkmm_with_barrier_dec_wmb-opt", LKMM, PASS},
                {"lkmm_with_barrier_dec-opt", LKMM, FAIL},
                {"lkmm_with_barrier-opt", LKMM, PASS},
                {"lkmm_with_barrier_inc_split-opt", LKMM, FAIL},
                {"lkmm_with_disable_enable_as_barrier-opt", LKMM, PASS},
                {"lkmm_without_barrier-opt", LKMM, FAIL},
        });
    }

    @Test
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