package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.nio.file.Files;
import java.nio.file.Paths;

@RunWith(Parameterized.class)
public class DartagnanAARCH64Test extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
		Files.deleteIfExists(Paths.get(System.getenv().get("DAT3M_HOME") + "/output/" + MethodHandles.lookup().lookupClass().getSimpleName() + "-two-solvers.csv"));
		Files.deleteIfExists(Paths.get(System.getenv().get("DAT3M_HOME") + "/output/" + MethodHandles.lookup().lookupClass().getSimpleName() + "-incremental.csv"));
		Files.deleteIfExists(Paths.get(System.getenv().get("DAT3M_HOME") + "/output/" + MethodHandles.lookup().lookupClass().getSimpleName() + "-assume.csv"));
		Files.deleteIfExists(Paths.get(System.getenv().get("DAT3M_HOME") + "/output/" + MethodHandles.lookup().lookupClass().getSimpleName() + "-refinement.csv"));

        return buildParameters("litmus/AARCH64/", "cat/aarch64.cat", Arch.ARM8);
    }

    public DartagnanAARCH64Test(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        super(path, expected, target, wmm, settings);
    }
}
