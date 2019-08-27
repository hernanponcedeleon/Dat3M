package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
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
        Settings s5 = new Settings(Mode.KNASTER, Alias.CFIS, 5);
        Settings s6 = new Settings(Mode.KNASTER, Alias.CFIS, 6);
        Settings s10 = new Settings(Mode.KNASTER, Alias.CFIS, 10);
        Settings s11 = new Settings(Mode.KNASTER, Alias.CFIS, 11);
        Settings s20 = new Settings(Mode.KNASTER, Alias.CFIS, 20);

        return Arrays.asList(new Object[][] {
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "dekker.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "dekker.c", true, Arch.NONE, wmmTso, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "lamport.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "lamport.c", true, Arch.NONE, wmmTso, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "peterson.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "peterson.c", true, Arch.NONE, wmmTso, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "szymanski.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "szymanski.c", true, Arch.NONE, wmmTso, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "read_write_lock-1.c", true, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "read_write_lock-2.c", true, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-1.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-2.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-1.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-2.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "verifier_atomic.c", false, Arch.NONE, wmmSc, s1 },
    		
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-1.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-2.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-1.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-2.c", false, Arch.NONE, wmmSc, s2 },

    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", true, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-1.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-2.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-1.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-2.c", false, Arch.NONE, wmmSc, s3 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-1.c", false, Arch.NONE, wmmSc, s5 },  		
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench-2.c", true, Arch.NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-2.c", false, Arch.NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-1.c", false, Arch.NONE, wmmSc, s5 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-2.c", true, Arch.NONE, wmmSc, s5 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-1.c", false, Arch.NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longer-2.c", true, Arch.NONE, wmmSc, s6 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longest-2.c", false, Arch.NONE, wmmSc, s6 },
    		
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-1.c", false, Arch.NONE, wmmSc, s10 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longer-2.c", true, Arch.NONE, wmmSc, s10 },

    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longest-1.c", false, Arch.NONE, wmmSc, s11 },
    		{ BENCHMARKS_RESOURCE_PATH + "fib_bench_longest-2.c", true, Arch.NONE, wmmSc, s11 },
    		
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-1.c", false, Arch.NONE, wmmSc, s20 },
    		{ BENCHMARKS_RESOURCE_PATH + "triangular-longest-2.c", true, Arch.NONE, wmmSc, s20 },
        });
    }
    
    private String programFilePath;
    private boolean expected;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    public DartagnanCTest(String path, boolean expected, Arch target, Wmm wmm, Settings settings) {
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