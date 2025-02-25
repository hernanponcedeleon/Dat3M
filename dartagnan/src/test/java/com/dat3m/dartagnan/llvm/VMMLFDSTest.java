package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class VMMLFDSTest extends AbstractCTest {

    public VMMLFDSTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Configuration getConfiguration() throws InvalidConfigurationException {
        return Configuration.defaultConfiguration();
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath("lfds/" + name + ".ll");
    }

    @Override
    protected long getTimeout() {
        return 600000;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return () -> EnumSet.of(PROGRAM_SPEC, LIVENESS, CAT_SPEC);
    }

    @Override
    protected Provider<Integer> getBoundProvider() {
        return () -> 2;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "vmm");
    }

    @Override
    protected Provider<Solvers> getSolverProvider() {
        return () -> Solvers.YICES2;
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"dglm", C11, UNKNOWN},
                {"dglm-CAS-relaxed", C11, FAIL},
                {"ms", C11, UNKNOWN},
                {"ms-CAS-relaxed", C11, FAIL},
                {"treiber", C11, UNKNOWN},
                {"treiber-CAS-relaxed", C11, FAIL},
                {"chase-lev", C11, PASS},
                // These have an extra thief that violate the assertion
                {"chase-lev-fail", C11, FAIL},
                {"hash_table", C11, PASS},
                {"hash_table-fail", C11, FAIL},
        });
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}