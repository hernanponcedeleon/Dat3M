package com.dat3m.dartagnan.benchmarking.caat;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
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
public class ARM8 extends AbstractDartagnanTest {

    public ARM8(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
	            {"locks/ttas-5", ARM8, UNKNOWN},
	            {"locks/ticketlock-6", ARM8, PASS},
                {"locks/mutex-4", ARM8, UNKNOWN},
                {"locks/spinlock-5", ARM8, UNKNOWN},
                {"locks/linuxrwlock-3", ARM8, UNKNOWN},
                {"locks/mutex_musl-4", ARM8, UNKNOWN},
                {"lfds/safe_stack-3", ARM8, FAIL},
                {"lfds/chase-lev-5", ARM8, PASS},
                {"lfds/dglm-3", ARM8, UNKNOWN},
                {"lfds/harris-3", ARM8, UNKNOWN},
                {"lfds/ms-3", ARM8, UNKNOWN},
                {"lfds/treiber-3", ARM8, UNKNOWN},
		});
    }

	@Test
	@CSVLogger.FileName("csv/caat")
	public void testRefinement() throws Exception {
		assertEquals(expected, RefinementSolver.run(contextProvider.get(), proverProvider.get(),
				RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
	}
}