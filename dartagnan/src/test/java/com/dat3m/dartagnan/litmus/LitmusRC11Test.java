package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusRC11Test extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/", "RC11");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.C11;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
    }

    public LitmusRC11Test(String path, Result expected) {
        super(path, expected);
    }
}
