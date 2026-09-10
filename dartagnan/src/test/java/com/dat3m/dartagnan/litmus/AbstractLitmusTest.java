package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.EXTENSION_LITMUS;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;

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

    protected String getWmmName() { return null; }

    protected Property getTestedProperty() { return Property.PROGRAM_SPEC; }

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
    protected Path getTargetModelPath() { return ResourceHelper.getCatPath(target, getWmmName()); }

    @Override
    protected Path getProgramPath() { return programPath; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(getTestedProperty()); }

    @Override
    protected ResultStatus getExpected() { return expected; }

    @Override
    protected boolean isLazyMethodEnabled() { return false; }
}
