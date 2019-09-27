package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class SVCompPthreadWmmTest extends AbstractSVCOMPTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
        return buildParameters("benchmarks/C/pthread-wmm/", "cat/svcomp.cat", Arch.NONE);
    }

    public SVCompPthreadWmmTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        super(path, expected, target, wmm, settings);
    }
}
