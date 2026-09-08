package com.dat3m.dartagnan.asm.armv7.ck;

import com.dat3m.dartagnan.asm.AbstractAsmTest;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

@RunWith(Parameterized.class)
public class AsmCkArmv7Test extends AbstractAsmTest {

    public AsmCkArmv7Test(String name, int bound, ResultStatus expected) {
        super(Arch.ARM7, name, bound, expected);
    }

    @Override
    protected String getProgramPathString() { return "asm/armv7/ck/%s.ll"; }

    @Override
    protected String getTargetWmmName() { return "arm"; }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"clhlock", 1, ResultStatus.PASS},
            {"faslock", 3, ResultStatus.PASS},
            {"spsc_queue", 1, ResultStatus.PASS},
            {"ticketlock", 1, ResultStatus.PASS},
        });
    }
}
