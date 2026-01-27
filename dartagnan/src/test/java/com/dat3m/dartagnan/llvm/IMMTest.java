package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

@RunWith(Parameterized.class)
public class IMMTest extends AbstractCTest {

    public IMMTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("imm/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromArch(() -> IMM);
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
                {"paper-E3.10", IMM, PASS},
                {"paper-R2", IMM, PASS},
                // IMM from the paper returns PASS in the test below.
                // But since we follow the sw definition of RC11, the
                // expected result is FAIL (confirmed by genMC) 
                {"paper-R2-alt", IMM, FAIL},
        });
    }

    @Test
    public void testAssume() throws Exception {
        testModelChecker(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testModelChecker(Method.LAZY);
    }
}