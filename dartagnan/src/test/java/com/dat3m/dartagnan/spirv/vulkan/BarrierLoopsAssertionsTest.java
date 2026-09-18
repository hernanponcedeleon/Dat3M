package com.dat3m.dartagnan.spirv.vulkan;

import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class BarrierLoopsAssertionsTest extends AbstractSpirvVulkanTest {

    public BarrierLoopsAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/vulkan/barrier/loops/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"barrier-loop-1-forall.spvasm", 3, PASS},
                {"barrier-loop-1-exists.spvasm", 3, PASS},
                {"barrier-no-loop-1-forall.spvasm", 1, PASS},
                {"barrier-no-loop-1-exists.spvasm", 1, PASS},

                {"barrier-loop-2-forall.spvasm", 2, PASS},
                {"barrier-loop-2-exists.spvasm", 2, PASS},
                {"barrier-no-loop-2-forall.spvasm", 1, PASS},
                {"barrier-no-loop-2-exists.spvasm", 1, PASS},

                {"barrier-loop-3-forall.spvasm", 2, PASS},
                {"barrier-loop-3-exists.spvasm", 2, PASS},
                {"barrier-no-loop-3-forall.spvasm", 1, PASS},
                {"barrier-no-loop-3-exists.spvasm", 1, PASS},

                {"barrier-loop-4-forall.spvasm", 2, PASS},
                {"barrier-loop-4-exists.spvasm", 2, FAIL},
                {"barrier-no-loop-4-forall.spvasm", 1, PASS},
                {"barrier-no-loop-4-exists.spvasm", 1, FAIL},

                {"barrier-loop-5-forall.spvasm", 2, FAIL},
                {"barrier-loop-5-exists.spvasm", 2, PASS},
                {"barrier-no-loop-5-forall.spvasm", 1, FAIL},
                {"barrier-no-loop-5-exists.spvasm", 1, PASS},

                {"barrier-loop-6-forall.spvasm", 2, FAIL},
                {"barrier-loop-6-exists.spvasm", 2, PASS},
                {"barrier-no-loop-6-forall.spvasm", 1, FAIL},
                {"barrier-no-loop-6-exists.spvasm", 1, PASS},
        });
    }
}
