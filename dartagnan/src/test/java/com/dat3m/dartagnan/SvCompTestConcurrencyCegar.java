package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.analysis.Cegar.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Cegar.runAnalysis;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class SvCompTestConcurrencyCegar {

    private String path;
    private Wmm exact;
    private Wmm overApproximation;
    private Settings settings;
    private Result expected;
	
	public SvCompTestConcurrencyCegar(String path, Wmm wmm, Wmm wmm2, Settings settings) {
        this.path = path;
        this.exact = wmm;
        this.overApproximation = wmm2;
        this.settings = settings;
	}
    
	@Parameterized.Parameters(name = "{index}: {0} bound={3}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm exact = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));
        Wmm overApprox = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcompC1.cat"));

        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Settings s2 = new Settings(Mode.KNASTER, Alias.CFIS, 2, false);
        Settings s3 = new Settings(Mode.KNASTER, Alias.CFIS, 3, false);
        Settings s6 = new Settings(Mode.KNASTER, Alias.CFIS, 6, false);
        Settings s7 = new Settings(Mode.KNASTER, Alias.CFIS, 7, false);
        
        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1-O0.bpl", exact, overApprox, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-2-O0.bpl", exact, overApprox, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-1-O0.bpl", exact, overApprox, s7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-2-O0.bpl", exact, overApprox, s7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/lazy01-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/singleton-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/singleton_with-uninit-problems-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack-2-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack_longer-1-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stack_longest-1-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-1-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/stateful01-2-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-1-O0.bpl", exact, overApprox, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-2-O0.bpl", exact, overApprox, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-1-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-2-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/time_var_mutex-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/01_inc-O0.bpl", exact, overApprox, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/14_spin2003-O0.bpl", exact, overApprox, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/18_read_write_lock-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/19_time_var_mutex-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/40_barrier_vf-O0.bpl", exact, overApprox, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/45_monabsex1_vs-O0.bpl", exact, overApprox, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/46_monabsex2_vs-O0.bpl", exact, overApprox, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/qw2004-2-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_1-join-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_2-join-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_3-join-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_1-container_of-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_2-container_of-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_3-container_of-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_4-container_of-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-2_5-container_of-O0.bpl", exact, overApprox, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_1-container_of-global-O0.bpl", exact, overApprox, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_2-container_of-global-O0.bpl", exact, overApprox, s1});

        return data;
    }
    
    @Test(timeout = 180000)
    public void test() {
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExptected(property);
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver();
            assertTrue(runAnalysis(solver, ctx, program, exact, overApproximation, Arch.NONE, settings).equals(expected));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }

    @Test(timeout = 180000)
    public void testIncremenral() {
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExptected(property);
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver();
            assertTrue(runAnalysisIncrementalSolver(solver, ctx, program, exact, overApproximation, Arch.NONE, settings).equals(expected));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }

	private Result readExptected(String property) {
		try (BufferedReader br = new BufferedReader(new FileReader(new File(property)))) {
		    while (!(br.readLine()).contains("unreach-call.prp")) {
		       continue;
		    }
		    return br.readLine().contains("false") ? FAIL : PASS;

		} catch (Exception e) {
			System.out.println(e.getMessage());
            System.exit(0);
		}
		return null;
	}
}