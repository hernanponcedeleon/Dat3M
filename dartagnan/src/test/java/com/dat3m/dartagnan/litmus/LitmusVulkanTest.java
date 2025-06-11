package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.io.IOException;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@RunWith(Parameterized.class)
public class LitmusVulkanTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.VULKAN;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.PROGRAM_SPEC));
    }

    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(() -> Configuration.builder()
                .setOption(INITIALIZE_REGISTERS, "true")
                .setOption(USE_INTEGERS, "true")
                .setOption(IGNORE_FILTER_SPECIFICATION, "true")
                .build());
    }

    public LitmusVulkanTest(String path, Result expected) {
        super(path, expected);
    }
}
