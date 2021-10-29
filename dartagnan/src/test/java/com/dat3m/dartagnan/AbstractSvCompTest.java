package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
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
             ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "two", ""), true)))
        {
            writer.newLine();
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            // The flush() is required to write the content in the presence of timeouts
            writer.flush();
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisTwoSolvers(ctx, prover1, prover2, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(expected.toString()).append(", ").append(Long.toString(solvingTime));
        } catch (Exception e){
        	System.out.println(String.format("%s failed with the following msg: %s", path, e.getMessage()));
        }
    }

    @Test(timeout = TIMEOUT)
    public void testIncremental() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "incremental", ""), true)))
        {
            writer.newLine();
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            // The flush() is required to write the content in the presence of timeouts
            writer.flush();
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisIncrementalSolver(ctx, prover, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(expected.toString()).append(", ").append(Long.toString(solvingTime));
        } catch (Exception e){
        	System.out.println(String.format("%s failed with the following msg: %s", path, e.getMessage()));
        }
    }
    
    //@Test(timeout = TIMEOUT)
    public void testAssume() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "assume", ""), true)))
        {
            writer.newLine();
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            // The flush() is required to write the content in the presence of timeouts
            writer.flush();
        	String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
        	expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            long start = System.currentTimeMillis();
            assertEquals(expected, runAnalysisAssumeSolver(ctx, prover, task));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(expected.toString()).append(", ").append(Long.toString(solvingTime));
        } catch (Exception e){
        	System.out.println(String.format("%s failed with the following msg: %s", path, e.getMessage()));
        }
    }

    //@Test(timeout = TIMEOUT)
    public void testRefinement() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "refinement", ""), true)))
        {
            writer.newLine();
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            // The flush() is required to write the content in the presence of timeouts
            writer.flush();
            String property = path.substring(0, path.lastIndexOf("-")) + ".yml";
            expected = readExpected(property);
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            writer.append(path.substring(path.lastIndexOf("/") + 1)).append(", ");
            long start = System.currentTimeMillis();
            assertEquals(expected, Refinement.runAnalysisSaturationSolver(ctx, prover,
                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task)));
            long solvingTime = System.currentTimeMillis() - start;
            writer.append(expected.toString()).append(", ").append(Long.toString(solvingTime));
        } catch (Exception e){
        	System.out.println(String.format("%s failed with the following msg: %s", path, e.getMessage()));
        }
    }

	private Result readExpected(String property) {
		try (BufferedReader br = new BufferedReader(new FileReader(property))) {
		    while (!(br.readLine()).contains("unreach-call.prp")) {
		       continue;
		    }
		    return br.readLine().contains("false") ? FAIL : PASS;

		} catch (Exception e) {
			System.out.println(String.format("%s failed with the following msg: %s", path, e.getMessage()));
		}
		return null;
	}
}