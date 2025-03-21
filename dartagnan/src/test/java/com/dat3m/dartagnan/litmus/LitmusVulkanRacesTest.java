package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.EnumSet;

@RunWith(Parameterized.class)
public class LitmusVulkanRacesTest extends AbstractLitmusTest {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/VULKAN/", "VULKAN", "-DR");
    }

    @Override
    protected Provider<Arch> getTargetProvider() {
        return () -> Arch.VULKAN;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.CAT_SPEC));
    }

    public LitmusVulkanRacesTest(String path, Result expected) {
        super(path, expected);
    }
}
