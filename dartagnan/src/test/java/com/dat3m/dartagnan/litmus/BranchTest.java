package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
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
    protected String getTargetWmmName() {
        return programPath.getParent().getFileName().toString().equals("AARCH64") ? "aarch64" : null;
    }

    @Override
    protected boolean isLazyMethodEnabled() {
        // FIXME: ArrayIndexOutOfBoundsException in indexedDomain.full().iterator()
        return !programPath.endsWith("C/C-branch-18.litmus");
    }
}
