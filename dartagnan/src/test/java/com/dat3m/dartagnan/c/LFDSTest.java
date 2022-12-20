package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
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
public class LFDSTest extends AbstractCTest {

    public LFDSTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "lfds/" + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 600000;
    }

    protected Provider<Integer> getBoundProvider() {
        return Provider.fromSupplier(() -> 2);
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
            {"dglm", TSO, UNKNOWN},
            {"dglm", ARM8, UNKNOWN},
            {"dglm", POWER, UNKNOWN},
            {"dglm", RISCV, UNKNOWN},
            {"dglm-CAS-relaxed", TSO, UNKNOWN},
            {"dglm-CAS-relaxed", ARM8, FAIL},
            {"dglm-CAS-relaxed", POWER, FAIL},
            {"dglm-CAS-relaxed", RISCV, FAIL},
            {"ms", TSO, UNKNOWN},
            {"ms", ARM8, UNKNOWN},
            {"ms", POWER, UNKNOWN},
            {"ms", RISCV, UNKNOWN},
            {"ms-CAS-relaxed", TSO, UNKNOWN},
            {"ms-CAS-relaxed", ARM8, FAIL},
            {"ms-CAS-relaxed", POWER, FAIL},
            {"ms-CAS-relaxed", RISCV, FAIL},
            {"treiber", TSO, UNKNOWN},
            {"treiber", ARM8, UNKNOWN},
            {"treiber", POWER, UNKNOWN},
            {"treiber", RISCV, UNKNOWN},
            {"treiber-CAS-relaxed", TSO, UNKNOWN},
            {"treiber-CAS-relaxed", ARM8, FAIL},
            {"treiber-CAS-relaxed", POWER, FAIL},
            {"treiber-CAS-relaxed", RISCV, FAIL},
            {"chase-lev", TSO, PASS},
            {"chase-lev", ARM8, PASS},
            {"chase-lev", POWER, PASS},
            {"chase-lev", RISCV, PASS},
            // These ones have an extra thief that violate the assertion
            {"chase-lev-fail", TSO, FAIL},
            {"chase-lev-fail", ARM8, FAIL},
            {"chase-lev-fail", POWER, FAIL},
            {"chase-lev-fail", RISCV, FAIL},
        });
    }

	//@Test
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