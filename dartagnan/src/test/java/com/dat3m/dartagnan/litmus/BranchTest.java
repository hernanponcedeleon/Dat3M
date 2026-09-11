package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.google.common.collect.ImmutableMap;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;

@RunWith(Parameterized.class)
public class BranchTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        final Path expectedPath = ResourceHelper.getTestResourcePath("branch/expected.csv");
        final ImmutableMap<Path, ResultStatus> expected = ResourceHelper.parseExpectedResults(expectedPath,
                ResourceHelper::getTestResourcePath);
        return buildLitmusTests(getTestResourcePath("branch/"), expected::get);
    }

    public BranchTest(Path path, ResultStatus expected) {
        super(Arch.LKMM, path, expected);
    }

    @Override
    protected long getTimeoutSeconds() { return 1; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() { return super.getTaskBuilder().withSolverTimeout(60); }

    @Override
    protected String getTargetWmmName() {
        return programPath.getParent().getFileName().toString().equals("AARCH64") ? "aarch64" : null;
    }
}
