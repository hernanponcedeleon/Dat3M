package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
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

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.parsers.program.ProgramParser.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.google.common.io.Files.getNameWithoutExtension;
import static org.junit.Assert.assertEquals;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3;

public abstract class AbstractLitmusTest extends AbstractVerificationTaskSolverTest {

    protected final Arch target;
    protected final Path programPath;
    protected final ResultStatus expected;
    private static Map<Path, ResultStatus> expectedResults;

    AbstractLitmusTest(Arch target, Path programPath, ResultStatus expected) {
        this.target = target;
        this.programPath = programPath;
        this.expected = expected;
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath, String arch) throws IOException {
        return buildLitmusTests(litmusPath, arch, "");
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath, String arch, String postfix) throws IOException {
        expectedResults = ResourceHelper.getExpectedResults(arch, postfix);
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


    // =================== Modifiable behavior ====================

    protected final Configuration getConfiguration() throws InvalidConfigurationException {
        var configBase = Configuration.builder()
                .setOption(SOLVER, Z3.name())
                .setOption(BOUND, Integer.toString(getBound()))
                .setOption(TARGET, target.name())
                .setOption(PHANTOM_REFERENCES, "true")
                .setOption(INITIALIZE_REGISTERS, "true");

        return additionalConfig(configBase).build();
    }

    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        return builder;
    }

    protected String getWmmName() { return null; }

    protected Property getTestedProperty() { return Property.PROGRAM_SPEC; }

    protected ProgressModel.Hierarchy getProgressModel() { return ProgressModel.defaultHierarchy(); }

    protected int getBound() { return 1; }

    protected long getTimeout() { return 10000; }

    // ============================================================

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<String> nameProvider
            = () -> getNameWithoutExtension(getProgramPath().getFileName().toString());
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(this::getProgramPath);
    protected final Provider<Wmm> wmmProvider = Providers.createWmmFromPath(this::getWmmPath);
    protected final Provider<Configuration> configProvider = Provider.fromSupplier(this::getConfiguration);
    protected final Provider<VerificationTask> taskProvider = Providers.createTask(
            programProvider, wmmProvider, this::getTestedProperties, this::getProgressModel, configProvider);

    private final Timeout timeout = Timeout.millis(getTimeout());
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(nameProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(configProvider)
            .around(taskProvider)
            .around(timeout);

    @Override
    protected boolean isLazyMethodEnabled() {
        return false;
    }

    @Override
    protected void testSolver(Method method) throws Exception {
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskProvider.get(), method)
                .withShutdownManager(shutdownManagerProvider.get())) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }

    private Path getProgramPath() { return programPath; }
    private Path getWmmPath() { return ResourceHelper.getCatPath(target, getWmmName()); }
    private EnumSet<Property> getTestedProperties() { return EnumSet.of(getTestedProperty()); }
}
