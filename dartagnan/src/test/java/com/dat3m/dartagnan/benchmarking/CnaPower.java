package com.dat3m.dartagnan.benchmarking;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.c.AbstractCTest;
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
public class CnaPower extends AbstractCTest {

    public CnaPower(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return Provider.fromSupplier(() -> 4);
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
                {"locks/cna-4", POWER, PASS},
                {"locks/cna-4-rel2rx_unlock1", POWER, PASS},
                {"locks/cna-4-rel2rx_unlock2", POWER, FAIL},
                {"locks/cna-4-rel2rx_unlock3", POWER, FAIL},
                {"locks/cna-4-rel2rx_unlock4", POWER, FAIL},
                {"locks/cna-4-rel2rx_lock", POWER, PASS},
                {"locks/cna-4-acq2rx_lock", POWER, FAIL},
                {"locks/cna-4-acq2rx_unlock", POWER, PASS},
                {"locks/cna-4-acq2rx_succ1", POWER, PASS},
                {"locks/cna-4-acq2rx_succ2", POWER, PASS}
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