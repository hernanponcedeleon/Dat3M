package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.EnumerationTask;
import com.dat3m.dartagnan.verification.EnumerationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND;
import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.OptionNames.SOLVER;
import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.parsers.program.ProgramParser.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.google.common.io.Files.getNameWithoutExtension;
import static org.junit.Assert.assertEquals;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3;

public abstract class AbstractLitmusExplorationTest {

    private Path path;
    private final int expectedStateCount;

    protected AbstractLitmusExplorationTest(Path path, int expectedStateCount) {
        this.path = path;
        this.expectedStateCount = expectedStateCount;
    }

    static Iterable<Object[]> buildLitmusExplorationTests(String litmusPath, String arch) throws IOException {
        Map<Path, Integer> expectedResults = ResourceHelper.getExpectedExplorationResults(arch);
        Set<Path> skip = ResourceHelper.getSkipSet();

        try (Stream<Path> fileStream = Files.walk(getRootPath(litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .filter(f -> !skip.contains(f))
                    .filter(expectedResults::containsKey)
                    .map(f -> new Object[]{f, expectedResults.get(f)})
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f[0], f[1]}), ArrayList::addAll);
        }
    }

    protected abstract Provider<Arch> getTargetProvider();

    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromArch(getTargetProvider());
    }

    protected Provider<ProgressModel.Hierarchy> getProgressModelProvider() {
        return ProgressModel::defaultHierarchy;
    }

    protected Provider<Integer> getBoundProvider() {
        return () -> 1;
    }

    protected long getTimeout() {
        return 30000;
    }

    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        return builder;
    }

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> targetProvider = getTargetProvider();
    protected final Provider<Path> filePathProvider = () -> path;
    protected final Provider<String> nameProvider = Provider.fromSupplier(() -> getNameWithoutExtension(path.getFileName().toString()));
    protected final Provider<Integer> boundProvider = getBoundProvider();
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmmProvider = getWmmProvider();
    protected final Provider<ProgressModel.Hierarchy> progressModelProvider = getProgressModelProvider();
    protected final Provider<Configuration> configProvider = Provider.fromSupplier(this::getConfiguration);
    protected final Provider<EnumerationTask> taskProvider = Providers.createEnumerationTask(
            programProvider, wmmProvider, progressModelProvider, configProvider);

    private final Timeout timeout = Timeout.millis(getTimeout());
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(nameProvider)
            .around(boundProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(progressModelProvider)
            .around(configProvider)
            .around(taskProvider)
            .around(timeout);

    private Configuration getConfiguration() throws InvalidConfigurationException {
        var configBase = Configuration.builder()
                .setOption(SOLVER, Z3.name())
                .setOption(BOUND, boundProvider.get().toString())
                .setOption(TARGET, targetProvider.get().name())
                .setOption(PHANTOM_REFERENCES, "true")
                .setOption(INITIALIZE_REGISTERS, "true");

        return additionalConfig(configBase).build();
    }

    @Test
    public void testStateCount() throws Exception {
        try (EnumerationTaskSolver solver = EnumerationTaskSolver.create(taskProvider.get())
                .withShutdownManager(shutdownManagerProvider.get())) {
            solver.run();
            assertEquals(path.toString(), expectedStateCount, solver.getResult().getEnumeratedStates().size());
        }
    }
}
