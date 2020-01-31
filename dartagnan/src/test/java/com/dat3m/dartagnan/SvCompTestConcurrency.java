package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

@RunWith(Parameterized.class)
public class SvCompTestConcurrency extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-2.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/lazy01.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack-1.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack-2.bpl", wmm,});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-1.c.bpl", wmm,});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-2.c.bpl", wmm,});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-1.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-2.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-longer-1.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-longer-2.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/gcd-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/qrcu-2.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-1.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-2.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/scull.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/time_var_mutex.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/18_read_write_lock.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/19_time_var_mutex.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe001_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe002_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe003_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe004_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe005_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe006_pso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe006_pso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe006_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe006_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe007_pso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe007_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe009_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe010_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe010_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe011_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe012_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe014_pso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe014_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe016_pso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe016_pso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe016_tso.oepc.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe016_tso.opt.bpl", wmm, });
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_1-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_2-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_3-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_2-container_of-global.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/pthread-demo-datarace-1.bpl", wmm, });
        
        return data;
    }

	public SvCompTestConcurrency(String path, Wmm wmm, int bound) {
		super(path, wmm, bound);
	}
}