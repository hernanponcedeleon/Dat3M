package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.utils.ResourceHelper.*;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class CLocksTest {

	static final int TIMEOUT = 600000;

    private final String path;
    private final Wmm wmm;
    private final Arch target;
    private final int bound;
    private final Result expected;

	@Parameterized.Parameters(name = "{index}: {0} target={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm tso = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/tso.cat"));
        Wmm power = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/power.cat"));
        Wmm arm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/aarch64.cat"));

        int s1 = 1;

    	// We want the files to be created every time we run the unit tests
        initialiseCSVFile(CLocksTest.class, "two-solvers");
        initialiseCSVFile(CLocksTest.class, "incremental");
        initialiseCSVFile(CLocksTest.class, "assume");
        initialiseCSVFile(CLocksTest.class, "refinement");

		List<Object[]> data = new ArrayList<>();

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5.bpl", power, POWER, s1, UNKNOWN});

        // These expected result were obtained from refinement. Cannot guarantee they are correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx.bpl", tso, TSO, s1, UNKNOWN});
        // These two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx.bpl", power, POWER, s1, FAIL});

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3.bpl", power, POWER, s1, UNKNOWN});

        // We don't yet know what expected should be and currently we timeout
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-acq2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-acq2rx.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-acq2rx.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-rel2rx.bpl", tso, TSO, s1, UNKNOWN});

        // These expected result were obtained from refinement. Cannot guarantee they are correct
        // These two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-rel2rx.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-3-rel2rx.bpl", power, POWER, s1, FAIL});

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3.bpl", power, POWER, s1, UNKNOWN});

        // These expected result were obtained from refinement. Cannot guarantee they are correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-futex.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-futex.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-futex.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-lock.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-lock.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-acq2rx-lock.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-futex.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-futex.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-futex.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-unlock.bpl", tso, TSO, s1, UNKNOWN});
        // These two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-unlock.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-3-rel2rx-unlock.bpl", power, POWER, s1, FAIL});

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5.bpl", power, POWER, s1, UNKNOWN});
        // These I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-acq2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-acq2rx.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-acq2rx.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-rel2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-rel2rx.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/spinlock-5-rel2rx.bpl", power, POWER, s1, FAIL});
        
        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3.bpl", power, POWER, s1, UNKNOWN});
        // These I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-acq2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-acq2rx.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-acq2rx.bpl", power, POWER, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-rel2rx.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-rel2rx.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/linuxrwlock-3-rel2rx.bpl", power, POWER, s1, FAIL});
        
        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3.bpl", power, POWER, s1, UNKNOWN});

        // These expected result were obtained from refinement. Cannot guarantee they are correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-futex.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-futex.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-futex.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-lock.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-lock.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-acq2rx-lock.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-futex.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-futex.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-futex.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-unlock.bpl", tso, TSO, s1, UNKNOWN});
        // This two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-unlock.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-3-rel2rx-unlock.bpl", power, POWER, s1, FAIL});

        return data;
    }

    public CLocksTest(String path, Wmm wmm, Arch target, int bound, Result expected) {
        this.path = path;
        this.wmm = wmm;
        this.target = target;
        this.bound = bound;
        this.expected = expected;
    }

//    @Test(timeout = TIMEOUT)
    public void testAssume() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "assume"), true)))
        {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withSettings(bound,Alias.CFIS,TIMEOUT).withTarget(target)
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

    @Test(timeout = TIMEOUT)
    public void testRefinement() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(getClass(), "refinement"), true)))
        {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withSettings(bound,Alias.CFIS,TIMEOUT).withTarget(target)
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
}