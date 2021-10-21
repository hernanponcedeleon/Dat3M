package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.rules.*;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisAssumeSolver;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class CLocksTestAlternative {


    static final int TIMEOUT = 1800000;

    private String path;
    private Arch target;
    private final Result expected;

    @ClassRule
    public static CSVLogger.Initialization csvInit = new CSVLogger.Initialization();

    private final Provider<Arch> targetProvider = () -> target;
    private final Provider<String> filePathProvider = PathProvider.addPrefix(() -> path, TEST_RESOURCE_PATH + "locks/");
    private final Provider<Settings> settingsProvider = SettingsProvider.builderWithDefaultValues().build(); // Default settings
    private final Provider<Program> programProvider = new ProgramFromFileProvider(filePathProvider);
    private final Provider<Wmm> wmmProvider = new WmmFromArchitectureProvider(targetProvider);
    private final Provider<VerificationTask> taskProvider = new TaskProvider(programProvider, wmmProvider, targetProvider, settingsProvider);
    private final Provider<SolverContext> contextProvider = new SolverContextProvider();
    private final Provider<ProverEnvironment> proverProvider = new ProverProvider(contextProvider, () -> new ProverOptions[] { ProverOptions.GENERATE_MODELS });

    private final CSVLogger csvLogger = new CSVLogger(filePathProvider);
    private final Timeout timeout = Timeout.millis(TIMEOUT);


    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(filePathProvider)
            .around(settingsProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(taskProvider)
            .around(csvLogger) // csvLogger needs to get created before the timeout rule to be able to detect timeouts
            .around(timeout)
            .around(contextProvider)// Context/Prover need to get created AFTER timeout due to threading issues!
            .around(proverProvider);


	@Parameterized.Parameters(name = "{index}: {0} target={1}")
    public static Iterable<Object[]> data() throws IOException {
		return Arrays.asList(new Object[][]{
	            {"ttas-5.bpl", TSO, UNKNOWN},
	            {"ttas-5.bpl", ARM8, UNKNOWN},
	            {"ttas-5.bpl", POWER, UNKNOWN},
	            {"ttas-5-acq2rx.bpl", TSO, UNKNOWN},
	            {"ttas-5-acq2rx.bpl", ARM8, UNKNOWN},
	            {"ttas-5-acq2rx.bpl", POWER, UNKNOWN},
	            {"ttas-5-rel2rx.bpl", TSO, UNKNOWN},
	            {"ttas-5-rel2rx.bpl", ARM8, FAIL},
	            {"ttas-5-rel2rx.bpl", POWER, FAIL},
	            {"ticketlock-3.bpl", TSO, UNKNOWN},
	            {"ticketlock-3.bpl", ARM8, UNKNOWN},
	            {"ticketlock-3.bpl", POWER, UNKNOWN},
	            {"ticketlock-3-acq2rx.bpl", TSO, UNKNOWN},
	            {"ticketlock-3-acq2rx.bpl", ARM8, UNKNOWN},
	            {"ticketlock-3-acq2rx.bpl", POWER, UNKNOWN},
	            {"ticketlock-3-rel2rx.bpl", TSO, UNKNOWN},
	            {"ticketlock-3-rel2rx.bpl", ARM8, FAIL},
	            {"ticketlock-3-rel2rx.bpl", POWER, FAIL},
                {"mutex-3.bpl", TSO, UNKNOWN},
                {"mutex-3.bpl", ARM8, UNKNOWN},
                {"mutex-3.bpl", POWER, UNKNOWN},
                {"mutex-3-acq2rx-futex.bpl", TSO, UNKNOWN},
                {"mutex-3-acq2rx-futex.bpl", ARM8, UNKNOWN},
                {"mutex-3-acq2rx-futex.bpl", POWER, UNKNOWN},
                {"mutex-3-acq2rx-lock.bpl", TSO, UNKNOWN},
                {"mutex-3-acq2rx-lock.bpl", ARM8, UNKNOWN},
                {"mutex-3-acq2rx-lock.bpl", POWER, UNKNOWN},
                {"mutex-3-rel2rx-futex.bpl", TSO, UNKNOWN},
                {"mutex-3-rel2rx-futex.bpl", ARM8, UNKNOWN},
                {"mutex-3-rel2rx-futex.bpl", POWER, UNKNOWN},
                {"mutex-3-rel2rx-unlock.bpl", TSO, UNKNOWN},
                {"mutex-3-rel2rx-unlock.bpl", ARM8, FAIL},
                {"mutex-3-rel2rx-unlock.bpl", POWER, FAIL},
                {"spinlock-5.bpl", TSO, UNKNOWN},
                {"spinlock-5.bpl", ARM8, UNKNOWN},
                {"spinlock-5.bpl", POWER, UNKNOWN},
                {"spinlock-5-acq2rx.bpl", TSO, UNKNOWN},
                {"spinlock-5-acq2rx.bpl", ARM8, UNKNOWN},
                {"spinlock-5-acq2rx.bpl", POWER, UNKNOWN},
                {"spinlock-5-rel2rx.bpl", TSO, UNKNOWN},
                {"spinlock-5-rel2rx.bpl", ARM8, FAIL},
                {"spinlock-5-rel2rx.bpl", POWER, FAIL},
                {"linuxrwlock-3.bpl", TSO, UNKNOWN},
                {"linuxrwlock-3.bpl", ARM8, UNKNOWN},
                {"linuxrwlock-3.bpl", POWER, UNKNOWN},
                {"linuxrwlock-3-acq2rx.bpl", TSO, UNKNOWN},
                {"linuxrwlock-3-acq2rx.bpl", ARM8, FAIL},
                {"linuxrwlock-3-acq2rx.bpl", POWER, FAIL},
                {"linuxrwlock-3-rel2rx.bpl", TSO, UNKNOWN},
                {"linuxrwlock-3-rel2rx.bpl", ARM8, FAIL},
                {"linuxrwlock-3-rel2rx.bpl", POWER, FAIL},
                {"mutex_musl-3.bpl", TSO, UNKNOWN},
                {"mutex_musl-3.bpl", ARM8, UNKNOWN},
                {"mutex_musl-3.bpl", POWER, UNKNOWN},
                {"mutex_musl-3-acq2rx-futex.bpl", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx-futex.bpl", ARM8, UNKNOWN},
                {"mutex_musl-3-acq2rx-futex.bpl", POWER, UNKNOWN},
                {"mutex_musl-3-acq2rx-lock.bpl", TSO, UNKNOWN},
                {"mutex_musl-3-acq2rx-lock.bpl", ARM8, UNKNOWN},
                {"mutex_musl-3-acq2rx-lock.bpl", POWER, UNKNOWN},
                {"mutex_musl-3-rel2rx-futex.bpl", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx-futex.bpl", ARM8, UNKNOWN},
                {"mutex_musl-3-rel2rx-futex.bpl", POWER, UNKNOWN},
                {"mutex_musl-3-rel2rx-unlock.bpl", TSO, UNKNOWN},
                {"mutex_musl-3-rel2rx-unlock.bpl", ARM8, FAIL},
                {"mutex_musl-3-rel2rx-unlock.bpl", POWER, FAIL}
        });

    }

    public CLocksTestAlternative(String path, Arch target, Result expected) {
        this.path = path;
        this.target = target;
        this.expected = expected;
    }

    @Test
    @CSVLogger.FileName("csv/assume")
    public void testAssume() throws Exception {
	    assertEquals(expected, runAnalysisAssumeSolver(contextProvider.get(), proverProvider.get(), taskProvider.get()));
    }

    @Test
    @CSVLogger.FileName("csv/refinement")
    public void testRefinement() throws Exception {
            assertEquals(expected, Refinement.runAnalysisSaturationSolver(contextProvider.get(), proverProvider.get(),
                    RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
    }
}