package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
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

public abstract class AbstractComparisonTest extends AbstractVerificationTaskSolverTest {

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

    // =================== Modifiable behavior ====================

    protected String getSourceWmmName() { return null; }

    protected String getTargetWmmName() { return null; }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return Task.builder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withOption(PHANTOM_REFERENCES, "true")
                .withOption(INITIALIZE_REGISTERS, "true");
    }

    @Override
    protected Path getProgramPath() { return path; }

    @Override
    protected Path getTargetWmmPath() { return ResourceHelper.getCatPath(target, getTargetWmmName()); }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.PROGRAM_SPEC); }

    @Override
    protected ResultStatus getExpected() throws Exception {
        final VerificationTask task = getSourceTask();
        try (VerificationTaskSolver sourceSolver = VerificationTaskSolver.createWithMethod(task, Method.EAGER)
                .withShutdownManager(shutdownManager.get())) {
            sourceSolver.run();
            return sourceSolver.getResultStatus();
        }
    }

    @Override
    protected boolean isLazyMethodEnabled() { return false; }

    private VerificationTask getSourceTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder().withTarget(source);
        final Program program = parseProgram(path);
        final String wmmName = getSourceWmmName();
        final Wmm wmm = parseWmm(ResourceHelper.getCatPath(source, wmmName));
        return task.build(program, wmm, getTestedProperties());
    }
}
