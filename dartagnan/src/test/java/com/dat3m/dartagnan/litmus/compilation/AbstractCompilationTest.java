package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;
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
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.utils.TestHelper.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static java.util.Collections.emptyList;
import static org.junit.Assert.assertEquals;

public abstract class AbstractCompilationTest {

    private final Arch source;
    private final Arch target;
    private final Path path;

    AbstractCompilationTest(Arch source, Arch target, Path path) {
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

    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.PROGRAM_SPEC); }

    protected long getTimeout() { return 10000; }

    protected Task.TaskBuilder getTaskBuilder() {
        return Task.builder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withOption(PHANTOM_REFERENCES, "true")
                .withOption(INITIALIZE_REGISTERS, "true");
    }

    // List of tests that are known to show bugs in the compilation scheme and thus the expected result should be FAIL instead of PASS
    protected List<Path> getCompilationBreakers() { return emptyList(); }

    // ============================================================

    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    private final Timeout timeout = Timeout.millis(getTimeout());
    private final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(timeout);

    private void testMethod(Method method) throws Exception {
        try (VerificationTaskSolver sourceSolver = VerificationTaskSolver.createWithMethod(getTask(false), method)
                .withShutdownManager(shutdownManagerProvider.get())) {
            if (!isCompilableToHardware(sourceSolver.getTask().getProgram())) {
                return;
            }
            sourceSolver.run();
            if (sourceSolver.getResult().hasModel()) {
                return;
            }
            // We found no model showing a specific behaviour (either positively or negatively),
            // so the compiled code should also not exhibit that behaviour, unless we
            // know the compilation is broken
            boolean compilationIsBroken = getCompilationBreakers().contains(path);
            try (VerificationTaskSolver targetSolver = VerificationTaskSolver.createWithMethod(getTask(true), method)
                    .withShutdownManager(shutdownManagerProvider.get())) {
                targetSolver.run();
                assertEquals(compilationIsBroken, targetSolver.getResult().hasModel());
            }
        }
    }

    private VerificationTask getTask(boolean isTarget) throws Exception {
        final Arch architecture = isTarget ? target : source;
        final Task.TaskBuilder task = getTaskBuilder().withTarget(architecture);
        final Program program = parseProgram(path);
        final String wmmName = isTarget ? getTargetWmmName() : getSourceWmmName();
        final Wmm wmm = parseWmm(ResourceHelper.getCatPath(architecture, wmmName));
        return task.build(program, wmm, getTestedProperties());
    }

    private static boolean isCompilableToHardware(Program program) {
        return program.getThreadEvents().stream().noneMatch(AbstractCompilationTest::isRcuOrSrcu);
    }

    private static boolean isRcuOrSrcu(Event e) {
        // The following have features (RCU and SRCU) that hardware models do not support
        return Stream.of(Tag.Linux.RCU_LOCK, Tag.Linux.RCU_UNLOCK, Tag.Linux.RCU_SYNC,
                        Tag.Linux.SRCU_LOCK, Tag.Linux.SRCU_UNLOCK, Tag.Linux.SRCU_SYNC,
                        Tag.Linux.AFTER_SRCU_READ_UNLOCK
                ).anyMatch(e::hasTag);
    }
}
