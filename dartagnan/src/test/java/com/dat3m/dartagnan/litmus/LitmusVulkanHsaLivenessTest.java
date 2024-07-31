package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import static com.dat3m.dartagnan.configuration.OptionNames.PROGRESSMODEL;

import java.io.IOException;
import java.util.EnumSet;

@RunWith(Parameterized.class)
public class LitmusVulkanHsaLivenessTest extends AbstractLitmusTest {

    public LitmusVulkanHsaLivenessTest(String path, Result expected) {
        super(path, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN-Liveness-HSA");
    }

    @Override
    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.builder()
                .setOption(PROGRESSMODEL, "hsa")
                .build());
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.VULKAN;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.LIVENESS));
    }
}
