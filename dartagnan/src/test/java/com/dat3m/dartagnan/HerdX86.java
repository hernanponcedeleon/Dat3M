package com.dat3m.dartagnan;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

import java.io.IOException;

@RunWith(Parameterized.class)
public class HerdX86 extends AbstractHerdTest {

    @Parameterized.Parameters(name = "{index}: {0} {1}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(HerdX86.class, "herd");

		return buildParameters("litmus/X86/", "cat/tso.cat");
    }

    public HerdX86(String path, String wmm) {
        super(path, wmm);
    }
}
