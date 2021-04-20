package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Mode;
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
//TODO(TH): now these ones should pass, right?
// Yes, we pass on them. But we still should maintain a list of benchmarks where
// we give wrong results (or just timeout?)
// For now, we could add stack-1 here.

@RunWith(Parameterized.class)
public class SvCompTestFails extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        String cat_file = GlobalSettings.ATOMIC_AS_LOCK ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        Settings s6 = new Settings(Mode.KNASTER, Alias.CFIS, 6, TIMEOUT, false);

        List<Object[]> data = new ArrayList<>();
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack-1-O0.bpl", wmm, s6});

        return data;
    }

	public SvCompTestFails(String path, Wmm wmm, Settings settings) {
		super(path, wmm, settings);
	}
}