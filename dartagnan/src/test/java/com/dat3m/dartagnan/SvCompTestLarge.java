package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

@RunWith(Parameterized.class)
public class SvCompTestLarge extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        String cat_file = GlobalSettings.getInstance().shouldParseAtomicBlockAsLocks() ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        int s1 = 1;

        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "two-solvers")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "incremental")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "assume")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "refinement")));

        List<Object[]> data = new ArrayList<>();
        String base = TEST_RESOURCE_PATH + "large/";
        // mixXXX examples
        data.add(new Object[]{base + "mix000_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix000_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix000_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix000_tso.opt-O0.bpl", wmm, s1});

        data.add(new Object[]{base + "mix003_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix003_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix003_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "mix003_tso.opt-O0.bpl", wmm, s1});

        // podwrXXX examples
        data.add(new Object[]{base + "podwr000_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr000_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr000_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr000_tso.opt-O0.bpl", wmm, s1});

        data.add(new Object[]{base + "podwr001_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr001_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr001_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "podwr001_tso.opt-O0.bpl", wmm, s1});


        // safeXXX examples
        data.add(new Object[]{base + "safe000_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe000_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe000_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe000_tso.opt-O0.bpl", wmm, s1});

        data.add(new Object[]{base + "safe030_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe030_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe030_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "safe030_tso.opt-O0.bpl", wmm, s1});

        // rfiXXX examples
        data.add(new Object[]{base + "rfi000_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi000_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi000_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi000_tso.opt-O0.bpl", wmm, s1});

        data.add(new Object[]{base + "rfi009_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi009_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi009_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "rfi009_tso.opt-O0.bpl", wmm, s1});

        // thinXXX examples
        data.add(new Object[]{base + "thin000_power.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "thin000_pso.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "thin000_rmo.opt-O0.bpl", wmm, s1});
        data.add(new Object[]{base + "thin000_tso.opt-O0.bpl", wmm, s1});

        return data;
    }

	public SvCompTestLarge(String path, Wmm wmm, int bound) {
		super(path, wmm, bound);
	}
}