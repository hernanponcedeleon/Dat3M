package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

@RunWith(Parameterized.class)
public class LitmusPPCExplorationTest extends AbstractLitmusExplorationTest {

    @Parameterized.Parameters(name = "{index}: {0}, states={1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/PPC/", "PPC");
    }

    public LitmusPPCExplorationTest(Path path, int expectedStateCount) {
        super(Arch.POWER, path, expectedStateCount);
    }

}
