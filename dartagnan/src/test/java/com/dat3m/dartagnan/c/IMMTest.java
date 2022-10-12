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
public class IMMTest extends AbstractCTest {
	
    public IMMTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + "imm/" + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Provider.fromSupplier(() -> new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/imm.cat")));
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
    	return Arrays.asList(new Object[][]{
	            {"paper-E3.1", IMM, PASS},
	            {"paper-E3.2", IMM, PASS},
	            {"paper-E3.3", IMM, PASS},
	            {"paper-E3.4", IMM, PASS},
	            {"paper-E3.5", IMM, PASS},
	            {"paper-E3.6", IMM, FAIL},
	            {"paper-E3.7", IMM, PASS},
	            {"paper-E3.8", IMM, PASS},
	            {"paper-E3.8-alt", IMM, FAIL},
	            {"paper-E3.9", IMM, PASS},
	            // The actual example 3.10 in the paper marks the write of the FADD as strong 
	            // which forms a cycle making the result PASS. Since we currently don't have
	            // a way to mark FADD instructions as weak/strong, the behavior is allowed.
	            {"paper-E3.10", IMM, FAIL},
	            {"paper-R2", IMM, PASS},
	            {"paper-R2-alt", IMM, PASS},
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