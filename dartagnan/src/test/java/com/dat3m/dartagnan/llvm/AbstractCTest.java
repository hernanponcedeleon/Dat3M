package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.*;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.nio.file.Path;
import java.util.EnumSet;

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

    protected String getProgramPathString() { return "%s.ll"; }

    protected int getBound() {
        return 1;
    }

    protected Solvers getSolver() {
        return Solvers.Z3;
    }

    protected String getWmmName() {
        return null;
    }

    protected ProgressModel.Hierarchy getProgressModel() {
        return ProgressModel.defaultHierarchy();
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(getSolver())
                .withBound(getBound())
                .withTarget(target)
                .withProgressModel(getProgressModel())
                .withOption(OptionNames.PHANTOM_REFERENCES, "true");
    }

    @Override
    protected Path getTargetModelPath() { return ResourceHelper.getCatPath(target, getWmmName()); }

    @Override
    protected Path getProgramPath() { return ResourceHelper.getTestResourcePath(getProgramPathString().formatted(name)); }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.PROGRAM_SPEC); }

    @Override
    protected ResultStatus getExpected() { return expected; }
}
