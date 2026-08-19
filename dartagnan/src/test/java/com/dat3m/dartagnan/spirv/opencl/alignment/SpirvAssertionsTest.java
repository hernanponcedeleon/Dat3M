package com.dat3m.dartagnan.spirv.opencl.alignment;

import com.dat3m.dartagnan.spirv.opencl.AbstractSpirvOpenclTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvOpenclTest {

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/opencl/alignment/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"alignment1-array-global.spvasm", 9, PASS},
                {"alignment1-array-local.spvasm", 9, PASS},
                {"alignment1-array-pointer.spvasm", 9, PASS},
                {"alignment1-struct-global.spvasm", 9, PASS},
                {"alignment1-struct-local.spvasm", 9, PASS},
                {"alignment1-struct-pointer.spvasm", 9, PASS},
                {"alignment2-struct-global.spvasm", 17, PASS},
                {"alignment2-struct-local.spvasm", 17, PASS},
                {"alignment2-struct-pointer.spvasm", 17, PASS},
                {"alignment3-struct-global.spvasm", 9, PASS},
                {"alignment3-struct-local.spvasm", 9, PASS},
                {"alignment3-struct-pointer.spvasm", 9, PASS},
                {"alignment4-struct-global.spvasm", 25, PASS},
                {"alignment4-struct-local.spvasm", 25, PASS},
                {"alignment4-struct-pointer.spvasm", 25, PASS},
                {"alignment5-struct-global.spvasm", 17, PASS},
                {"alignment5-struct-local.spvasm", 17, PASS},
                {"alignment5-struct-pointer.spvasm", 17, PASS},
        });
    }
}
