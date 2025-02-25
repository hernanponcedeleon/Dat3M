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

import static com.dat3m.dartagnan.configuration.Arch.LKMM;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CLKMMTest extends AbstractCTest {

    public CLKMMTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("lkmm/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"2+2W+onces+locked", LKMM, PASS},
                {"C-atomic-op-return-simple-02-2", LKMM, FAIL},
                {"C-PaulEMcKenney-MP+o-r+ai-mb-o", LKMM, PASS},
                {"C-RR-G+RR-G+RR-G+RR-G+RR-R+RR-R+RR-R", LKMM, PASS},
                {"C-WWC+o-branch-o+o-branch-o", LKMM, FAIL},
                {"CoRR+poonce+Once", LKMM, PASS},
                {"CoRW+poonce+Once", LKMM, PASS},
                {"CoWR+poonceonce+Once", LKMM, PASS},
                {"LB+fencembonceonce+ctrlonceonce", LKMM, PASS},
                {"LB+poacquireonce+pooncerelease", LKMM, PASS},
                {"LB+poonceonces", LKMM, FAIL},
                {"MP+fencewbonceonce+fencermbonceonce", LKMM, PASS},
                {"NVR-RMW+Release", LKMM, PASS},
                {"rcu-gp20", LKMM, PASS},
                {"rcu", LKMM, PASS},
                {"rcu+ar-link-short0", LKMM, PASS},
                {"rcu+ar-link0", LKMM, FAIL},
                {"rcu+ar-link20", LKMM, PASS},
                {"rcu-MP", LKMM, PASS},
                //TODO: The following two tests are temporarily disabled because they
                // lead to mixed theory formulas (BV + IA) which can cause the solver to fail occasionally.
                // We need to run these benchmarks in pure BV, which we cannot configure right now.
                // --------------------
                // this one fails with cat/lkmm-v00.cat
                // but passes with cat/lkmm-vX.cat with X > 01
                //{"qspinlock", LKMM, PASS},
                // this one passes even with cat/lkmm-v00.cat
                //{"qspinlock-fixed", LKMM, PASS}
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