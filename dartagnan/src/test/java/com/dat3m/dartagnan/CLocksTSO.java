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
public class CLocksTSO extends AbstractCTest {

    public CLocksTSO(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "locks/" + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
	            {"ttas-5", TSO, UNKNOWN},
	            {"ttas-5-acq2rx", TSO, UNKNOWN},
	            {"ttas-5-rel2rx", TSO, UNKNOWN},
	            {"ticketlock-3", TSO, PASS},
	            {"ticketlock-3-acq2rx", TSO, PASS},
	            {"ticketlock-3-rel2rx", TSO, PASS},
                {"mutex-3", TSO, UNKNOWN},
                {"mutex-3-acq2rx_futex", TSO, UNKNOWN},
                {"mutex-3-acq2rx_lock", TSO, UNKNOWN},
                {"mutex-3-rel2rx_futex", TSO, UNKNOWN},
                {"mutex-3-rel2rx_unlock", TSO, UNKNOWN},
                {"spinlock-5", TSO, UNKNOWN},
                {"spinlock-5-acq2rx", TSO, UNKNOWN},
                {"spinlock-5-rel2rx", TSO, UNKNOWN},
                {"linuxrwlock-3", TSO, UNKNOWN},
                {"linuxrwlock-3-acq2rx", TSO, UNKNOWN},
                {"linuxrwlock-3-rel2rx", TSO, UNKNOWN},
                {"mutex_musl-3", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx_lock", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx_unlock", TSO, UNKNOWN},
//                {"cna-4", TSO, UNKNOWN},
//                {"cna-4-rel2rx_unlock1", TSO, UNKNOWN},
//                {"cna-4-rel2rx_unlock2", TSO, UNKNOWN},
//                {"cna-4-rel2rx_unlock3", TSO, UNKNOWN},
//                {"cna-4-rel2rx_unlock4", TSO, UNKNOWN},
//                {"cna-4-rel2rx_lock", TSO, UNKNOWN},
//                {"cna-4-acq2rx_lock", TSO, UNKNOWN},
//                {"cna-4-acq2rx_unlock", TSO, UNKNOWN},
//                {"cna-4-acq2rx_succ1", TSO, UNKNOWN},
//                {"cna-4-acq2rx_succ2", TSO, UNKNOWN},
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