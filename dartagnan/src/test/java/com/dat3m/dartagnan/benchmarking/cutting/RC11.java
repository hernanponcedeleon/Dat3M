package com.dat3m.dartagnan.benchmarking.cutting;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.benchmarking.AbstractDartagnanTest;
import com.dat3m.dartagnan.configuration.Arch;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.configuration.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class RC11 extends AbstractDartagnanTest {

    public RC11(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "cut-rc11");
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
	            {"locks/ttas-5", C11, UNKNOWN},
	            {"locks/ticketlock-6", C11, PASS},
                {"locks/mutex-4", C11, UNKNOWN},
                {"locks/spinlock-5", C11, UNKNOWN},
                {"locks/linuxrwlock-3", C11, UNKNOWN},
                {"locks/mutex_musl-4", C11, UNKNOWN},
                {"lfds/safe_stack-3", C11, FAIL},
                {"lfds/chase-lev-5", C11, PASS},
                {"lfds/dglm-3", C11, UNKNOWN},
                {"lfds/harris-3", C11, UNKNOWN},
                {"lfds/ms-3", C11, UNKNOWN},
                {"lfds/treiber-3", C11, UNKNOWN},
		});
    }

	@Test
	@CSVLogger.FileName("csv/cutting")
	public void testRefinement() throws Exception {
		assertEquals(expected, RefinementSolver.run(contextProvider.get(), proverProvider.get(),
				RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
	}
}