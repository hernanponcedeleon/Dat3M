package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Path;

@RunWith(Parameterized.class)
public class LitmusVulkanNewRacesTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN", "-New-Races");
    }

    public LitmusVulkanNewRacesTest(Path path, VerificationStatus expected) {
        super(Arch.VULKAN, path, expected);
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }

    @Override
    protected String getTargetWmmName() { return "vulkan-new"; }
}
