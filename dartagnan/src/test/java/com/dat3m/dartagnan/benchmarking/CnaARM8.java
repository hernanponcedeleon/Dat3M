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
public class CnaARM8 extends AbstractCTest {

    public CnaARM8(String name, Arch target, Result expected) {
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
                {"locks/cna-4", ARM8, PASS},
                {"locks/cna-4-rel2rx_unlock1", ARM8, FAIL},
                {"locks/cna-4-rel2rx_unlock2", ARM8, FAIL},
                {"locks/cna-4-rel2rx_unlock3", ARM8, FAIL},
                {"locks/cna-4-rel2rx_unlock4", ARM8, FAIL},
                {"locks/cna-4-rel2rx_lock", ARM8, PASS},
                {"locks/cna-4-acq2rx_lock", ARM8, FAIL},
                {"locks/cna-4-acq2rx_unlock", ARM8, PASS},
                {"locks/cna-4-acq2rx_succ1", ARM8, PASS},
                {"locks/cna-4-acq2rx_succ2", ARM8, PASS},
		});
    }

	@Test
	@CSVLogger.FileName("csv/assume")
	public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
		assertEquals(expected, s.getResult());
	}

	@Test
	@CSVLogger.FileName("csv/refinement")
	public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
	}
}