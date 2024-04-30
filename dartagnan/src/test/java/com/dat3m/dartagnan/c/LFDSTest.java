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

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LFDSTest extends AbstractCTest {

    public LFDSTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("lfds/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 600000;
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> 2;
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
                // These have an extra thief that violate the assertion
                {"chase-lev-fail", TSO, FAIL},
                {"chase-lev-fail", ARM8, FAIL},
                {"chase-lev-fail", POWER, FAIL},
                {"chase-lev-fail", RISCV, FAIL},
                // These are simplified from the actual C-code in benchmarks/lfds
                // and contain fewer calls to push to improve verification time
                // We only have two instances to make the CI faster
                {"safe_stack", TSO, FAIL},
                {"safe_stack", ARM8, FAIL},
                {"hash_table", TSO, PASS},
                {"hash_table", ARM8, PASS},
                {"hash_table", POWER, PASS},
                {"hash_table", RISCV, PASS},
                // MP is correct under TSO
                {"hash_table-fail", TSO, PASS},
                {"hash_table-fail", ARM8, FAIL},
                {"hash_table-fail", POWER, FAIL},
                {"hash_table-fail", RISCV, FAIL},
        });
    }

    //@Test
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