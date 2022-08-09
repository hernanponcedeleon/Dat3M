package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.configuration.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class RC11LocksTest extends AbstractCTest {
	
	// We use this for a fast CI.
	// For benchmarking we use CLocksTest{TSO, ARM, Power}
	// which use higher bounds and more threads
	
    public RC11LocksTest(String name, Arch target, Result expected) {
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

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/rc11.cat")));
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
    	return Arrays.asList(new Object[][]{
	            {"ttas-5", C11, UNKNOWN},
	            {"ttas-5-acq2rx", C11, FAIL},
	            {"ttas-5-rel2rx", C11, FAIL},
	            {"ticketlock-3", C11, PASS},
	            {"ticketlock-3-acq2rx", C11, FAIL},
	            {"ticketlock-3-rel2rx", C11, FAIL},
                {"mutex-3", C11, UNKNOWN},
                {"mutex-3-acq2rx_futex", C11, UNKNOWN},
                {"mutex-3-acq2rx_lock", C11, FAIL},
                {"mutex-3-rel2rx_futex", C11, UNKNOWN},
                {"mutex-3-rel2rx_unlock", C11, FAIL},
                {"spinlock-5", C11, UNKNOWN},
                {"spinlock-5-acq2rx", C11, FAIL},
                {"spinlock-5-rel2rx", C11, FAIL},
                {"linuxrwlock-3", C11, UNKNOWN},
                {"linuxrwlock-3-acq2rx", C11, FAIL},
                {"linuxrwlock-3-rel2rx", C11, FAIL},
                {"mutex_musl-3", C11, UNKNOWN},
                {"mutex_musl-3-acq2rx_futex", C11, UNKNOWN},
                {"mutex_musl-3-acq2rx_lock", C11, FAIL},
                {"mutex_musl-3-rel2rx_futex", C11, UNKNOWN},
                {"mutex_musl-3-rel2rx_unlock", C11, FAIL},
                {"seqlock-6", C11, UNKNOWN},
		});
    }

//    @Test
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