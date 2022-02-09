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
public class CLocksPower extends AbstractCTest {

    public CLocksPower(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "locks/" + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 300000;
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
	            {"ttas-5", POWER, UNKNOWN},
	            {"ttas-5-acq2rx", POWER, FAIL},
	            {"ttas-5-rel2rx", POWER, FAIL},
	            {"ticketlock-6", POWER, PASS},
	            {"ticketlock-6-acq2rx", POWER, FAIL},
	            {"ticketlock-6-rel2rx", POWER, FAIL},
                {"mutex-4", POWER, UNKNOWN},
                {"mutex-4-acq2rx_futex", POWER, UNKNOWN},
                {"mutex-4-acq2rx_lock", POWER, FAIL},
                {"mutex-4-rel2rx_futex", POWER, UNKNOWN},
                {"mutex-4-rel2rx_unlock", POWER, FAIL},
                {"spinlock-5", POWER, UNKNOWN},
                {"spinlock-5-acq2rx", POWER, FAIL},
                {"spinlock-5-rel2rx", POWER, FAIL},
                {"linuxrwlock-3", POWER, UNKNOWN},
                {"linuxrwlock-3-acq2rx", POWER, FAIL},
                {"linuxrwlock-3-rel2rx", POWER, FAIL},
                {"mutex_musl-4", POWER, UNKNOWN},
                {"mutex_musl-4-acq2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-4-acq2rx_lock", POWER, FAIL},
                {"mutex_musl-4-rel2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-4-rel2rx_unlock", POWER, FAIL},
//                {"cna-4", POWER, UNKNOWN},
//                // I would have expected this to be FAIL, but we report UNKNOWN
//                {"cna-4-rel2rx_unlock1", POWER, FAIL},
//                {"cna-4-rel2rx_unlock2", POWER, FAIL},
//                {"cna-4-rel2rx_unlock3", POWER, FAIL},
//                {"cna-4-rel2rx_unlock4", POWER, FAIL},
//                {"cna-4-rel2rx_lock", POWER, UNKNOWN},
//                {"cna-4-acq2rx_lock", POWER, FAIL},
//                {"cna-4-acq2rx_unlock", POWER, UNKNOWN},
//                {"cna-4-acq2rx_succ1", POWER, UNKNOWN},
//                {"cna-4-acq2rx_succ2", POWER, UNKNOWN}
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