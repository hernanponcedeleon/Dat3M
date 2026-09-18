package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.test.Provider;
import com.dat3m.dartagnan.test.RequestShutdownOnError;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static org.junit.Assert.assertEquals;

public abstract class AbstractComparisonTest {

    private final Arch source;
    private final Arch target;
    private final Path path;

    AbstractComparisonTest(Arch source, Arch target, Path path) {
        this.source = source;
        this.target = target;
        this.path = path;
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath) throws IOException {
        Set<Path> skip = ResourceHelper.getSkipSet();
        try (Stream<Path> fileStream = Files.walk(getRootPath(litmusPath))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, EXTENSION_LITMUS))
                    .filter(f -> !skip.contains(f))
                    .collect(ArrayList::new,
                            (l, f) -> l.add(new Object[]{f}), ArrayList::addAll);
        }
    }

    @Test
    public void testAssume() throws Exception { testMethod(Method.EAGER); }

    // =================== Modifiable behavior ====================

    protected String getSourceWmmName() { return null; }

    protected String getTargetWmmName() { return null; }

    protected EnumSet<Property> getProperty() { return EnumSet.of(Property.PROGRAM_SPEC); }

    protected long getTimeout() { return 10000; }

    protected Task.TaskBuilder getTaskBuilder() {
        return Task.builder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withOption(PHANTOM_REFERENCES, "true")
                .withOption(INITIALIZE_REGISTERS, "true");
    }

    // ============================================================

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    private final Timeout timeout = Timeout.millis(getTimeout());
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(timeout);

    private void testMethod(Method method) throws Exception {
        try (VerificationTaskSolver s1 = VerificationTaskSolver.createWithMethod(getTask(false), method)
                    .withShutdownManager(shutdownManagerProvider.get());
            VerificationTaskSolver s2 = VerificationTaskSolver.createWithMethod(getTask(true), method)
                    .withShutdownManager(shutdownManagerProvider.get())) {
            s1.run();
            s2.run();
            assertEquals(s1.getResult().hasModel(), s2.getResult().hasModel());
        }
    }

    private VerificationTask getTask(boolean isTarget) throws Exception {
        final Arch architecture = isTarget ? target : source;
        final Task.TaskBuilder task = getTaskBuilder().withTarget(architecture);
        final Program program = parseProgram(path);
        final String wmmName = isTarget ? getTargetWmmName() : getSourceWmmName();
        final Wmm wmm = parseWmm(ResourceHelper.getCatPath(architecture, wmmName));
        return task.build(program, wmm, getProperty());
    }
}
