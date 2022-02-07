package com.dat3m.dartagnan;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

@RunWith(Parameterized.class)
public class HerdPPC extends AbstractHerdTest {

    @Parameterized.Parameters(name = "{index}: {0} {1}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(HerdPPC.class, "herd");

        return buildParameters("litmus/PPC/", "cat/power.cat");
    }

    public HerdPPC(String path, String wmm) {
        super(path, wmm);
    }
}
