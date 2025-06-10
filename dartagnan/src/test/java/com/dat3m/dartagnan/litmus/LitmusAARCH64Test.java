package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@RunWith(Parameterized.class)
public class LitmusAARCH64Test extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/AARCH64/", "ARM8");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.ARM8;
    }

    public LitmusAARCH64Test(String path, Result expected) {
        super(path, expected);
    }

    @Override
    protected long getTimeout() {
        return 60_000;
    }

    @Override
    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.builder()
                .setOption(INITIALIZE_REGISTERS, "true")
                .setOption(USE_INTEGERS, "false")
                .setOption(MIXED_SIZE, String.valueOf(filePathProvider.get().contains("litmus/AARCH64/mixed/")))
                .build());
    }
}
