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
import static com.dat3m.dartagnan.utils.ResourceHelper.initialiseCSVFile;

@RunWith(Parameterized.class)
public class SvCompConcurrencyTest extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
    	String cat_file = GlobalSettings.getInstance().shouldParseAtomicBlockAsLocks()  ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        Settings s1 = new Settings(Alias.CFIS, 1, TIMEOUT);
        Settings s2 = new Settings(Alias.CFIS, 2, TIMEOUT);
        Settings s3 = new Settings(Alias.CFIS, 3, TIMEOUT);
        Settings s6 = new Settings(Alias.CFIS, 6, TIMEOUT);
        Settings s7 = new Settings(Alias.CFIS, 7, TIMEOUT);
        
    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(SvCompConcurrencyTest.class, "two-solvers");
        initialiseCSVFile(SvCompConcurrencyTest.class, "incremental");
        initialiseCSVFile(SvCompConcurrencyTest.class, "assume");
        initialiseCSVFile(SvCompConcurrencyTest.class, "refinement");

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1-O0.bpl", wmm, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-2-O0.bpl", wmm, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-1-O0.bpl", wmm, s7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-2-O0.bpl", wmm, s7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/lazy01-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/singleton-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/singleton_with-uninit-problems-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack-2-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack_longer-1-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack_longest-1-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-1-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-2-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-1-O0.bpl", wmm, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-2-O0.bpl", wmm, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/qrcu-2-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-1-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-2-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/time_var_mutex-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/01_inc-O0.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/14_spin2003-O0.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/18_read_write_lock-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/19_time_var_mutex-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/40_barrier_vf-O0.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/45_monabsex1_vs-O0.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/46_monabsex2_vs-O0.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/qw2004-2-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_1-join-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_2-join-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_3-join-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_1-container_of-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_2-container_of-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_3-container_of-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_4-container_of-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_5-container_of-O0.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_1-container_of-global-O0.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_2-container_of-global-O0.bpl", wmm, s1});

        return data;
    }

	public SvCompConcurrencyTest(String path, Wmm wmm, Settings settings) {
		super(path, wmm, settings);
	}
}