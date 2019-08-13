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
        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1);
        Settings s2 = new Settings(Mode.KNASTER, Alias.CFIS, 2);
        Settings s3 = new Settings(Mode.KNASTER, Alias.CFIS, 3);

        return Arrays.asList(new Object[][] {
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_always_pass.c", false, Arch.NONE, wmmSc, s3 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", false, Arch.NONE, wmmSc, s1 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", false, Arch.NONE, wmmSc, s2 },
    		{ BENCHMARKS_RESOURCE_PATH + "while_fail_on_3.c", true, Arch.NONE, wmmSc, s3 },
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

    @Test
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