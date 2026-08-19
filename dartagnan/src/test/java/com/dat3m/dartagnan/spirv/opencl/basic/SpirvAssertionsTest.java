package com.dat3m.dartagnan.spirv.opencl.basic;

import com.dat3m.dartagnan.spirv.opencl.AbstractSpirvOpenclTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvOpenclTest {

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/opencl/basic/" + file, bound ,expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"idx-overflow.spvasm", 1, PASS},
        });
    }
}
