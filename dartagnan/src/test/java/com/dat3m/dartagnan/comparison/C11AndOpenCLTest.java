package com.dat3m.dartagnan.comparison;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class C11AndOpenCLTest extends AbstractComparisonTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public C11AndOpenCLTest(String path) {
        super(path);
    }

    @Override
    protected Provider<Arch> getSourceProvider() {
        return () -> Arch.C11;
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.OPENCL;
    }

    @Override
    protected Provider<Wmm> getSourceWmmProvider() {
        return Providers.createWmmFromName(() -> "c11");
    }

    @Override
    protected Provider<Wmm> getTargetWmmProvider() {
        return Providers.createWmmFromName(() -> "opencl-overhauling");
    }
}
