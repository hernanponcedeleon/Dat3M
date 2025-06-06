package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.*;
import static com.dat3m.dartagnan.configuration.OptionNames.MIXED_SIZE;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class MixedTest extends AbstractCTest {

    public MixedTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("mixed/" + name + ".ll");
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return () -> 3;
    }

    @Override
    protected long getTimeout() {
        return 180000;
    }

    @Override
    protected Configuration getConfiguration() throws InvalidConfigurationException {
        return Configuration.builder()
                .setOption(MIXED_SIZE, "true")
                .build();
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
            {"lockref1", ARM8, PASS},
            {"lockref2", ARM8, PASS},
            {"lockref-seq", ARM8, PASS},
            {"lockref-par1", ARM8, FAIL},
            {"lockref-par2", ARM8, PASS},
            {"lockref-par3", ARM8, FAIL},
            {"mixed-local1", ARM8, PASS},
            {"mixed-local2", ARM8, FAIL},
            {"store-to-load-forwarding1", ARM8, FAIL},
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