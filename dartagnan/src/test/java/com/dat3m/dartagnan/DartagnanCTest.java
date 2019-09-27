package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.NONE;

@RunWith(Parameterized.class)
public class DartagnanCTest extends AbstractSVCOMPTest {

	private static final String CAT_RESOURCE_PATH = "../";
    private static final String BENCHMARKS_RESOURCE_PATH = "../benchmarks/C/";

    @Parameterized.Parameters(name = "{index}: {0} {2} -> {3} {6}")
    public static Iterable<Object[]> data() throws IOException {

        Wmm wmmSc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/svcomp.cat"));
        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1);
        Settings s2 = new Settings(Mode.KNASTER, Alias.CFIS, 2);
        Settings s3 = new Settings(Mode.KNASTER, Alias.CFIS, 3);
        Settings s4 = new Settings(Mode.KNASTER, Alias.CFIS, 4);
        Settings s5 = new Settings(Mode.KNASTER, Alias.CFIS, 5);
        Settings s6 = new Settings(Mode.KNASTER, Alias.CFIS, 6);
        Settings s7 = new Settings(Mode.KNASTER, Alias.CFIS, 7);
        Settings s10 = new Settings(Mode.KNASTER, Alias.CFIS, 10);

        return Arrays.asList(new Object[][] {
        	{ BENCHMARKS_RESOURCE_PATH + "while_pass_on_3.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", UNKNOWN, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-1.i", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-2.i", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-1.i", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-2.i", UNKNOWN, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "verifier_atomic.c", PASS, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "add_mult_pass.c", PASS, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "add_mult_fail.c", FAIL, NONE, wmmSc, s1 },

    		{ BENCHMARKS_RESOURCE_PATH + "while_pass_on_3.c", UNKNOWN, NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", UNKNOWN, NONE, wmmSc, s2 },

    		{ BENCHMARKS_RESOURCE_PATH + "while_pass_on_3.c", PASS, NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", FAIL, NONE, wmmSc, s3 },

    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-1.i", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-2.i", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-1.i", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-2.i", UNKNOWN, NONE, wmmSc, s4 },

    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-2.i", FAIL, NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longer-1.i", UNKNOWN, NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longer-2.i", UNKNOWN, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-2.i", FAIL, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-longer-1.i", UNKNOWN, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-longer-2.i", UNKNOWN, NONE, wmmSc, s5 },

    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench-1.i", PASS, NONE, wmmSc, s6 },  		
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-1.i", PASS, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longer-2.i", FAIL, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longest-1.i", UNKNOWN, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longest-2.i", UNKNOWN, NONE, wmmSc, s6 },

    		{ BENCHMARKS_RESOURCE_PATH + "pthread/fib_bench_longer-1.i", PASS, NONE, wmmSc, s7 },

       		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-longest-1.i", UNKNOWN, NONE, wmmSc, s10 },
       		{ BENCHMARKS_RESOURCE_PATH + "pthread/triangular-longest-2.i", UNKNOWN, NONE, wmmSc, s10 },
        });
    }

    public DartagnanCTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
		super(path, expected, target, wmm, settings);
	}
}