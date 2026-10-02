package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

import java.nio.file.Path;

import static com.dat3m.dartagnan.configuration.OptionNames.USE_RC11_TO_ARCH_SCHEME;

@RunWith(Parameterized.class)
public class RC11ToRISCVTest extends AbstractCompilationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/C11/");
    }

    public RC11ToRISCVTest(Path path) {
        super(Arch.C11, Arch.RISCV, path);
    }

    @Override
    protected String getSourceWmmName() { return "rc11"; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder().withOption(USE_RC11_TO_ARCH_SCHEME, "true");
    }
}
