package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class LISA_AARCH64_Test extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/LISA/AARCH64/", "LISA");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.ARM8;
    }

    public LISA_AARCH64_Test(String path, Result expected) {
        super(path, expected);
    }
}
