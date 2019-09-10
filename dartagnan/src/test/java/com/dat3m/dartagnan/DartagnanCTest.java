package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.boogie.C2BoogieRunner;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.NONE;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanCTest {

    private static final String CAT_RESOURCE_PATH = "../";
    private static final String BENCHMARKS_RESOURCE_PATH = "../benchmarks/C/";

    @Parameterized.Parameters(name = "{index}: {0} {2} -> {3} {6}")
    public static Iterable<Object[]> data() throws IOException {

        Wmm wmmSc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Wmm wmmTso = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/tso.cat"));
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
    		{ BENCHMARKS_RESOURCE_PATH + "dekker.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "dekker.c", FAIL, NONE, wmmTso, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "lamport.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "lamport.c", FAIL, NONE, wmmTso, s1 },    		
    		{ BENCHMARKS_RESOURCE_PATH + "peterson.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "peterson.c", FAIL, NONE, wmmTso, s1 },    		
    		{ BENCHMARKS_RESOURCE_PATH + "szymanski.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "szymanski.c", FAIL, NONE, wmmTso, s1 },    		
    		{ BENCHMARKS_RESOURCE_PATH + "read_write_lock-1.c", FAIL, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "read_write_lock-2.c", FAIL, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", UNKNOWN, NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", UNKNOWN, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "verifier_atomic.c", PASS, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "add_mult_pass.c", PASS, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "add_mult_fail.c", FAIL, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "gcd-2.c", UNKNOWN, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "qrcu-1.c", UNKNOWN, NONE, wmmSc, s1 },
       		{ BENCHMARKS_RESOURCE_PATH + "qrcu-2.c", FAIL, NONE, wmmSc, s1 },

    		{ BENCHMARKS_RESOURCE_PATH + "while_pass_on_3.c", UNKNOWN, NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", UNKNOWN, NONE, wmmSc, s2 },

    		{ BENCHMARKS_RESOURCE_PATH + "while_pass_on_3.c", PASS, NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", FAIL, NONE, wmmSc, s3 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", UNKNOWN, NONE, wmmSc, s4 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", UNKNOWN, NONE, wmmSc, s4 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", FAIL, NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-1.c", UNKNOWN, NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-2.c", UNKNOWN, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", FAIL, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-1.c", UNKNOWN, NONE, wmmSc, s5 },
       		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-2.c", UNKNOWN, NONE, wmmSc, s5 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", PASS, NONE, wmmSc, s6 },  		
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", PASS, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-2.c", FAIL, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longest-1.c", UNKNOWN, NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longest-2.c", UNKNOWN, NONE, wmmSc, s6 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-1.c", PASS, NONE, wmmSc, s7 },

       		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-1.c", UNKNOWN, NONE, wmmSc, s10 },
       		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-2.c", UNKNOWN, NONE, wmmSc, s10 },
        });
    }
    
    private String programFilePath;
    private Result expected;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    public DartagnanCTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        this.programFilePath = new C2BoogieRunner(path).run();
        this.expected = expected;
        this.target = target;
        this.wmm = wmm;
        this.settings = settings;
    }

    // 5 Minutes timeout
    @Test(timeout=300000)
    public void test() {
        try {
            Program program = new ProgramParser().parse(new File(programFilePath));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            assertEquals(expected, Dartagnan.testProgram(solver, ctx, program, wmm, target, settings));
            ctx.close();
            Files.deleteIfExists(Paths.get(programFilePath)); 
		} catch (IOException e){
            fail("Missing resource file");
        }
   }
}