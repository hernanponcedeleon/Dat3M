package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Property;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class C11AndOpenCLRaceTest extends C11AndOpenCLTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/OPENCL/portedFromC11/");
    }

    public C11AndOpenCLRaceTest(Path path) {
        super(path);
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}
