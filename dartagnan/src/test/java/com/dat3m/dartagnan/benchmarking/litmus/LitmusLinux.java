package com.dat3m.dartagnan.benchmarking.litmus;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusLinux extends AbstractLitmus {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
		return buildLitmusTests("litmus/LKMM/", "LKMM-NDR");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.LKMM;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "lkmm-no-data-race");
    }

    public LitmusLinux(String path, String arch, Result expected) {
        super(path, arch, expected);
    }
}
