package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

/*
NOTE: We use these tests to collect benchmarks that are failing for some reason
(buggy, too slow, unsupported features etc.)
 */
@RunWith(Parameterized.class)
public class UnusedTestFails {

    static final int TIMEOUT = 600000;

    private final String path;
    private final Wmm wmm;
    private final Arch target;
    private final Settings settings;
    private final Result expected;

    public UnusedTestFails(String path, Wmm wmm, Arch target, Settings settings, Result expected) {
        this.path = path;
        this.wmm = wmm;
        this.target = target;
        this.settings = settings;
        this.expected = expected;
    }

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        String cat_file = GlobalSettings.ATOMIC_AS_LOCK ? "cat/svcomp-locks.cat" : "cat/svcomp.cat";
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat_file));

        Settings s2 = new Settings(Alias.CFIS, 1, TIMEOUT);

        List<Object[]> data = new ArrayList<>();
        //data.add(new Object[]{"../lfds/ms_datCAS-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../lfds/ms-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/ms-test-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/ttas-5-O0.bpl", wmm, s2});
        //data.add(new Object[]{"../output/mutex-4-O0.bpl", wmm, s2});

        return data;
    }

    //@Test(timeout = TIMEOUT)
    public void test() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS))
        {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, target, settings);
            assertEquals(expected, runAnalysisAssumeSolver(ctx, prover, task));
        } catch (Exception e){
            fail(e.getMessage());
        }
    }

    //@Test(timeout = TIMEOUT)
    public void testRefinement() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverEnvironment prover = ctx.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS))
        {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, target, settings);
            assertEquals(expected, Refinement.runAnalysisSaturationSolver(ctx, prover,
                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(task)));
        } catch (Exception e){
            fail(e.getMessage());
        }
    }
}