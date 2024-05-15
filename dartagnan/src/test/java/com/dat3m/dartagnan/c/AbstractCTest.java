package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.EnumSet;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

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

    protected abstract long getTimeout();

    protected Configuration getConfiguration() throws InvalidConfigurationException {
        return Configuration.builder()
                .setOption(OptionNames.USE_INTEGERS, "true")
                .build();
    }

    protected Provider<String> getProgramPathProvider() {
        return () -> getTestResourcePath(name + ".ll");
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> 1;
    }

    protected Provider<Solvers> getSolverProvider() {
        return () -> Solvers.Z3;
    }

    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromArch(targetProvider);
    }

    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.PROGRAM_SPEC));
    }

    protected Provider<Configuration> getConfigurationProvider() {
        return Provider.fromSupplier(this::getConfiguration);
    }

    // =============================================================

    // Provider rules
    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> targetProvider = () -> target;
    protected final Provider<String> filePathProvider = getProgramPathProvider();
    protected final Provider<Integer> boundProvider = getBoundProvider();
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmmProvider = getWmmProvider();
    protected final Provider<Solvers> solverProvider = getSolverProvider();
    protected final Provider<EnumSet<Property>> propertyProvider = getPropertyProvider();
    protected final Provider<Configuration> configurationProvider = getConfigurationProvider();
    protected final Provider<VerificationTask> taskProvider = Providers.createTask(programProvider, wmmProvider, propertyProvider, targetProvider, boundProvider, configurationProvider);
    protected final Provider<SolverContext> contextProvider = Providers.createSolverContextFromManager(shutdownManagerProvider, solverProvider);
    protected final Provider<ProverEnvironment> proverProvider = Providers.createProverWithFixedOptions(contextProvider, SolverContext.ProverOptions.GENERATE_MODELS);

    // Special rules
    protected final Timeout timeout = Timeout.millis(getTimeout());

    protected final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(configurationProvider)
            .around(filePathProvider)
            .around(boundProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(solverProvider)
            .around(propertyProvider)
            .around(taskProvider)
            .around(timeout)
            // Context/Prover need to be created inside test-thread spawned by <timeout>
            .around(contextProvider)
            .around(proverProvider);

}
