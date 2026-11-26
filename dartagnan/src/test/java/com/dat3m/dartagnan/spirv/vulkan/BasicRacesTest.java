package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.task.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.PASS;

@RunWith(Parameterized.class)
public class BasicRacesTest extends AbstractSpirvVulkanTest {

    public BasicRacesTest(String model, String file, VerificationStatus expected) {
        super(model, "spirv/vulkan/basic/" + file, 1, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return withModels(new Object[][]{
                {"idx-overflow.spvasm", PASS},
                {"unreachable-3.1.1.spvasm", FAIL},
                {"unreachable-2.1.1.spvasm", PASS}
        });
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}
