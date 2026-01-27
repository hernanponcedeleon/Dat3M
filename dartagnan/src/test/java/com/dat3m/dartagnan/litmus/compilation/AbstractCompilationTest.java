package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
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
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static java.util.Collections.emptyList;
import static org.junit.Assert.assertEquals;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3;

public abstract class AbstractCompilationTest {

    private String path;

    AbstractCompilationTest(String path) {
        this.path = path;
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath) throws IOException {
        Set<String> skip = ResourceHelper.getSkipSet();
        try (Stream<Path> fileStream = Files.walk(Paths.get(getRootPath(litmusPath)))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .map(Path::toString)
                    .filter(f -> f.endsWith("litmus"))
                    .filter(f -> !skip.contains(f))
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f}), ArrayList::addAll);
        }
    }


    // =================== Modifiable behavior ====================

    protected abstract Provider<Arch> getSourceProvider();
    protected Provider<Wmm> getSourceWmmProvider() {
        return Providers.createWmmFromArch(getSourceProvider());
    }
    protected abstract Provider<Arch> getTargetProvider();
    protected Provider<Wmm> getTargetWmmProvider() {
        return Providers.createWmmFromArch(getTargetProvider());
    }
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.PROGRAM_SPEC));
    }
    protected long getTimeout() { return 10000; }
    // List of tests that are known to show bugs in the compilation scheme and thus the expected result should be FAIL instead of PASS
    protected List<String> getCompilationBreakers() { return emptyList(); }

    protected final Configuration getConfiguration() throws InvalidConfigurationException {
        var configBase = Configuration.builder()
                .setOption(SOLVER, Z3.name())
                .setOption(TARGET, targetProvider.get().name())
                .setOption(PHANTOM_REFERENCES, "true")
                .setOption(INITIALIZE_REGISTERS, "true")
                .setOption(USE_INTEGERS, "true");

        return additionalConfig(configBase).build();
    }

    protected ConfigurationBuilder additionalConfig(ConfigurationBuilder builder) {
        return builder;
    }

    // ============================================================

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> sourceProvider = getSourceProvider();
    protected final Provider<Arch> targetProvider = getTargetProvider();
    protected final Provider<String> filePathProvider = () -> path;
    protected final Provider<Program> program1Provider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Program> program2Provider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmm1Provider = getSourceWmmProvider();
    protected final Provider<Wmm> wmm2Provider = getTargetWmmProvider();
    protected final Provider<EnumSet<Property>> propertyProvider = getPropertyProvider();
    protected final Provider<Configuration> configProvider = Provider.fromSupplier(this::getConfiguration);
    protected final Provider<VerificationTask> task1Provider = Providers.createTask(program1Provider, wmm1Provider, propertyProvider, sourceProvider, ProgressModel::defaultHierarchy, () -> 1, configProvider);
    protected final Provider<VerificationTask> task2Provider = Providers.createTask(program2Provider, wmm2Provider, propertyProvider, targetProvider, ProgressModel::defaultHierarchy, () -> 1, configProvider);
    
    private final Timeout timeout = Timeout.millis(getTimeout());
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(program1Provider)
            .around(program2Provider)
            .around(wmm1Provider)
            .around(wmm2Provider)
            .around(propertyProvider)
            .around(configProvider)
            .around(task1Provider)
            .around(task2Provider)
            .around(timeout);

    @Test
    public void testAssume() throws Exception {
        if(!isCompilableToHardware(program1Provider.get())) {
            return;
        }

        try (ModelChecker s1 = ModelChecker.create(task1Provider.get(), Method.EAGER);
             ModelChecker s2 = ModelChecker.create(task2Provider.get(), Method.EAGER)) {
            s1.setShutdownManager(shutdownManagerProvider.get());
            s2.setShutdownManager(shutdownManagerProvider.get());

            s1.run();
            if (!s1.hasModel()) {
                // We found no model showing a specific behaviour (either positively or negatively),
                // so the compiled code should also not exhibit that behaviour, unless we
                // know the compilation is broken
                boolean compilationIsBroken = getCompilationBreakers().contains(path);
                s2.run();
                assertEquals(compilationIsBroken, s2.hasModel());
            }
        }
    }

    private static boolean isCompilableToHardware(Program program) {
        return program.getThreadEvents().stream().noneMatch(AbstractCompilationTest::isRcuOrSrcu);
    }

    private static boolean isRcuOrSrcu(Event e) {
        // The following have features (RCU and SRCU) that hardware models do not support
        return Stream.of(
                Tag.Linux.RCU_LOCK, Tag.Linux.RCU_UNLOCK, Tag.Linux.RCU_SYNC,
                Tag.Linux.SRCU_LOCK, Tag.Linux.SRCU_UNLOCK, Tag.Linux.SRCU_SYNC)
                .anyMatch(e::hasTag);
    }
}
