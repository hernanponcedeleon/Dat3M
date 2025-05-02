package com.dat3m.dartagnan.llvm;

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

import static com.dat3m.dartagnan.configuration.Arch.LKMM;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
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
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(getRootPath("cat/lkmm-interrupts-alt.cat"))));
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"c_disable_v1", LKMM, PASS},
                {"c_disable_v2", LKMM, PASS},
                {"c_disable_v3", LKMM, PASS},
                {"lkmm_detour_disable_release", LKMM, PASS},
                {"lkmm_detour_disable", LKMM, FAIL},
                {"lkmm_detour", LKMM, FAIL},
                {"lkmm_oota", LKMM, PASS},
                {"lkmm_weak_model", LKMM, PASS},
                {"lkmm_with_barrier_dec_barrier", LKMM, PASS},
                {"lkmm_with_barrier_dec_wmb", LKMM, PASS},
                {"lkmm_with_barrier_dec", LKMM, FAIL},
                {"lkmm_with_barrier", LKMM, PASS},
                {"lkmm_with_barrier_inc_split", LKMM, FAIL},
                {"lkmm_with_disable_enable_as_barrier", LKMM, PASS},
                {"lkmm_without_barrier", LKMM, FAIL},
                // Miscellaneous
                {"ih_disabled_forever_v1", LKMM, PASS},
                {"ih_disabled_forever_v2", LKMM, PASS},
                {"multiple_ih_consistent_reorder", LKMM, PASS},
                {"multiple_ih_diffIP", LKMM, FAIL},
                {"multiple_ih_ordered_ihs", LKMM, PASS},
                {"multiple_ih_sameIP", LKMM, FAIL},
                {"reorder_same_loc", LKMM, PASS},
                {"safety_multiple-ih", LKMM, PASS},
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