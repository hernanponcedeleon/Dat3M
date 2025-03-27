package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.USE_RC11_TO_ARCH_SCHEME;

@RunWith(Parameterized.class)
public class RC11ToRISCVTest extends AbstractCompilationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public RC11ToRISCVTest(String path) {
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
        return () -> Arch.RISCV;
    }

    @Override
    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.builder().
                setOption(INITIALIZE_REGISTERS, String.valueOf(true)).
                setOption(USE_RC11_TO_ARCH_SCHEME, String.valueOf(true)).
                build());
    }
}
