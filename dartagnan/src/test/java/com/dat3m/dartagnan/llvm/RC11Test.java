package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class RC11Test extends AbstractCTest {

    public RC11Test(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathPrefix() {
        return "rc11/";
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected String getWmmName() { return "rc11"; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"2+2W", C11, PASS},
                {"IRIW-acq-sc", C11, FAIL},
                {"LB", C11, PASS},
                {"LB+deps", C11, PASS},
                {"RWC+syncs", C11, PASS},
                {"SB", C11, PASS},
                {"SB+rfis", C11, FAIL},
                {"W+RWC", C11, PASS},
                {"WWmerge", C11, FAIL},
                {"Z6.U", C11, FAIL},
        });
    }
}