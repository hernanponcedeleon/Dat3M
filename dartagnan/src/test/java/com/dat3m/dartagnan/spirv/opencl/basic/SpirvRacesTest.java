package com.dat3m.dartagnan.spirv.opencl.basic;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.spirv.opencl.AbstractSpirvOpenclTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvRacesTest extends AbstractSpirvOpenclTest {

    public SpirvRacesTest(String file, ResultStatus expected) {
        super("spirv/opencl/basic/" + file, 1, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"idx-overflow.spvasm", PASS}
        });
    }

    @Override
    protected Property getTestedProperty() { return Property.CAT_SPEC; }
}
