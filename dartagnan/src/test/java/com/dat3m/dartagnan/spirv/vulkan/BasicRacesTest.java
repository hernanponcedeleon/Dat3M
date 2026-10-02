package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.verification.VerificationStatus.PASS;

@RunWith(Parameterized.class)
public class BasicRacesTest extends AbstractSpirvVulkanTest {

    public BasicRacesTest(String file, VerificationStatus expected) {
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
