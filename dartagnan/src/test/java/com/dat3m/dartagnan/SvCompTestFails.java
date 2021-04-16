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

@RunWith(Parameterized.class)
public class SvCompTestFails extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        String cat_file = GlobalSettings.ATOMIC_AS_LOCK ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        //String cat_file = "cat/sc.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1, TIMEOUT, false);
        Settings s3 = new Settings(Mode.KNASTER, Alias.CFIS, 3, TIMEOUT, false);

        List<Object[]> data = new ArrayList<>();
        String base = TEST_RESOURCE_PATH + "fails/";

        // Should be FAIL under SVCOMP, but we get PASS.
        // Additionally, we get FAIL under SC
        //data.add(new Object[]{base + "rfi006_power.oepc-O0.bpl", wmm, s1});

        data.add(new Object[]{base + "02_inc_cas-O0.bpl", wmm, s3});
        data.add(new Object[]{base + "03_incdec-O0.bpl", wmm, s3});

        return data;
    }

	public SvCompTestFails(String path, Wmm wmm, Settings settings) {
		super(path, wmm, settings);
	}
}