package com.dat3m.dartagnan.spirv.vulkan.barrier.scope;

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

    public SpirvRacesTest(String file, int bound, ResultStatus expected) {
        super("spirv/vulkan/barrier/scope/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"barrier-inscope-sg.spvasm", 1, PASS},
                {"barrier-inscope-wg.spvasm", 1, PASS},
                {"barrier-not-inscope-sg.spvasm", 1, FAIL},
                {"barrier-not-inscope-wg.spvasm", 1, FAIL},
        });
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}
