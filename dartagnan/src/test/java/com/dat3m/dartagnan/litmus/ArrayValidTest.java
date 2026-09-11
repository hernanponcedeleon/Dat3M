package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

@RunWith(Parameterized.class)
public class ArrayValidTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests(ResourceHelper.getTestResourcePath("arrays/ok/"), path -> ResultStatus.PASS);
    }

    public ArrayValidTest(Path path, ResultStatus expected) {
        super(Arch.LKMM, path, expected);
    }

    @Override
    protected long getTimeoutSeconds() { return 1; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() { return super.getTaskBuilder().withSolverTimeout(60); }
}
