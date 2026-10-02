package com.dat3m.dartagnan.asm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

@RunWith(Parameterized.class)
public class AsmCkArmv7Test extends AbstractAsmTest {

    public AsmCkArmv7Test(String name, int bound, VerificationStatus expected) {
        super(Arch.ARM7, name, bound, expected);
    }

    @Override
    protected String getProgramPathString() { return "asm/armv7/ck/%s.ll"; }

    @Override
    protected String getTargetWmmName() { return "arm"; }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"clhlock", 1, VerificationStatus.PASS},
            {"faslock", 3, VerificationStatus.PASS},
            {"spsc_queue", 1, VerificationStatus.PASS},
            {"ticketlock", 1, VerificationStatus.PASS},
        });
    }
}
