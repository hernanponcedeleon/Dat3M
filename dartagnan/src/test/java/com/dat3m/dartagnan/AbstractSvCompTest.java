package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public abstract class AbstractSvCompTest {

	public static final int TIMEOUT = 180000;

    private final String path;
    private final Wmm wmm;
    private final Settings settings;
    private Result expected;

    public AbstractSvCompTest(String path, Wmm wmm, Settings settings) {
        this.path = path;
        this.wmm = wmm;
        this.settings = settings;
    }

    @Test(timeout = TIMEOUT)
    public void test() {
        Context ctx = null;
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            ctx = new Context();
            Solver solver = ctx.mkSolver();
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysis(solver, ctx, task));
        } catch (IOException e){
            fail("Missing resource file");
        } finally {
            if(ctx != null) {
                ctx.close();
            }
        }
    }

    @Test(timeout = TIMEOUT)
    public void testIncremental() {
        Context ctx = null;
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            ctx = new Context();
            Solver solver = ctx.mkSolver();
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysisIncrementalSolver(solver, ctx, task));
        } catch (IOException e){
            fail("Missing resource file");
        }  finally {
            if(ctx != null) {
                ctx.close();
            }
        }
    }

    @Test(timeout = TIMEOUT)
    public void testAssume() {
        Context ctx = null;
        try {
            String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
            expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            ctx = new Context();
            Solver solver = ctx.mkSolver();
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysisAssumeSolver(solver, ctx, task));
            solver.reset();
        } catch (IOException e){
            fail("Missing resource file");
        }  finally {
            if(ctx != null) {
                ctx.close();
            }
        }
    }


	private Result readExpected(String property) {
		try (BufferedReader br = new BufferedReader(new FileReader(property))) {
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