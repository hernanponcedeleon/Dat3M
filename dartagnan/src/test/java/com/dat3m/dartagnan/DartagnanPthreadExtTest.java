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
public class DartagnanPthreadExtTest {

    private static final String CAT_RESOURCE_PATH = "../";
    private static final String BENCHMARKS_RESOURCE_PATH = "../benchmarks/C/pthread-ext/";

    @Parameterized.Parameters(name = "{index}: {0} {2} -> {3} {6}")
    public static Iterable<Object[]> data() throws IOException {

        Wmm wmmSc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1);

        return Arrays.asList(new Object[][] {      	
        	{ BENCHMARKS_RESOURCE_PATH + "01_inc.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "02_inc_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "03_incdec.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "04_incdec_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "05_tas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "06_ticket.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "07_rand.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "08_rand_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "09_fmaxsym.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "10_fmaxsym_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "11_fmaxsymopt.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "12_fmaxsymopt_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "13_unverif.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "14_spin2003.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "15_dekker.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "16_peterson.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "17_szymanski.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "18_read_write_lock.c", PASS, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "19_time_var_mutex.c", PASS, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "20_lamport.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "23_lu-fig2.fixed.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "25_stack.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "25_stack_longer-1.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "25_stack_longer-2.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "25_stack_longest-1.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "25_stack_longest-2.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "26_stack_cas.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "26_stack_cas_longer-1.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "26_stack_cas_longer-2.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "26_stack_cas_longest-1.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "26_stack_cas_longest-2.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "27_Boop_simple_vf.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "28_buggy_simple_loop1_vf.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "29_conditionals_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "30_Function_Pointer3_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "31_simple_loop5_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "32_pthread5_vs.c", FAIL, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "33_double_lock_p1_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "34_double_lock_p2_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "35_double_lock_p3_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "36_stack_cas_p0_vs_concur.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "37_stack_lock_p0_vs_concur.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "38_rand_cas_vs_concur.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "39_rand_lock_p0_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "40_barrier_vf.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "41_FreeBSD_abd_kbd_sliced.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "42_FreeBSD_rdma_addr_sliced.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "43_NetBSD_sysmon_power_sliced.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "44_Solaris_space_map_sliced.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "45_monabsex1_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "46_monabsex2_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "47_ticket_lock_hc_backoff_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        	{ BENCHMARKS_RESOURCE_PATH + "48_ticket_lock_low_contention_vs.c", UNKNOWN, NONE, wmmSc, s1 },
        });
    }
    
    private String programFilePath;
    private Result expected;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    public DartagnanPthreadExtTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        this.programFilePath = new C2BoogieRunner(new File(path)).run();
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