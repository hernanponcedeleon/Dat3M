package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

@RunWith(Parameterized.class)
public class DartagnanLinuxTest extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(DartagnanLinuxTest.class, "two-solvers");
        initialiseCSVFile(DartagnanLinuxTest.class, "incremental");
        initialiseCSVFile(DartagnanLinuxTest.class, "assume");
        initialiseCSVFile(DartagnanLinuxTest.class, "refinement");

        return buildParameters("litmus/C/", "cat/linux-kernel.cat", Arch.NONE);
    }

    public DartagnanLinuxTest(String path, Result expected, Arch target, Wmm wmm) {
        super(path, expected, target, wmm);
    }
}
