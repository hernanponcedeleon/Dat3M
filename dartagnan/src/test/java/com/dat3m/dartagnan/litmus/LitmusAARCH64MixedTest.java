package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

public class LitmusAARCH64MixedTest extends LitmusAARCH64Test {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/AARCH64-MIXED", "ARM8", "-MIXED");
    }

    public LitmusAARCH64MixedTest(String path, Result expected) {
        super(path, expected);
    }

    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.builder()
                .setOption(INITIALIZE_REGISTERS, "true")
                .setOption(USE_INTEGERS, "false")
                .setOption(MIXED_SIZE, "true")
                .build());
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "aarch64-mixed");
    }
}
