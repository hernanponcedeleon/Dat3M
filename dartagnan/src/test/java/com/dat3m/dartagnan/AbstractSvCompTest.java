package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
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
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public abstract class AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-2.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench_longer-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/lazy01.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-1.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/triangular-2.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/gcd-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/read_write_lock-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/18_read_write_lock.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/19_time_var_mutex.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe000_pso.oepc.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/safe001_tso.oepc.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/thin000_pso.oepc.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_1-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_2-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-1_3-join.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/concurrency/race-3_2-container_of-global.bpl", wmm, 1});
        
        return data;
    }

    private String path;
    private Wmm wmm;
    private int bound;
    private Result expected;

    public AbstractSvCompTest(String path, Wmm wmm, int bound) {
        this.path = path;
        this.wmm = wmm;
        this.bound = bound;
    }

    @Test(timeout = 120000)
    public void test() {
        try {
        	String property = path.substring(0, path.lastIndexOf(".")) + ".yml";
        	expected = readExptected(property);
        	
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            Settings settings = new Settings(Mode.KNASTER, Alias.CFIS, bound);
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            assertTrue(Dartagnan.testProgram(solver, ctx, program, wmm, Arch.NONE, settings).equals(expected));
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