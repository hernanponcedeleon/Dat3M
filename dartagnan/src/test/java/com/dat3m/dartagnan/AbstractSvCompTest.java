package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.analysis.graphRefinement.RefinementTask;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

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

    //@Test(timeout = TIMEOUT)
    public void test() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover1 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysisTwoSolvers(ctx, prover1, prover2, task));
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    //@Test(timeout = TIMEOUT)
    public void testIncremental() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysisIncrementalSolver(ctx, prover, task));
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    //@Test(timeout = TIMEOUT)
    public void testAssume() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysisAssumeSolver(ctx, prover, task));
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    @Test(timeout = TIMEOUT)
    public void testRefinement() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
        {
            String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
            expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, Refinement.runAnalysisGraphRefinement(ctx, prover,
                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task)));
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