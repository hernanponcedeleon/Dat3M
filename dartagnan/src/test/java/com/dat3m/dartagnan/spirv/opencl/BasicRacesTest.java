package com.dat3m.dartagnan.spirv.opencl;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class BasicRacesTest extends AbstractSpirvOpenclTest {

    public BasicRacesTest(String file, ResultStatus expected) {
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
