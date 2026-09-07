package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusPTXv7_5LivenessTest extends AbstractLitmusTest {

    public LitmusPTXv7_5LivenessTest(Path path, ResultStatus expected) {
        super(Arch.PTX, path, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/PTX/", "PTXv7_5-Liveness");
    }

    @Override
    protected Property getTestedProperty() { return Property.TERMINATION; }

    @Override
    protected String getWmmName() { return "ptx-v7.5"; }
}
