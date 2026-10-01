package com.dat3m.dartagnan.spirv.opencl;

import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.verification.VerificationStatus.PASS;

@RunWith(Parameterized.class)
public class PatternsAssertionsTest extends AbstractSpirvOpenclTest {

    public PatternsAssertionsTest(String file, VerificationStatus expected) {
        super("spirv/opencl/patterns/" + file, 1, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"corr.spvasm", PASS},
                {"iriw.spvasm", PASS},
                {"mp.spvasm", PASS},
                {"mp-acq2rx.spvasm", FAIL},
                {"mp-rel2rx.spvasm", FAIL},
                {"sb.spvasm", PASS},
        });
    }
}
