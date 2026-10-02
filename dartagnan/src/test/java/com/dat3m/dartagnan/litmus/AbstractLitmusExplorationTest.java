package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.test.AbstractEnumerationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.verification.Task;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.utils.Utils.hasExtension;

public abstract class AbstractLitmusExplorationTest extends AbstractEnumerationTaskSolverTest {

    protected final Arch target;
    protected final Path programPath;
    private final int expectedNumStates;

    protected AbstractLitmusExplorationTest(Arch target, Path programPath, int expectedNumStates) {
        this.target = target;
        this.programPath = programPath;
        this.expectedNumStates = expectedNumStates;
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath, String arch) throws IOException {
        return buildLitmusTests(litmusPath, arch, "");
    }

    static Iterable<Object[]> buildLitmusTests(String litmusPath, String arch, String postfix) throws IOException {
        final Path expectedPath = ResourceHelper.getTestResourcePath(arch + postfix + "-expected-exploration.csv");
        final Map<Path, Integer> expectedResults = ResourceHelper.parseExpectedExplorationResults(expectedPath,
                ResourceHelper::getRootPath);
        final Set<Path> skip = ResourceHelper.getSkipSet();
        final Function<Path, Integer> expected = path -> !skip.contains(path) ? expectedResults.get(path) : null;
        return buildLitmusTests(ResourceHelper.getRootPath(litmusPath), expected);
    }

    static Iterable<Object[]> buildLitmusTests(Path litmusPath, Function<Path, Integer> expected) throws IOException {
        try (Stream<Path> fileStream = Files.walk(litmusPath)) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> hasExtension(f, TestHelper.EXTENSION_LITMUS))
                    .map(f -> new Object[]{f, expected.apply(f)}).filter(f -> f[1] != null).toList();
        }
    }

    // =================== Modifiable behavior ====================

    protected String getTargetWmmName() { return null; }

    protected ProgressModel.Hierarchy getProgressModel() { return ProgressModel.defaultHierarchy(); }

    protected int getBound() { return 1; }

    @Override
    protected long getTimeoutSeconds() { return 10; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withBound(getBound())
                .withTarget(target)
                .withProgressModel(getProgressModel())
                .withOption(PHANTOM_REFERENCES, "true")
                .withOption(INITIALIZE_REGISTERS, "true");
    }

    @Override
    protected Path getTargetWmmPath() { return ResourceHelper.getCatPath(target, getTargetWmmName()); }

    @Override
    protected Path getProgramPath() { return programPath; }

    @Override
    protected int getExpectedNumStates() { return expectedNumStates; }

}
