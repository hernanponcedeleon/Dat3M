package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

@RunWith(Parameterized.class)
public class SvCompConcurrencyTest extends AbstractSvCompTest {

    public SvCompConcurrencyTest(String name, int bound) {
        super(name, bound);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return () -> TEST_RESOURCE_PATH + "boogie/concurrency/" + name + "-O0.bpl";
    }

    @Parameterized.Parameters(name = "{index}: {0}, bound={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][] {
                {"fib_bench-1", 6},
                {"fib_bench-2", 6},
                {"fib_bench_longer-1", 7},
                {"fib_bench_longer-2", 7},
                {"lazy01", 1},
                {"singleton", 1},
                {"singleton_with-uninit-problems", 2},
                {"stack-2", 2},
                {"stack_longer-1", 2},
                {"stack_longest-1", 2},
                {"stateful01-1", 1},
                {"stateful01-2", 1},
                {"triangular-1", 6},
                {"triangular-2", 6},
                {"qrcu-2", 1},
                {"read_write_lock-1", 1},
                {"read_write_lock-2", 1},
                {"time_var_mutex", 2},
                {"01_inc", 3},
                {"14_spin2003", 3},
                {"18_read_write_lock", 1},
                {"19_time_var_mutex", 2},
                {"40_barrier_vf", 3},
                {"45_monabsex1_vs", 3},
                {"46_monabsex2_vs", 3},
                {"qw2004-2", 2},
                {"race-1_1-join", 1},
                {"race-1_2-join", 1},
                {"race-1_3-join", 1},
                {"race-2_1-container_of", 2},
                {"race-2_2-container_of", 1},
                {"race-2_3-container_of", 1},
                {"race-2_4-container_of", 1},
                {"race-2_5-container_of", 1},
                {"race-3_1-container_of-global", 2},
                {"race-3_2-container_of-global", 1},
                {"test-easy8.wvr", 1},
                {"pthread-demo-datarace-2", 21}
        });
    }
}