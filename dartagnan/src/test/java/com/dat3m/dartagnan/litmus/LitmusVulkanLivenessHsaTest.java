package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.nio.file.Path;
import java.io.IOException;

@RunWith(Parameterized.class)
public class LitmusVulkanLivenessHsaTest extends AbstractLitmusTest {

    public LitmusVulkanLivenessHsaTest(Path path, ResultStatus expected) {
        super(Arch.VULKAN, path, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN-Liveness-HSA");
    }

    @Override
    protected ProgressModel.Hierarchy getProgressModel() { return ProgressModel.uniform(ProgressModel.HSA); }

    @Override
    protected int getBound() { return 4; }

    @Override
    protected Property getTestedProperty() { return Property.TERMINATION; }
}
