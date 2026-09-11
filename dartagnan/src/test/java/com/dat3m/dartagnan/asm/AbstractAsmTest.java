package com.dat3m.dartagnan.asm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.nio.file.Path;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.TERMINATION;

abstract class AbstractAsmTest extends AbstractVerificationTaskSolverTest {

    private final Arch target;
    private final String name;
    private final int bound;
    private final ResultStatus expected;

    protected AbstractAsmTest(Arch target, String name, int bound, ResultStatus expected) {
        this.target = target;
        this.name = name;
        this.bound = bound;
        this.expected = expected;
    }

    protected abstract String getProgramPathString();

    protected String getTargetWmmName() { return null; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(SolverContextFactory.Solvers.YICES2)
                .withBound(bound)
                .withTarget(target);
    }

    @Override
    protected Path getTargetWmmPath() { return ResourceHelper.getCatPath(target, getTargetWmmName()); }

    @Override
    protected Path getProgramPath() {
        return ResourceHelper.getTestResourcePath(getProgramPathString().formatted(name));
    }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(TERMINATION, PROGRAM_SPEC); }

    @Override
    protected ResultStatus getExpected() { return expected; }

    // NOTE: Recursion heavily impacts eager method's performance.
    @Override
    protected boolean isEagerMethodEnabled() { return !Arch.ARM7.equals(target) && !Arch.POWER.equals(target); }

    // TODO: Lazy method takes too long to run on ARM8, we have to investigate this.
    @Override
    protected boolean isLazyMethodEnabled() { return !Arch.ARM8.equals(target); }
}
