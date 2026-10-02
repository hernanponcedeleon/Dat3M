package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class C11ToTSOTest extends AbstractCompilationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public C11ToTSOTest(Path path) {
        super(Arch.C11, Arch.TSO, path);
    }

    @Override
    protected String getSourceWmmName() { return "c11"; }
}
