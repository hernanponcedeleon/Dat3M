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
public class RC11Test extends AbstractCTest {
	
    public RC11Test(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "rc11/" + name + ".bpl");
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
	            {"2+2W", C11, PASS},
	            {"IRIW-acq-sc", C11, FAIL},
	            {"LB", C11, PASS},
	            {"LB+deps", C11, PASS},
	            {"RWC+syncs", C11, PASS},
	            {"SB", C11, PASS},
	            {"SB+rfis", C11, FAIL},
	            {"W+RWC", C11, PASS},
	            {"WWmerge", C11, FAIL},
	            {"Z6.U", C11, FAIL},
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