package com.dat3m.dartagnan.spirv.opencl.benchmarks;

import com.dat3m.dartagnan.spirv.opencl.AbstractSpirvOpenclTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvOpenclTest {

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/opencl/benchmarks/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"caslock-1.1.2.spvasm", 2, UNKNOWN},
                {"caslock-2.1.1.spvasm", 2, UNKNOWN},
                {"caslock-acq2rx.spvasm", 2, FAIL},
                {"caslock-rel2rx.spvasm", 2, FAIL},
                {"caslock-dv2wg-2.1.1.spvasm", 2, UNKNOWN},
                {"caslock-dv2wg-1.1.2.spvasm", 2, FAIL},
                {"ticketlock-1.1.2.spvasm", 1, PASS},
                {"ticketlock-2.1.1.spvasm", 1, PASS},
                {"ticketlock-acq2rx.spvasm", 1, FAIL},
                {"ticketlock-rel2rx.spvasm", 1, FAIL},
                {"ticketlock-dv2wg-2.1.1.spvasm", 2, PASS},
                {"ticketlock-dv2wg-1.1.2.spvasm", 1, FAIL},
                {"ttaslock-1.1.2.spvasm", 2, PASS},
                {"ttaslock-2.1.1.spvasm", 2, PASS},
                {"ttaslock-acq2rx.spvasm", 1, FAIL},
                {"ttaslock-rel2rx.spvasm", 1, FAIL},
                {"ttaslock-dv2wg-2.1.1.spvasm", 2, PASS},
                {"ttaslock-dv2wg-1.1.2.spvasm", 1, FAIL},

                {"xf-barrier-2.1.2.spvasm", 9, PASS},
                // {"xf-barrier-3.1.3.spvasm", 9, PASS},
                // {"xf-barrier-1.1.2.spvasm", 2, PASS},
                {"xf-barrier-2.1.1.spvasm", 9, PASS},
                {"xf-barrier-fail1.spvasm", 9, FAIL},
                {"xf-barrier-fail2.spvasm", 9, FAIL},
                {"xf-barrier-fail3.spvasm", 9, FAIL},
                {"xf-barrier-fail4.spvasm", 9, FAIL},
                {"xf-barrier-weakest.spvasm", 9, FAIL},
        });
    }
}
