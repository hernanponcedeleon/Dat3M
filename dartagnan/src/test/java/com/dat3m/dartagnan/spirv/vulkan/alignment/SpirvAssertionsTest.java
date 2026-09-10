package com.dat3m.dartagnan.spirv.vulkan.alignment;

import com.dat3m.dartagnan.spirv.vulkan.AbstractSpirvVulkanTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvVulkanTest {

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/vulkan/alignment/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                // Compiler changes type to match alignment
                {"alignment1-array-local.spvasm", 9, PASS},
                {"alignment1-array-pointer.spvasm", 9, PASS},
                {"alignment1-struct-local.spvasm", 9, PASS},
                {"alignment1-struct-pointer.spvasm", 9, PASS},
                {"alignment2-struct-local.spvasm", 17, PASS},
                {"alignment2-struct-pointer.spvasm", 17, PASS},
                {"alignment3-struct-local.spvasm", 9, PASS},
                {"alignment3-struct-pointer.spvasm", 9, PASS},
                {"alignment4-struct-local.spvasm", 25, PASS},
                {"alignment4-struct-pointer.spvasm", 25, PASS},
                {"alignment5-struct-local.spvasm", 17, PASS},
                {"alignment5-struct-pointer.spvasm", 17, PASS},

                // Manual tests with stride greater than element size
                {"array-stride-array-initializer.spvasm", 9, PASS},
                {"array-stride-array-input.spvasm", 9, PASS},
                {"array-stride-array-overwrite-scalar.spvasm", 9, PASS},
                {"array-stride-array-overwrite-vector.spvasm", 9, PASS},
                {"array-stride-runtime-array-input.spvasm", 9, PASS},
                {"array-stride-runtime-array-overwrite-scalar.spvasm", 9, PASS},
                {"array-stride-runtime-array-overwrite-vector.spvasm", 9, PASS},
                {"pointer-stride-array-overwrite-scalar.spvasm", 9, PASS},
                {"pointer-stride-array-overwrite-vector.spvasm", 9, PASS},
                {"stride-scalar-overwrite-result-no-stride.spvasm", 17, PASS},
                {"stride-scalar-overwrite-result-stride.spvasm", 17, PASS},
                {"stride-vector-overwrite-result-no-stride.spvasm", 17, PASS},
                {"stride-vector-overwrite-result-stride.spvasm", 17, PASS},
        });
    }
}
