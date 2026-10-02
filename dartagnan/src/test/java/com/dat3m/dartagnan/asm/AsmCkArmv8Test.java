package com.dat3m.dartagnan.asm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

@RunWith(Parameterized.class)
public class AsmCkArmv8Test extends AbstractAsmTest {

    public AsmCkArmv8Test(String name, int bound, VerificationStatus expected) {
        super(Arch.ARM8, name, bound, expected);
    }

    @Override
    protected String getProgramPathString() { return "asm/armv8/ck/%s.ll"; }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
            {"anderson", 3, VerificationStatus.PASS},
            {"caslock", 3, VerificationStatus.PASS},
            {"clhlock", 1, VerificationStatus.PASS},
            {"declock", 3, VerificationStatus.PASS},
            {"ebr", 5, VerificationStatus.PASS},
            {"faslock", 3, VerificationStatus.PASS},
            {"mcslock", 2, VerificationStatus.PASS},
            {"ticketlock", 1, VerificationStatus.PASS},
            {"spsc_queue", 1, VerificationStatus.PASS},
            {"stack_empty", 2, VerificationStatus.UNKNOWN},
        });
    }
}
