package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

import static com.dat3m.dartagnan.configuration.OptionNames.MIXED_SIZE;

@RunWith(Parameterized.class)
public class LitmusAARCH64Test extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/AARCH64/", "ARM8");
    }

    public LitmusAARCH64Test(Path path, ResultStatus expected) {
        super(Arch.ARM8, path, expected);
    }

    @Override
    protected long getTimeoutSeconds() { return 60; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        final boolean isMixedSize = Utils.containsSubpath(programPath, Path.of("litmus", "AARCH64", "mixed"));
        return super.getTaskBuilder().withOption(MIXED_SIZE, String.valueOf(isMixedSize));
    }
}
