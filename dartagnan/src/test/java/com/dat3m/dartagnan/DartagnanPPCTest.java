package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

@RunWith(Parameterized.class)
public class DartagnanPPCTest extends AbstractDartagnanTest {

    @Parameterized.Parameters(name = "{index}: {0} {4}")
    public static Iterable<Object[]> data() throws IOException {
    	// We want the files to be created every time we run the unit tests
        for(Method method : Method.values()) {
        	initialiseCSVFile(DartagnanPPCTest.class, method.asStringOption(), "");
        }

        return buildParameters("litmus/PPC/", "cat/power.cat", Arch.POWER);
    }

    public DartagnanPPCTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        super(path, expected, target, wmm, settings);
    }
}
