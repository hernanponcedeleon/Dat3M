package com.dat3m.dartagnan;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

import java.io.IOException;

@RunWith(Parameterized.class)
public class HerdAARCH64 extends AbstractHerdTest {

    @Parameterized.Parameters(name = "{index}: {0} {1}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(HerdAARCH64.class, "herd");

		return buildParameters("litmus/AARCH64/", "aarch64/tso.cat");
    }

    public HerdAARCH64(String path, String wmm) {
        super(path, wmm);
    }
}
