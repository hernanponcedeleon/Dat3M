package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;

import java.nio.file.Path;
import java.io.IOException;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class LitmusOpenClRacesTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/OPENCL/", "OPENCL", "-DR");
    }

    public LitmusOpenClRacesTest(Path path, ResultStatus expected) {
        super(Arch.OPENCL, path, expected);
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }

    @Override
    protected String getWmmName() { return "opencl"; }
}
