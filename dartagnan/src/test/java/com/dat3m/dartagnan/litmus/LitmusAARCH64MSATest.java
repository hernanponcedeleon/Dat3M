package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runners.Parameterized;

import java.io.IOException;

public class LitmusAARCH64MSATest extends LitmusAARCH64Test {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("local/mixedsizetests", "ARM8", "-herd");
    }

    public LitmusAARCH64MSATest(String path, Result expected) {
        super(path, expected);
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "aarch64_diy");
    }

    @Override
    protected long getTimeout() {
        return 10_000L;
    }
}
