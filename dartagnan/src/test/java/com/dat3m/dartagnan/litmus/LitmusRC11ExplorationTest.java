package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

@RunWith(Parameterized.class)
public class LitmusRC11ExplorationTest extends AbstractLitmusExplorationTest {

    @Parameterized.Parameters(name = "{index}: {0}, states={1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/", "RC11");
    }

    public LitmusRC11ExplorationTest(Path path, int expectedStateCount) {
        super(Arch.C11, path, expectedStateCount);
    }

    @Override
    protected String getTargetWmmName() {
        return "rc11";
    }
}
