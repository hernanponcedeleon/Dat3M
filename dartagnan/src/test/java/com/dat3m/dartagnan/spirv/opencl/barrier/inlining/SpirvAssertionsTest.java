package com.dat3m.dartagnan.spirv.opencl.barrier.inlining;

import com.dat3m.dartagnan.spirv.opencl.AbstractSpirvOpenclTest;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class SpirvAssertionsTest extends AbstractSpirvOpenclTest {

    public SpirvAssertionsTest(String file, int bound, ResultStatus expected) {
        super("spirv/opencl/barrier/inlining/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"barrier-inlining-1-forall-correct.spvasm", 1, PASS},
                {"barrier-inlining-1-exists-correct.spvasm", 1, PASS},
                {"barrier-inlining-1-forall-wrong.spvasm", 1, FAIL},
                {"barrier-inlining-1-exists-wrong.spvasm", 1, FAIL},

                {"barrier-no-inlining-1-forall-correct.spvasm", 1, PASS},
                {"barrier-no-inlining-1-exists-correct.spvasm", 1, PASS},
                {"barrier-no-inlining-1-forall-wrong.spvasm", 1, FAIL},
                {"barrier-no-inlining-1-exists-wrong.spvasm", 1, FAIL},

                {"barrier-inlining-2-forall-correct.spvasm", 1, PASS},
                {"barrier-inlining-2-exists-correct.spvasm", 1, PASS},
                {"barrier-inlining-2-forall-wrong.spvasm", 1, FAIL},
                {"barrier-inlining-2-exists-wrong.spvasm", 1, FAIL},

                {"barrier-inlining-3-forall-correct.spvasm", 1, PASS},
                {"barrier-inlining-3-exists-correct.spvasm", 1, PASS},
                {"barrier-inlining-3-forall-wrong.spvasm", 1, FAIL},
                {"barrier-inlining-3-exists-wrong.spvasm", 1, FAIL},

                {"barrier-inlining-4-forall-correct.spvasm", 3, PASS},
                {"barrier-inlining-4-exists-correct.spvasm", 3, PASS},
                {"barrier-inlining-4-forall-wrong.spvasm", 3, FAIL},
                {"barrier-inlining-4-exists-wrong.spvasm", 3, FAIL},

                {"barrier-inlining-5-forall-correct.spvasm", 3, PASS},
                {"barrier-inlining-5-exists-correct.spvasm", 3, PASS},
                {"barrier-inlining-5-forall-wrong.spvasm", 3, FAIL},
                {"barrier-inlining-5-exists-wrong.spvasm", 3, FAIL}
        });
    }
}
