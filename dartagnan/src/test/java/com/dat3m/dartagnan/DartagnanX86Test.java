package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

@RunWith(Parameterized.class)
public class DartagnanX86Test extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        Files.deleteIfExists(Paths.get(getCSVFileName(DartagnanX86Test.class, "two-solvers")));
        Files.deleteIfExists(Paths.get(getCSVFileName(DartagnanX86Test.class, "incremental")));
        Files.deleteIfExists(Paths.get(getCSVFileName(DartagnanX86Test.class, "assume")));
        Files.deleteIfExists(Paths.get(getCSVFileName(DartagnanX86Test.class, "refinement")));

		return buildParameters("litmus/X86/", "cat/tso.cat", Arch.TSO);
    }

    public DartagnanX86Test(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        super(path, expected, target, wmm, settings);
    }
}
