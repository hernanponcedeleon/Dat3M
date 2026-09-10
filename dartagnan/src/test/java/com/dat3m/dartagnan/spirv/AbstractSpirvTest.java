package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.nio.file.Path;
import java.util.EnumSet;

public abstract class AbstractSpirvTest extends AbstractVerificationTaskSolverTest {

    private final Arch target;
    private final Path targetModelPath;
    private final Path programPath;
    private final int bound;
    private final ResultStatus expected;

    protected AbstractSpirvTest(Arch target, String programPath, int bound, ResultStatus expected) {
        this.target = target;
        this.targetModelPath = ResourceHelper.getCatPath(target, null);
        this.programPath = ResourceHelper.getTestResourcePath(programPath);
        this.bound = bound;
        this.expected = expected;
    }

    protected Property getTestedProperty() { return Property.PROGRAM_SPEC; }

    protected ProgressModel.Hierarchy getProgressModel() { return ProgressModel.defaultHierarchy(); }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withBound(bound)
                .withTarget(target)
                .withProgressModel(getProgressModel())
                .withOption(OptionNames.PHANTOM_REFERENCES, "true");
    }

    @Override
    protected Path getTargetModelPath() { return targetModelPath; }

    @Override
    protected Path getProgramPath() { return programPath; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(getTestedProperty()); }

    @Override
    protected ResultStatus getExpected() { return expected; }
}
