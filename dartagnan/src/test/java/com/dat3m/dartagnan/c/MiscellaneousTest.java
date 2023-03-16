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
import static com.dat3m.dartagnan.utils.Result.*;
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
                {"propagatableSideEffects", ARM8, FAIL, 3},
                {"SB-RMW", TSO, PASS, 1},
                {"SB-RMW", IMM, PASS, 1},
                {"memcpy_char", IMM, PASS, 1},
                {"memcpy_int", IMM, PASS, 3},
                {"memcpy_char_fail", IMM, FAIL, 1},
                {"memcpy_int_fail", IMM, FAIL, 2},
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