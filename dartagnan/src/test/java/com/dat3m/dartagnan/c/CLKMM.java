package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.configuration.Arch;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.configuration.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CLKMM extends AbstractCTest {

    public CLKMM(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "lkmm/" + name + ".bpl");
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
                {"NVR-RMW+Release", LKMM, FAIL},
                {"rcu-gp20", LKMM, PASS},
                {"rcu", LKMM, PASS},
                {"rcu+ar-link-short0", LKMM, PASS},
                {"rcu+ar-link0", LKMM, FAIL},
                {"rcu+ar-link20", LKMM, PASS},
                {"rcu-MP", LKMM, PASS},
                {"qspinlock", LKMM, FAIL},
                {"qspinlock-fixed", LKMM, PASS}
		});
    }

	@Test
	@CSVLogger.FileName("csv/assume")
	public void testAssume() throws Exception {
		assertEquals(expected, AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get()));
	}

	@Test
	@CSVLogger.FileName("csv/refinement")
	public void testRefinement() throws Exception {
		assertEquals(expected, RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get()));
	}
}