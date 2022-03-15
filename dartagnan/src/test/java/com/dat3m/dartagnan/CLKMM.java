package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.RefinementTask;
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
	            {"CoRR+poonce+Once", NONE, PASS},
	            {"CoRW+poonce+Once", NONE, PASS},
	            {"CoWR+poonceonce+Once", NONE, PASS},
	            {"LB+fencembonceonce+ctrlonceonce", NONE, PASS},
	            {"LB+poacquireonce+pooncerelease", NONE, PASS},
	            {"LB+poonceonces", NONE, FAIL},
                {"MP+fencewbonceonce+fencermbonceonce", NONE, PASS},
                {"NVR-RMW+Release", NONE, FAIL},
                {"rcu-gp20", NONE, PASS},
                {"rcu", NONE, PASS},
                {"rcu+ar-link-short0", NONE, PASS},
                {"rcu+ar-link0", NONE, FAIL},
                {"rcu+ar-link20", NONE, PASS}
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
		assertEquals(expected, RefinementSolver.run(contextProvider.get(), proverProvider.get(),
				RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
	}
}