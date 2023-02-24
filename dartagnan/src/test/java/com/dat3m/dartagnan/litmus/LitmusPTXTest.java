package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusPTXTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/PTX/", "PTX");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.PTX;
    }

    public LitmusPTXTest(String path, Result expected) {
        super(path, expected);
    }
}
