package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusLinuxRacesTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/LKMM/", "LKMM", "-DR");
    }

    public LitmusLinuxRacesTest(Path path, ResultStatus expected) {
        super(Arch.LKMM, path, expected);
    }

    @Override
    protected String getTargetWmmName() { return "linux-kernel"; }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }

    @Override
    protected boolean isLazyMethodEnabled() {
        // FIXME: ArrayIndexOutOfBoundsException in indexedDomain.full().iterator().
        return !programPath.endsWith("dart/no-herd/C-bool-const-01.litmus")
                && !programPath.endsWith("dart/no-herd/C-bool-const-02.litmus");
    }
}
