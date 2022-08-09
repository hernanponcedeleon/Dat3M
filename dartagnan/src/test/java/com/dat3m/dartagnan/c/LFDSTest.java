package com.dat3m.dartagnan.c;

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
            {"dglm-3", TSO, UNKNOWN},
            {"dglm-3", ARM8, UNKNOWN},
            {"dglm-3", POWER, UNKNOWN},
            {"dglm-3", RISCV, UNKNOWN},
            {"dglm-3-CAS-relaxed", TSO, UNKNOWN},
            {"dglm-3-CAS-relaxed", ARM8, FAIL},
            {"dglm-3-CAS-relaxed", POWER, FAIL},
            {"dglm-3-CAS-relaxed", RISCV, FAIL},
            {"ms-3", TSO, UNKNOWN},
            {"ms-3", ARM8, UNKNOWN},
            {"ms-3", POWER, UNKNOWN},
            {"ms-3", RISCV, UNKNOWN},
            {"ms-3-CAS-relaxed", TSO, UNKNOWN},
            {"ms-3-CAS-relaxed", ARM8, FAIL},
            {"ms-3-CAS-relaxed", POWER, FAIL},
            {"ms-3-CAS-relaxed", RISCV, FAIL},
            {"treiber-3", TSO, UNKNOWN},
            {"treiber-3", ARM8, UNKNOWN},
            {"treiber-3", POWER, UNKNOWN},
            {"treiber-3", RISCV, UNKNOWN},
            {"treiber-3-CAS-relaxed", TSO, UNKNOWN},
            {"treiber-3-CAS-relaxed", ARM8, FAIL},
            {"treiber-3-CAS-relaxed", POWER, FAIL},
            {"treiber-3-CAS-relaxed", RISCV, FAIL},
            {"chase-lev-5", TSO, PASS},
            {"chase-lev-5", ARM8, PASS},
            {"chase-lev-5", POWER, PASS},
            {"chase-lev-5", RISCV, PASS},
            // These ones have an extra thief that violate the assertion
            {"chase-lev-6", TSO, FAIL},
            {"chase-lev-6", ARM8, FAIL},
            {"chase-lev-6", POWER, FAIL},
            {"chase-lev-6", RISCV, FAIL},
        });
    }

	//@Test
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