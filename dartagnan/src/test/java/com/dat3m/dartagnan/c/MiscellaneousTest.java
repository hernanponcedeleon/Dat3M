package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.ARM8;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class MiscellaneousTest extends AbstractCTest {

    public MiscellaneousTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "miscellaneous/" + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
    	return Arrays.asList(new Object[][]{
	            {"idd_dynamic", ARM8, FAIL},
		});
    }

    @Test
	public void testAssume() throws Exception {
		AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
		assertEquals(expected, s.getResult());
	}

    @Test
	public void testRefinement() throws Exception {
		RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
		assertEquals(expected, s.getResult());
	}
}