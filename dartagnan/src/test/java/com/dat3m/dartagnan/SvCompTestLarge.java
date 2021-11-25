package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.program.processing.AtomicAsLock.OPTION_ATOMIC_AS_LOCK;
import static com.dat3m.dartagnan.program.processing.LoopUnrolling.BOUND;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

@RunWith(Parameterized.class)
public class SvCompTestLarge extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} {2}")
    public static Iterable<Object[]> data() throws IOException, InvalidConfigurationException {
		Wmm m0 = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+"cat/svcomp.cat"));
		Wmm m1 = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+"cat/svcomp-locks.cat"));

        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "two-solvers")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "incremental")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "assume")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompTestLarge.class, "refinement")));

        List<Object[]> data = new ArrayList<>();
        String base = TEST_RESOURCE_PATH + "large/";
        // mixXXX examples
        data.add(new Object[]{base + "mix000_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix000_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix000_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix000_tso.opt-O0.bpl",1});

        data.add(new Object[]{base + "mix003_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix003_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix003_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "mix003_tso.opt-O0.bpl",1});

        // podwrXXX examples
        data.add(new Object[]{base + "podwr000_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr000_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr000_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr000_tso.opt-O0.bpl",1});

        data.add(new Object[]{base + "podwr001_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr001_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr001_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "podwr001_tso.opt-O0.bpl",1});


        // safeXXX examples
        data.add(new Object[]{base + "safe000_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe000_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe000_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe000_tso.opt-O0.bpl",1});

        data.add(new Object[]{base + "safe030_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe030_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe030_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "safe030_tso.opt-O0.bpl",1});

        // rfiXXX examples
        data.add(new Object[]{base + "rfi000_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi000_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi000_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi000_tso.opt-O0.bpl",1});

        data.add(new Object[]{base + "rfi009_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi009_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi009_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "rfi009_tso.opt-O0.bpl",1});

        // thinXXX examples
        data.add(new Object[]{base + "thin000_power.opt-O0.bpl",1});
        data.add(new Object[]{base + "thin000_pso.opt-O0.bpl",1});
        data.add(new Object[]{base + "thin000_rmo.opt-O0.bpl",1});
        data.add(new Object[]{base + "thin000_tso.opt-O0.bpl",1});

		List<Object[]> result = new ArrayList<>(data.size() * 2);
		for(Object[] o : data) {
			result.add(new Object[]{o[0],m0,Configuration.builder()
				.setOption(BOUND,o[1].toString())
				.setOption(OPTION_ATOMIC_AS_LOCK,"false")
				.build()});
			result.add(new Object[]{o[0],m1,Configuration.builder()
				.setOption(BOUND,o[1].toString())
				.setOption(OPTION_ATOMIC_AS_LOCK,"true")
				.build()});
		}
		return result;
    }

	public SvCompTestLarge(String path, Wmm wmm, Configuration c) {
		super(path, wmm, c);
	}
}