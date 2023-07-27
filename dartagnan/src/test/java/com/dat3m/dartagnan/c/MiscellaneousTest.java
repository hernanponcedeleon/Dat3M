package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class MiscellaneousTest extends AbstractCTest {

    private final int bound;

    public MiscellaneousTest(String name, Arch target, Result expected, int bound) {
        super(name, target, expected);
        this.bound = bound;
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "miscellaneous/" + name + ".bpl");
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return () -> bound;
    }

    @Override
    protected long getTimeout() {
        return 10000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"idd_dynamic", ARM8, FAIL, 1},
                {"propagatableSideEffects", ARM8, FAIL, 1},
                {"SB-RMW", TSO, PASS, 1},
                {"SB-RMW", IMM, PASS, 1},
                {"MP_atomic_bool", IMM, PASS, 1},
                {"MP_atomic_bool_weak", IMM, FAIL, 1},
                {"nondet_loop", IMM, FAIL, 1},
                {"thread_chaining", IMM, PASS, 1},
                {"thread_inlining", IMM, PASS, 1},
                {"thread_inlining_complex", IMM, PASS, 1},
                {"thread_inlining_complex_2", IMM, PASS, 1},
                {"thread_local", IMM, PASS, 1},
                {"thread_loop", IMM, FAIL, 1}
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