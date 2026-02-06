package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.ConfigurationBuilder;

import java.io.IOException;

import static com.dat3m.dartagnan.configuration.OptionNames.USE_RC11_TO_ARCH_SCHEME;

@RunWith(Parameterized.class)
public class RC11ToAarch64Test extends AbstractCompilationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public RC11ToAarch64Test(String path) {
        super(path);
    }

    @Override
    protected Provider<Arch> getSourceProvider() {
        return () -> Arch.C11;
    }

    @Override
    protected Provider<Wmm> getSourceWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.ARM8;
    }

    @Override
    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        return builder.setOption(USE_RC11_TO_ARCH_SCHEME, "true");
    }

}
