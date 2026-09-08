package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.IMM;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class IMMLFDSTest extends AbstractCTest {

    public IMMLFDSTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathString() { return "lfds/%s.ll"; }

    @Override
    protected long getTimeoutSeconds() { return 600; }

    @Override
    protected int getBound() { return 2; }

    @Override
    protected boolean isEagerMethodEnabled() { return false; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"dglm", IMM, UNKNOWN},
                {"dglm-CAS-relaxed", IMM, FAIL},
                {"ms", IMM, UNKNOWN},
                {"ms-CAS-relaxed", IMM, FAIL},
                {"treiber", IMM, UNKNOWN},
                {"treiber-CAS-relaxed", IMM, FAIL},
                {"chase-lev", IMM, PASS},
                // These have an extra thief that violate the assertion
                {"chase-lev-fail", IMM, FAIL},
                {"hash_table", IMM, PASS},
                {"hash_table-fail", IMM, FAIL},
        });
    }
}