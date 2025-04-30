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

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class VMMInterruptsTest extends AbstractCTest {

    public VMMInterruptsTest(String name, Arch target, Result expected) {
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
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(getRootPath("cat/vmm-interrupts-alt.cat"))));
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"c_disable_v1", C11, PASS},
                {"c_disable_v2", C11, PASS},
                {"c_disable_v3", C11, PASS},
                {"c11_detour_disable_release", C11, PASS},
                {"c11_detour_disable", C11, FAIL},
                {"c11_detour", C11, FAIL},
                {"c11_oota", C11, PASS},
                //{"c11_weak_model", C11, PASS},
                {"c11_with_barrier_dec_barrier", C11, PASS},
                {"c11_with_barrier_dec", C11, FAIL},
                {"c11_with_barrier", C11, PASS},
                {"c11_with_barrier_inc_split", C11, FAIL},
                {"c11_with_disable_enable_as_barrier", C11, PASS},
                {"c11_without_barrier", C11, FAIL},
                // Sanity
                {"assert_assume_race_v1", C11, PASS},
                {"assert_assume_race_v2", C11, FAIL},
                // Miscellaneous
                {"ih_disabled_forever", C11, PASS},
                {"multiple_ih_consistent_reorder", C11, PASS},
                {"multiple_ih_diffIP", C11, FAIL},
                {"multiple_ih_ordered_ihs", C11, PASS},
                {"multiple_ih_sameIP", C11, FAIL},
                {"reorder_same_loc", C11, PASS},
                {"safety_multiple-ih", C11, PASS},
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