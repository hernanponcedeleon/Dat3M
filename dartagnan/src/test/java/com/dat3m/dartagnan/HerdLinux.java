package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

@RunWith(Parameterized.class)
public class HerdLinux extends AbstractHerdTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(HerdLinux.class, "herd", "");

        return buildParameters("litmus/C/", "cat/linux-kernel.cat");
    }

    public HerdLinux(String path, Result expected, String wmm) {
        super(path, expected, wmm);
    }
}
