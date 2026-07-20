package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class LFDSTest extends AbstractCTest {

    public LFDSTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("lfds/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 1500000;
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> 2;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"dglm", TSO, BOUNDED},
                {"dglm", ARM8, BOUNDED},
                {"dglm", POWER, BOUNDED},
                {"dglm", RISCV, BOUNDED},
                {"dglm-CAS-relaxed", TSO, BOUNDED},
                {"dglm-CAS-relaxed", ARM8, FAIL},
                {"dglm-CAS-relaxed", POWER, FAIL},
                {"dglm-CAS-relaxed", RISCV, FAIL},
                {"ms", TSO, BOUNDED},
                {"ms", ARM8, BOUNDED},
                {"ms", POWER, BOUNDED},
                {"ms", RISCV, BOUNDED},
                {"ms-CAS-relaxed", TSO, BOUNDED},
                {"ms-CAS-relaxed", ARM8, FAIL},
                {"ms-CAS-relaxed", POWER, FAIL},
                {"ms-CAS-relaxed", RISCV, FAIL},
                {"treiber", TSO, BOUNDED},
                {"treiber", ARM8, BOUNDED},
                {"treiber", POWER, BOUNDED},
                {"treiber", RISCV, BOUNDED},
                {"treiber-CAS-relaxed", TSO, BOUNDED},
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

    // @Test
    public void testAssume() throws Exception {
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testSolver(Method.LAZY);
    }
}