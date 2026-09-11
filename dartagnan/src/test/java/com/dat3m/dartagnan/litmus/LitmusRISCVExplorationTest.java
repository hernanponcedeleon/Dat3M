package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

@RunWith(Parameterized.class)
public class LitmusRISCVExplorationTest extends AbstractLitmusExplorationTest {

    @Parameterized.Parameters(name = "{index}: {0}, states={1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusExplorationTests("litmus/RISCV/", "RISCV");
    }

    public LitmusRISCVExplorationTest(Path path, int expectedStateCount) {
        super(path, expectedStateCount);
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.RISCV;
    }
}
