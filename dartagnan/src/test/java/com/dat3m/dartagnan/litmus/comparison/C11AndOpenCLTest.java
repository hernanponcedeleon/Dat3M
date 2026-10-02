package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class C11AndOpenCLTest extends AbstractComparisonTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/OPENCL/portedFromC11/");
    }

    public C11AndOpenCLTest(Path path) {
        super(Arch.C11, Arch.OPENCL, path);
    }

    @Override
    protected String getSourceWmmName() { return "c11"; }

    @Override
    protected String getTargetWmmName() { return "opencl"; }
}
