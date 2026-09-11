package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusPTXv7_5Test extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/PTX/", "PTXv7_5");
    }

    public LitmusPTXv7_5Test(Path path, ResultStatus expected) {
        super(Arch.PTX, path, expected);
    }

    @Override
    protected String getTargetWmmName() { return "ptx-v7.5"; }
}
