package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CLocksTest extends AbstractCTest {

    public CLocksTest(String name, Arch target, Result expected) {
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
	            {"ttas-5", ARM8, UNKNOWN},
	            {"ttas-5", POWER, UNKNOWN},
	            {"ttas-5-acq2rx", TSO, UNKNOWN},
	            {"ttas-5-acq2rx", ARM8, UNKNOWN},
	            {"ttas-5-acq2rx", POWER, UNKNOWN},
	            {"ttas-5-rel2rx", TSO, UNKNOWN},
	            {"ttas-5-rel2rx", ARM8, FAIL},
	            {"ttas-5-rel2rx", POWER, FAIL},
	            {"ticketlock-3", TSO, UNKNOWN},
	            {"ticketlock-3", ARM8, UNKNOWN},
	            {"ticketlock-3", POWER, UNKNOWN},
	            {"ticketlock-3-acq2rx", TSO, UNKNOWN},
	            {"ticketlock-3-acq2rx", ARM8, UNKNOWN},
	            {"ticketlock-3-acq2rx", POWER, UNKNOWN},
	            {"ticketlock-3-rel2rx", TSO, UNKNOWN},
	            {"ticketlock-3-rel2rx", ARM8, FAIL},
	            {"ticketlock-3-rel2rx", POWER, FAIL},
                {"mutex-3", TSO, UNKNOWN},
                {"mutex-3", ARM8, UNKNOWN},
                {"mutex-3", POWER, UNKNOWN},
                {"mutex-3-acq2rx_futex", TSO, UNKNOWN},
                {"mutex-3-acq2rx_futex", ARM8, UNKNOWN},
                {"mutex-3-acq2rx_futex", POWER, UNKNOWN},
                {"mutex-3-acq2rx_lock", TSO, UNKNOWN},
                {"mutex-3-acq2rx_lock", ARM8, UNKNOWN},
                {"mutex-3-acq2rx_lock", POWER, UNKNOWN},
                {"mutex-3-rel2rx_futex", TSO, UNKNOWN},
                {"mutex-3-rel2rx_futex", ARM8, UNKNOWN},
                {"mutex-3-rel2rx_futex", POWER, UNKNOWN},
                {"mutex-3-rel2rx_unlock", TSO, UNKNOWN},
                {"mutex-3-rel2rx_unlock", ARM8, FAIL},
                {"mutex-3-rel2rx_unlock", POWER, FAIL},
                {"spinlock-5", TSO, UNKNOWN},
                {"spinlock-5", ARM8, UNKNOWN},
                {"spinlock-5", POWER, UNKNOWN},
                {"spinlock-5-acq2rx", TSO, UNKNOWN},
                {"spinlock-5-acq2rx", ARM8, UNKNOWN},
                {"spinlock-5-acq2rx", POWER, UNKNOWN},
                {"spinlock-5-rel2rx", TSO, UNKNOWN},
                {"spinlock-5-rel2rx", ARM8, FAIL},
                {"spinlock-5-rel2rx", POWER, FAIL},
                {"linuxrwlock-3", TSO, UNKNOWN},
                {"linuxrwlock-3", ARM8, UNKNOWN},
                {"linuxrwlock-3", POWER, UNKNOWN},
                {"linuxrwlock-3-acq2rx", TSO, UNKNOWN},
                {"linuxrwlock-3-acq2rx", ARM8, FAIL},
                {"linuxrwlock-3-acq2rx", POWER, FAIL},
                {"linuxrwlock-3-rel2rx", TSO, UNKNOWN},
                {"linuxrwlock-3-rel2rx", ARM8, FAIL},
                {"linuxrwlock-3-rel2rx", POWER, FAIL},
                {"mutex_musl-3", TSO, UNKNOWN},
                {"mutex_musl-3", ARM8, UNKNOWN},
                {"mutex_musl-3", POWER, UNKNOWN},
                {"mutex_musl-3-acq2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx_futex", ARM8, UNKNOWN},
                {"mutex_musl-3-acq2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-3-acq2rx_lock", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx_lock", ARM8, UNKNOWN},
                {"mutex_musl-3-acq2rx_lock", POWER, UNKNOWN},
                {"mutex_musl-3-rel2rx_futex", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx_futex", ARM8, UNKNOWN},
                {"mutex_musl-3-rel2rx_futex", POWER, UNKNOWN},
                {"mutex_musl-3-rel2rx_unlock", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx_unlock", ARM8, FAIL},
                {"mutex_musl-3-rel2rx_unlock", POWER, FAIL}
        });
    }

	@Test
	@CSVLogger.FileName("csv/assume")
	public void testAssume() throws Exception {
		assertEquals(expected, runAnalysisAssumeSolver(contextProvider.get(), proverProvider.get(), taskProvider.get()));
	}

	//@Test
	@CSVLogger.FileName("csv/refinement")
	public void testRefinement() throws Exception {
		assertEquals(expected, Refinement.runAnalysisSaturationSolver(contextProvider.get(), proverProvider.get(),
				RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
	}
}