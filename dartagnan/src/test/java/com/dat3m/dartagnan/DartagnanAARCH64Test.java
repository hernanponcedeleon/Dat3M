package com.dat3m.dartagnan;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;

@RunWith(Parameterized.class)
public class DartagnanAARCH64Test extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {2} untoll={4} relax={5} idl={6}")
    public static Iterable<Object[]> data() throws IOException {
        return buildParameters("litmus/AARCH64/", "cat/aarch64.cat", Arch.ARM8, 2);
    }

    public DartagnanAARCH64Test(String input, boolean expected, Arch target, Wmm wmm, int unroll, Mode mode) {
        super(input, expected, target, wmm, unroll, mode);
    }
}
