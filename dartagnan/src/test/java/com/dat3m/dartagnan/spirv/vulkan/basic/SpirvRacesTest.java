package com.dat3m.dartagnan.spirv.vulkan.basic;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.spirv.vulkan.AbstractSpirvVulkanTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvRacesTest extends AbstractSpirvVulkanTest {

    public SpirvRacesTest(String file, ResultStatus expected) {
        super("spirv/vulkan/basic/" + file, 1, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"idx-overflow.spvasm", PASS},
                {"unreachable-3.1.1.spvasm", FAIL},
                {"unreachable-2.1.1.spvasm", PASS}
        });
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}
