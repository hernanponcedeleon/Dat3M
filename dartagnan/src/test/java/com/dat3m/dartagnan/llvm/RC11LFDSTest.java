package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.verification.ResultStatus.*;

@RunWith(Parameterized.class)
public class RC11LFDSTest extends AbstractCTest {

    public RC11LFDSTest(String name, Arch target, ResultStatus expected) {
        super(name, target, expected);
    }

    @Override
    protected String getProgramPathPrefix() {
        return "lfds/";
    }

    @Override
    protected long getTimeout() {
        return 600000;
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> 2;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
    }

    @Override
    protected boolean isEagerMethodEnabled() { return false; }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"dglm", C11, UNKNOWN},
                {"dglm-CAS-relaxed", C11, FAIL},
                {"ms", C11, UNKNOWN},
                {"ms-CAS-relaxed", C11, FAIL},
                {"treiber", C11, UNKNOWN},
                {"treiber-CAS-relaxed", C11, FAIL},
                {"chase-lev", C11, PASS},
                // These have an extra thief that violate the assertion
                {"chase-lev-fail", C11, FAIL},
                {"hash_table", C11, PASS},
                {"hash_table-fail", C11, FAIL},
        });
    }
}