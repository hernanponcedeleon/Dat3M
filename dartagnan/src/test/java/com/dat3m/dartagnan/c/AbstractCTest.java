package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

import java.util.EnumSet;

import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

public abstract class AbstractCTest {

    protected String name;
    protected Arch target;
    protected Result expected;

    public AbstractCTest(String name, Arch target, Result expected) {
        this.name = name;
        this.target = target;
        this.expected = expected;
    }

    // =================== Modifiable behavior ====================

    protected Provider<String> getProgramPathProvider() {
    	return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + name + ".bpl");
    }

    protected abstract long getTimeout();

    protected Provider<Integer> getBoundProvider() {
        return Provider.fromSupplier(() -> 1);
    }

    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromArch(targetProvider);
    }

    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> Property.getDefault());
    }

    // =============================================================


    @ClassRule
    public static CSVLogger.Initialization csvInit = CSVLogger.Initialization.create();

    // Provider rules
    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> targetProvider = () -> target;
    protected final Provider<String> filePathProvider = getProgramPathProvider();
    protected final Provider<Integer> boundProvider = getBoundProvider();
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmmProvider = getWmmProvider();
    protected final Provider<EnumSet<Property>> propertyProvider = getPropertyProvider();
    protected final Provider<VerificationTask> taskProvider = Providers.createTask(programProvider, wmmProvider, propertyProvider, targetProvider, boundProvider, () -> Configuration.defaultConfiguration());
    protected final Provider<SolverContext> contextProvider = Providers.createSolverContextFromManager(shutdownManagerProvider);
    protected final Provider<ProverEnvironment> proverProvider = Providers.createProverWithFixedOptions(contextProvider, SolverContext.ProverOptions.GENERATE_MODELS);

    // Special rules
    protected final Timeout timeout = Timeout.millis(getTimeout());
    protected final CSVLogger csvLogger = CSVLogger.create(() -> name, () -> expected);
    protected final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(boundProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(propertyProvider)
            .around(taskProvider)
            .around(csvLogger)
            .around(timeout)
            // Context/Prover need to be created inside test-thread spawned by <timeout>
            .around(contextProvider)
            .around(proverProvider);

}
