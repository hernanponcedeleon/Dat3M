package com.dat3m.dartagnan.benchmarking.caat;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
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
public class Power extends AbstractDartagnanTest {

    public Power(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"locks/ttas-5", POWER, UNKNOWN},
            {"locks/ticketlock-6", POWER, PASS},
            {"locks/mutex-4", POWER, UNKNOWN},
            {"locks/spinlock-5", POWER, UNKNOWN},
            {"locks/linuxrwlock-3", POWER, UNKNOWN},
            {"locks/mutex_musl-4", POWER, UNKNOWN},
            {"lfds/safe_stack-3", POWER, FAIL},
            {"lfds/chase-lev-5", POWER, PASS},
            {"lfds/dglm-3", POWER, UNKNOWN},
            {"lfds/harris-3", POWER, UNKNOWN},
            {"lfds/ms-3", POWER, UNKNOWN},
            {"lfds/treiber-3", POWER, UNKNOWN},
		});
    }

	@Test
	@CSVLogger.FileName("csv/caat")
	public void testRefinement() throws Exception {
		RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
		assertEquals(expected, s.getResult());
	}
}