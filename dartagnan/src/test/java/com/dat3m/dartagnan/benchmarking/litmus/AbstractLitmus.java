package com.dat3m.dartagnan.benchmarking.litmus;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.verification.solving.TwoSolvers;
import com.dat3m.dartagnan.wmm.Wmm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;

import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.utils.ResourceHelper.*;
import static com.google.common.io.Files.getNameWithoutExtension;
import static org.junit.Assert.assertEquals;

public abstract class AbstractLitmus {

    private static final boolean DO_INITIALIZE_REGISTERS = true;

    private String path;
    private String arch;
    private final Result expected;

    AbstractLitmus(String path, String arch, Result expected) {
        this.path = path;
        this.arch = arch;
        this.expected = expected;
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath, String arch) throws IOException {
        int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults(arch);
        Set<String> skip = ResourceHelper.getSkipSet();

        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .map(Path::toString)
                    .filter(f -> f.endsWith("litmus"))
                    .filter(f -> !skip.contains(f))
                    .filter(f -> expectationMap.containsKey(f.substring(n)))
                    .map(f -> new Object[]{f, expectationMap.get(f.substring(n))})
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f[0], arch, f[1]}), ArrayList::addAll);
        }
    }


    // =================== Modifiable behavior ====================

    protected abstract Provider<Arch> getTargetProvider();

    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromArch(getTargetProvider());
    }

    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> Property.getDefault());
    }

    protected Provider<Integer> getBoundProvider() {
        return Provider.fromSupplier(() -> 1);
    }

    protected long getTimeout() { return 10000; }

    // ============================================================


    @ClassRule
    public static CSVLogger.Initialization csvInit = CSVLogger.Initialization.create();

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<Arch> targetProvider = getTargetProvider();
    protected final Provider<String> filePathProvider = () -> path;
    protected final Provider<String> nameProvider = Provider.fromSupplier(() -> getNameWithoutExtension(Path.of(path).getFileName().toString()));
    protected final Provider<Integer> boundProvider = getBoundProvider();
    protected final Provider<Program> programProvider = Providers.createProgramFromPath(filePathProvider);
    protected final Provider<Wmm> wmmProvider = getWmmProvider();
    protected final Provider<EnumSet<Property>> propertyProvider = getPropertyProvider();
    protected final Provider<Result> expectedResultProvider = Provider.fromSupplier(() ->
    	getExpectedResults(arch).get(filePathProvider.get().substring(filePathProvider.get().indexOf("/") + 1)));
    protected final Provider<Configuration> configProvider = Provider.fromSupplier(() -> Configuration.builder().setOption(INITIALIZE_REGISTERS, String.valueOf(DO_INITIALIZE_REGISTERS)).build());
    protected final Provider<VerificationTask> taskProvider = Providers.createTask(programProvider, wmmProvider, propertyProvider, targetProvider, boundProvider, configProvider);
    protected final Provider<SolverContext> contextProvider = Providers.createSolverContextFromManager(shutdownManagerProvider);
    protected final Provider<ProverEnvironment> proverProvider = Providers.createProverWithFixedOptions(contextProvider, ProverOptions.GENERATE_MODELS);
    protected final Provider<ProverEnvironment> prover2Provider = Providers.createProverWithFixedOptions(contextProvider, ProverOptions.GENERATE_MODELS);

    private final Timeout timeout = Timeout.millis(getTimeout());
    private final CSVLogger csvLogger = CSVLogger.create(filePathProvider, expectedResultProvider);
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(nameProvider)
            .around(boundProvider)
            .around(programProvider)
            .around(wmmProvider)
            .around(propertyProvider)
            .around(configProvider)
            .around(taskProvider)
            .around(expectedResultProvider)
            .around(csvLogger)
            .around(timeout)
            // Context/Prover need to be created inside test-thread spawned by <timeout>
            .around(contextProvider)
            .around(proverProvider)
            .around(prover2Provider);



    @Test
    @CSVLogger.FileName("csv/two-solvers")
    public void test() throws Exception {
        TwoSolvers s = TwoSolvers.run(contextProvider.get(), proverProvider.get(), prover2Provider.get(), taskProvider.get());
    	assertEquals(expected, s.getResult());
    }

    @Test
    @CSVLogger.FileName("csv/caat")
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}
