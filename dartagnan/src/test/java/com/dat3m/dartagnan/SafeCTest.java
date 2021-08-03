package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.ARM8;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;
import static com.dat3m.dartagnan.wmm.utils.Arch.TSO;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class SafeCTest {

	static final int TIMEOUT = 180000;

    private final String path;
    private final Wmm wmm;
    private final Arch target;
    private final Settings settings;
    private final Result expected;
    private SolverContext ctx;

	@Parameterized.Parameters(name = "{index}: {0} target={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm tso = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/tso.cat"));
        Wmm power = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/power.cat"));
        Wmm arm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/aarch64.cat"));

        Settings s1 = new Settings(Alias.CFIS, 1, TIMEOUT);

        List<Object[]> data = new ArrayList<>();

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-O0.bpl", power, POWER, s1, UNKNOWN});
        // These expected result were obtained from refinement. Cannot guarantee they are correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-acq2rx-O0.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx-O0.bpl", tso, TSO, s1, UNKNOWN});
        // This two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx-O0.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ttas-5-rel2rx-O0.bpl", power, POWER, s1, FAIL});

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-O0.bpl", power, POWER, s1, UNKNOWN});
        // We don't yet know what expected should be and currently we timeout
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-acq2rx-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-acq2rx-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-acq2rx-O0.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-rel2rx-O0.bpl", tso, TSO, s1, UNKNOWN});
        // These expected result were obtained from refinement. Cannot guarantee they are correct
        // This two I expect to be correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-rel2rx-O0.bpl", arm, ARM8, s1, FAIL});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/ticketlock-6-rel2rx-O0.bpl", power, POWER, s1, FAIL});

        // Known to be safe
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-O0.bpl", power, POWER, s1, UNKNOWN});
        // These expected result were obtained from refinement. Cannot guarantee they are correct
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-acq2rx-futex-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-acq2rx-futex-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-acq2rx-futex-O0.bpl", power, POWER, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-rel2rx-futex-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-rel2rx-futex-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex-4-rel2rx-futex-O0.bpl", power, POWER, s1, UNKNOWN});

        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-4-O0.bpl", tso, TSO, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-4-O0.bpl", arm, ARM8, s1, UNKNOWN});
        data.add(new Object[]{TEST_RESOURCE_PATH + "locks/mutex_musl-4-O0.bpl", power, POWER, s1, UNKNOWN});

        return data;
    }

    public SafeCTest(String path, Wmm wmm, Arch target, Settings settings, Result expected) {
        this.path = path;
        this.wmm = wmm;
        this.target = target;
        this.settings = settings;
        this.expected = expected;
    }
    
    private void initSolverContext() throws Exception {
        Configuration config = Configuration.builder()
        		.setOption("solver.z3.usePhantomReferences", "true")
        		.build();
		ctx = SolverContextFactory.createSolverContext(
                config, 
                BasicLogManager.create(config), 
                ShutdownManager.create().getNotifier(), 
                Solvers.Z3);
    }

    @Test(timeout = TIMEOUT)
    public void test() {
    	try {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, target, settings);
            initSolverContext();
            assertEquals(expected, runAnalysisAssumeSolver(ctx, task));
            ctx.close();
        } catch (Exception e){
            fail("Missing resource file");
        }
    }
}