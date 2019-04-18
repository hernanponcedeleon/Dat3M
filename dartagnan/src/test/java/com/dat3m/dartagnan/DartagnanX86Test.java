package com.dat3m.dartagnan;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class DartagnanX86Test extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} arch={2} mode={5} alias=anderson unroll={4}")
    public static Iterable<Object[]> data() throws IOException {
        return buildParameters("litmus/X86/", "cat/tso.cat", Arch.TSO, 2);
    }

    public DartagnanX86Test(String path, boolean expected, Arch target, Wmm wmm, int unroll, Mode mode) {
        super(path, expected, target, wmm, unroll, mode);
    }
}
