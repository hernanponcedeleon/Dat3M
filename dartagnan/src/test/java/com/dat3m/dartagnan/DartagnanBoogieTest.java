package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
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
import java.util.Arrays;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanBoogieTest {

    private static final String CAT_RESOURCE_PATH = "../";
    private static final String BENCHMARKS_RESOURCE_PATH = "../";

    @Parameterized.Parameters(name = "{index}: {0} {2} -> {3} {6}")
    public static Iterable<Object[]> data() throws IOException {

        Wmm wmmSc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1);
        Settings s2 = new Settings(Mode.KNASTER, Alias.CFIS, 2);
        Settings s3 = new Settings(Mode.KNASTER, Alias.CFIS, 3);

        return Arrays.asList(new Object[][] {
        		{ BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_child_fork.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_child_fork.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_assert_local.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_assert_local.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_assert_global.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_assert_global.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_repeated_procedure.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_procedure_not_defined.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_const_assigned.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_var_not_defined.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_fun_not_defined.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_reg_const_already_defined.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_reg_loc_already_defined.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_no_main.bpl", true, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_constant_while.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_constant_while.bpl", false, Arch.NONE, wmmSc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_constant_while.bpl", false, Arch.NONE, wmmSc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_U1_while.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_U2_while.bpl", false, Arch.NONE, wmmSc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_smack_U1_while.bpl", false, Arch.NONE, wmmSc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/fail_smack_U2_while.bpl", false, Arch.NONE, wmmSc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "benchmarks/boogie/pass_smack_U3_while.bpl", false, Arch.NONE, wmmSc, s3 }
        });
    }
    
    private String programFilePath;
    private boolean parseExc;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    public DartagnanBoogieTest(String path, boolean parseExp, Arch target, Wmm wmm, Settings settings) {
        this.programFilePath = path;
        this.parseExc = parseExp;
        this.target = target;
        this.wmm = wmm;
        this.settings = settings;
    }

    @Test
    public void test() {
        try {
            Program program = new ProgramParser().parse(new File(programFilePath));
            assert(!parseExc);
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            boolean expected = !programFilePath.contains("pass");
            assertEquals(expected, Dartagnan.testProgram(solver, ctx, program, wmm, target, settings));
            ctx.close();
        } catch (ParsingException e) {
        	assert(parseExc);
		} catch (IOException e){
            fail("Missing resource file");
        }
   }
}