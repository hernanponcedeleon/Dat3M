package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
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
        return () -> getTestResourcePath("miscellaneous/" + name + ".ll");
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return () -> bound;
    }

    @Override
    protected long getTimeout() {
        return 10000;
    }

    @Override
    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> {
            ConfigurationBuilder builder = Configuration.builder();
            if (!name.equals("pthread") && !name.equals("ctlz") && !name.equals("cttz")) {
                builder.setOption(OptionNames.USE_INTEGERS, "true");
            }
            if (name.equals("recursion")) {
                builder.setOption(OptionNames.RECURSION_BOUND, String.valueOf(bound));
            }
            return builder.build();
        });
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"idd_dynamic", ARM8, FAIL, 1},
                {"propagatableSideEffects", ARM8, FAIL, 1},
                {"SB-RMW", TSO, PASS, 1},
                {"SB-RMW", IMM, PASS, 1},
                {"SB-asm-mfences", TSO, PASS, 1},
                {"SB-asm-lwsync+sync", POWER, FAIL, 1},
                {"SB-asm-syncs", POWER, PASS, 1},
                {"MP_atomic_bool", IMM, PASS, 1},
                {"MP_atomic_bool_weak", IMM, FAIL, 1},
                {"nondet_loop", IMM, FAIL, 1},
                {"pthread", IMM, PASS, 1},
                {"recursion", IMM, UNKNOWN, 1},
                {"recursion", IMM, PASS, 2},
                {"thread_chaining", IMM, PASS, 1},
                {"thread_inlining", IMM, PASS, 1},
                {"thread_inlining_complex", IMM, PASS, 1},
                {"thread_inlining_complex_2", IMM, PASS, 1},
                {"thread_local", IMM, PASS, 1},
                {"thread_loop", IMM, FAIL, 1},
                {"thread_id", IMM, PASS, 1},
                {"funcPtrInStaticMemory", IMM, PASS, 1},
                {"verifierAssert", ARM8, FAIL, 1},
                {"uninitRead", IMM, FAIL, 1},
                {"multipleBackJumps", IMM, UNKNOWN, 1},
                {"memcpy_s", IMM, PASS, 1},
                {"staticLoops", IMM, PASS, 1},
                {"offsetof", IMM, PASS, 1},
                {"ctlz", IMM, PASS, 1},
                {"cttz", IMM, PASS, 1},
                {"jumpIntoLoop", IMM, PASS, 11},
                {"nondet_alloc", IMM, FAIL, 1},
                {"nondet_alloc_2", IMM, PASS, 1},
                {"nondet_aligned_alloc", IMM, PASS, 1},
                {"alignment", IMM, PASS, 1},
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