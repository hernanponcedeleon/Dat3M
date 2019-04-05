package com.dat3m.dartagnan;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class DartagnanPPCTest extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} arch={2} mode={5} alias=anderson unroll={4}")
    public static Iterable<Object[]> data() throws IOException {
        return buildParameters("litmus/PPC/", "cat/power.cat", Arch.POWER, 2);
    }

    public DartagnanPPCTest(String path, boolean expected, Arch target, Wmm wmm, int unroll, Mode mode) {
        super(path, expected, target, wmm, unroll, mode);
    }
}
