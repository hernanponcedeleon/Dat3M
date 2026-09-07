package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusVulkanAssertionsChainsTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN", "-Assertions-Chains");
    }

    public LitmusVulkanAssertionsChainsTest(Path path, ResultStatus expected) {
        super(Arch.VULKAN, path, expected);
    }

    @Override
    protected String getWmmName() { return "vulkan-chains"; }
}
