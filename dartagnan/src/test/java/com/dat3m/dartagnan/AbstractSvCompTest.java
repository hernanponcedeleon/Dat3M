package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.analysis.Base.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.readExpected;
import static org.junit.Assert.assertEquals;

public abstract class AbstractSvCompTest {

    protected String name;
    protected int bound;

    public AbstractSvCompTest(String name, int bound) {
        this.name = name;
        this.bound = bound;
    }

    // =================== Modifiable behavior ====================

    protected abstract Provider<String> getProgramPathProvider();

    protected long getTimeout() { return 180000; }

    protected Provider<Settings> getSettingsProvider() {
        return Provider.fromSupplier(() -> new Settings(bound, 0));
    }

    protected Provider<Wmm> getWmmProvider() {
        return GlobalSettings.ATOMIC_AS_LOCK ?
                Providers.createWmmFromName(() -> "svcomp-locks") :
                Providers.createWmmFromName(() -> "svcomp");
    }

    @ClassRule
    public static CSVLogger.Initialization csvInit = CSVLogger.Initialization.create();

    // Provider rules
    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> targetProvider = () -> Arch.NONE;
    protected final Provider<String> filePathProvider = getProgramPathProvider();
    protected final Provider<Settings> settingsProvider = getSettingsProvider();
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmmProvider = getWmmProvider();
    protected final Provider<Result> expectedResultProvider = Provider.fromSupplier(() ->
    	readExpected(filePathProvider.get().substring(0, filePathProvider.get().lastIndexOf("-")) + ".yml", "unreach-call.prp"));
    protected final Provider<VerificationTask> taskProvider = Providers.createTask(programProvider, wmmProvider, targetProvider, settingsProvider);
    protected final Provider<SolverContext> contextProvider = Providers.createSolverContextFromManager(shutdownManagerProvider);
    protected final Provider<ProverEnvironment> proverProvider = Providers.createProverWithFixedOptions(contextProvider, SolverContext.ProverOptions.GENERATE_MODELS);
    protected final Provider<ProverEnvironment> prover2Provider = Providers.createProverWithFixedOptions(contextProvider, SolverContext.ProverOptions.GENERATE_MODELS);

    // Special rules
    protected final Timeout timeout = Timeout.millis(getTimeout());
    protected final CSVLogger csvLogger = CSVLogger.create(() -> name);
    protected final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(settingsProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(taskProvider)
            .around(expectedResultProvider)
            .around(csvLogger)
            .around(timeout)
            // Context/Prover need to be created inside test-thread spawned by <timeout>
            .around(contextProvider)
            .around(proverProvider)
            .around(prover2Provider);


    //@Test
    @CSVLogger.FileName("csv/two-solvers")
    public void testTwoSolvers() throws Exception {
        assertEquals(expectedResultProvider.get(),
                runAnalysisTwoSolvers(contextProvider.get(), proverProvider.get(), prover2Provider.get(), taskProvider.get()));
    }

//    @Test
    @CSVLogger.FileName("csv/assume")
    public void testAssume() throws Exception {
        assertEquals(expectedResultProvider.get(),
                runAnalysisAssumeSolver(contextProvider.get(), proverProvider.get(), taskProvider.get()));
    }

    @Test
    @CSVLogger.FileName("csv/incremental")
    public void testIncremental() throws Exception {
        assertEquals(expectedResultProvider.get(),
                runAnalysisIncrementalSolver(contextProvider.get(), proverProvider.get(), taskProvider.get()));
    }

    //@Test
    @CSVLogger.FileName("csv/refinement")
    public void testRefinement() throws Exception {
        assertEquals(expectedResultProvider.get(), Refinement.runAnalysisWMMSolver(contextProvider.get(), proverProvider.get(),
                RefinementTask.fromVerificationTaskWithDefaultBaselineWMM(taskProvider.get())));
    }
}
