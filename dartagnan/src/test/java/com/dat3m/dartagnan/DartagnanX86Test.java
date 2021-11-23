package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

import java.io.IOException;

@RunWith(Parameterized.class)
public class DartagnanX86Test extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
    	initialiseCSVFile(DartagnanX86Test.class, "two-solvers");
    	initialiseCSVFile(DartagnanX86Test.class, "incremental");
    	initialiseCSVFile(DartagnanX86Test.class, "assume");
    	initialiseCSVFile(DartagnanX86Test.class, "refinement");

		return buildParameters("litmus/X86/", "cat/tso.cat", Arch.TSO);
    }

    public DartagnanX86Test(String path, Result expected, Arch target, Wmm wmm) {
        super(path, expected, target, wmm);
    }
}
