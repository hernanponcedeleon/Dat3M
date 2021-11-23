package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.*;

import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public abstract class AbstractSvCompTest {

	public static final int TIMEOUT = 180000;

    private final String path;
    private final Wmm wmm;
    private final int bound;
    private Result expected;

    public AbstractSvCompTest(String path, Wmm wmm, int bound) {
        this.path = path;
        this.wmm = wmm;
        this.bound = bound;
    }

    //@Test(timeout = TIMEOUT)
    public void test() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover1 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "two-solvers"), true)))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withBound(bound)
                    .withSolverTimeout(TIMEOUT)
                    .build(program, wmm);
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisTwoSolvers(ctx, prover1, prover2, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ").append(Long.toString(solvingTime));
            writer.newLine();
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    @Test(timeout = TIMEOUT)
    public void testIncremental() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "incremental"), true)))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withBound(bound)
                    .withSolverTimeout(TIMEOUT)
                    .build(program, wmm);
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisIncrementalSolver(ctx, prover, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ").append(Long.toString(solvingTime));
            writer.newLine();
        } catch (Exception e){
            fail(e.getMessage());
        }
    }
    
    //@Test(timeout = TIMEOUT)
    public void testAssume() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "assume"), true)))
        {
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withBound(bound)
                    .withSolverTimeout(TIMEOUT)
                    .build(program, wmm);
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisAssumeSolver(ctx, prover, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ").append(Long.toString(solvingTime));
            writer.newLine();
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

//    @Test(timeout = TIMEOUT)
    public void testRefinement() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "refinement"), true)))
        {
            String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
            expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withBound(bound)
                    .withSolverTimeout(TIMEOUT)
                    .build(program, wmm);
            long start = System.currentTimeMillis();
            assertEquals(expected, Refinement.runAnalysisSaturationSolver(ctx, prover,
                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task)));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ").append(Long.toString(solvingTime));
            writer.newLine();
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