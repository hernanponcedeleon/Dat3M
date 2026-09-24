package com.dat3m.dartagnan.asm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

@RunWith(Parameterized.class)
public class AsmCkRISCVTest extends AbstractAsmTest {

    public AsmCkRISCVTest(String name, int bound, ResultStatus expected) {
        super(Arch.RISCV, name, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"spsc_queue", 1, ResultStatus.PASS},
        });
    }

    @Override
    protected String getProgramPathString() { return "asm/riscv/ck/%s.ll"; }
}
