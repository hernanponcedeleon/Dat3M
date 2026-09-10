package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusPTXv6_0LivenessTest extends AbstractLitmusTest {

    public LitmusPTXv6_0LivenessTest(Path path, ResultStatus expected) {
        super(Arch.PTX, path, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/PTX/", "PTXv6_0-Liveness");
    }

    @Override
    protected Property getTestedProperty() { return Property.TERMINATION; }

    @Override
    protected String getWmmName() { return "ptx-v6.0"; }
}
