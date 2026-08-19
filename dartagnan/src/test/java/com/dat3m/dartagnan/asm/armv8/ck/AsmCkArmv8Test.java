package com.dat3m.dartagnan.asm.armv8.ck;

import com.dat3m.dartagnan.asm.AbstractAsmTest;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

@RunWith(Parameterized.class)
public class AsmCkArmv8Test extends AbstractAsmTest {

    public AsmCkArmv8Test(String file, int bound, ResultStatus expected) {
        super(Arch.ARM8, "asm/armv8/ck/" + file, bound, expected);
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"anderson", 3, ResultStatus.PASS},
            {"caslock", 3, ResultStatus.PASS},
            {"clhlock", 1, ResultStatus.PASS},
            {"declock", 3, ResultStatus.PASS},
            {"ebr", 5, ResultStatus.PASS},
            {"faslock", 3, ResultStatus.PASS},
            {"mcslock", 2, ResultStatus.PASS},
            {"ticketlock", 1, ResultStatus.PASS},
            {"spsc_queue", 1, ResultStatus.PASS},
            {"stack_empty", 2, ResultStatus.UNKNOWN},
        });
    }
}
