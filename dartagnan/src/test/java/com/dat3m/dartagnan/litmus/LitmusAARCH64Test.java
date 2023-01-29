package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

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

    public LitmusAARCH64Test(String path, String arch, Result expected) {
        super(path, arch, expected);
    }

}
