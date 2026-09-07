package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.nio.file.Path;
import java.util.EnumSet;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;

public abstract class AbstractCTest extends AbstractVerificationTaskSolverTest {

    protected String name;
    protected Arch target;
    protected ResultStatus expected;

    protected AbstractCTest(String name, Arch target, ResultStatus expected) {
        this.name = name;
        this.target = target;
        this.expected = expected;
    }

    // =================== Modifiable behavior ====================

    protected abstract long getTimeout();

    protected final Configuration getBaseConfiguration() throws InvalidConfigurationException {
        var configBase = Configuration.builder()
                .setOption(OptionNames.SOLVER, getSolver().name())
                .setOption(OptionNames.BOUND, Integer.toString(getBound()))
                .setOption(OptionNames.TARGET, target.name())
                .setOption(OptionNames.PHANTOM_REFERENCES, "true");

        return additionalConfig(configBase).build();
    }

    protected String getProgramPathPrefix() {
        return "";
    }

    protected String getProgramPathSuffix() {
        return ".ll";
    }

    protected int getBound() {
        return 1;
    }

    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        return builder;
    }

    protected Solvers getSolver() {
        return Solvers.Z3;
    }

    protected String getWmmName() {
        return null;
    }

    protected EnumSet<Property> getProperty() {
        return EnumSet.of(Property.PROGRAM_SPEC);
    }

    protected ProgressModel.Hierarchy getProgressModel() {
        return ProgressModel.defaultHierarchy();
    }

    // =============================================================

    // Provider rules
    private final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    private final Provider<Path> filePathProvider = this::getProgramPath;
    private final Provider<Integer> boundProvider = this::getBound;
    private final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    private final Provider<Wmm> wmmProvider = Providers.createWmmFromPath(this::getWmmPath);
    private final Provider<ProgressModel.Hierarchy> progressModelProvider = this::getProgressModel;
    private final Provider<Solvers> solverProvider = this::getSolver;
    private final Provider<EnumSet<Property>> propertyProvider = this::getProperty;
    private final Provider<Configuration> configurationProvider = Provider.fromSupplier(this::getBaseConfiguration);
    private final Provider<VerificationTask> taskProvider = Providers.createTask(programProvider, wmmProvider, propertyProvider, progressModelProvider, configurationProvider);

    // Special rules
    private final Timeout timeout = Timeout.millis(getTimeout());

    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(boundProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(progressModelProvider)
            .around(solverProvider)
            .around(propertyProvider)
            .around(configurationProvider)
            .around(taskProvider)
            .around(timeout);

    @Override
    protected void testSolver(Method method) throws Exception {
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskProvider.get(), method)
                .withShutdownManager(shutdownManagerProvider.get())) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }

    private Path getProgramPath() {
        return getTestResourcePath(getProgramPathPrefix() + name + getProgramPathSuffix());
    }

    private Path getWmmPath() { return ResourceHelper.getCatPath(target, getWmmName()); }
}
