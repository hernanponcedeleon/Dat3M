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

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;

@RunWith(Parameterized.class)
public class RC11Test extends AbstractCTest {

    public RC11Test(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("rc11/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
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
    public void testAssume() throws Exception {
        testModelChecker(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        testModelChecker(Method.LAZY);
    }
}