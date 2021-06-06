package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

/*
NOTE: Currently we fail on pretty much all of the following tasks
 */

@RunWith(Parameterized.class)
public class SvCompTestFails extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        String cat_file = GlobalSettings.ATOMIC_AS_LOCK ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        cat_file = "cat/power.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        Settings s2 = new Settings(Alias.CFIS, 1, TIMEOUT);

        List<Object[]> data = new ArrayList<>();
        data.add(new Object[]{"../lfds/ms_datCAS-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../lfds/ms-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/ms-test-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/ttas-5-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/mutex-4-O0.bpl", wmm, s2});

        return data;
    }

	public SvCompTestFails(String path, Wmm wmm, Settings settings) {
		super(path, wmm, settings);
	}
}