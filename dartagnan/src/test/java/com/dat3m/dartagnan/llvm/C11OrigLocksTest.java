package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.VerificationStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class C11OrigLocksTest extends C11LocksTest {

    public C11OrigLocksTest(String name, Arch target, VerificationStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getWmmName() { return "c11-orig"; }
}