package com.dat3m.dartagnan.benchmarking;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.c.AbstractCTest;
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
public class DartagnanLKMM extends AbstractCTest {

    public DartagnanLKMM(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 900000;
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return Provider.fromSupplier(() -> 2);
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"lkmm/lkmm-ttas-5", NONE, UNKNOWN},
            {"lkmm/lkmm-ticketlock-6", NONE, PASS},
            {"lkmm/lkmm-mutex-4", NONE, UNKNOWN},
            {"lkmm/lkmm-spinlock-5", NONE, UNKNOWN},
            {"lkmm/lkmm-linuxrwlock-3", FAIL, UNKNOWN},
            {"lkmm/lkmm-mutex_musl-4", NONE, UNKNOWN},
//            {"lfds/safestack-3", TSO, FAIL},
//            {"lfds/dglm-3", TSO, UNKNOWN},
//            {"lfds/ms-3", TSO, UNKNOWN},
//            {"lfds/treiber-3", TSO, UNKNOWN}
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