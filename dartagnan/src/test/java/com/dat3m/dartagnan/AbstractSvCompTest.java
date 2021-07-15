package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.SolverContext;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

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
    private SolverContext ctx;
    
    public AbstractSvCompTest(String path, Wmm wmm, Settings settings) {
        this.path = path;
        this.wmm = wmm;
        this.settings = settings;
    }

    private void initSolverContext() throws Exception {
        Configuration config = Configuration.defaultConfiguration();
        ctx = SolverContextFactory.createSolverContext(
                config, 
                BasicLogManager.create(config), 
                ShutdownManager.create().getNotifier(), 
                Solvers.Z3);
    }
    
//    @Test(timeout = TIMEOUT)
    public void test() {
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            initSolverContext();
            assertEquals(expected, runAnalysis(ctx, task));
            ctx.close();
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    @Test(timeout = TIMEOUT)
    public void testIncremental() {
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            initSolverContext();
            assertEquals(expected, runAnalysisIncrementalSolver(ctx, task));
            ctx.close();
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    @Test(timeout = TIMEOUT)
    public void testAssume() {
        try {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            initSolverContext();
            assertEquals(expected, runAnalysisAssumeSolver(ctx, task));
            ctx.close();
        } catch (Exception e){
            fail(e.getMessage());
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