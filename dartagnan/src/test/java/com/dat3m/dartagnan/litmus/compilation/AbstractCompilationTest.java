package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
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
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static java.util.Collections.emptyList;

public abstract class AbstractCompilationTest extends AbstractVerificationTaskSolverTest {

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

    // =================== Modifiable behavior ====================

    protected String getSourceWmmName() { return null; }

    protected String getTargetWmmName() { return null; }

    // List of tests that are known to show bugs in the compilation scheme and thus the expected result should be FAIL instead of PASS
    protected List<Path> getCompilationBreakers() { return emptyList(); }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withTarget(target)
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
    protected boolean isLazyMethodEnabled() { return false; }

    // ============================================================

    @Override
    protected ResultStatus getExpected() throws Exception {
        final VerificationTask task = getSourceTask();
        if (!isCompilableToHardware(task.getProgram())) {
            return null;
        }
        try (VerificationTaskSolver sourceSolver = VerificationTaskSolver.createWithMethod(task, Method.EAGER)
                .withShutdownManager(shutdownManager.get())) {
            sourceSolver.run();
            if (sourceSolver.getResult().hasModel()) {
                return null;
            }
            // We found no model showing a specific behaviour (either positively or negatively),
            // so the compiled code should also not exhibit that behaviour, unless we
            // know the compilation is broken
            return switch (sourceSolver.getResultStatus()) {
                case PASS -> getCompilationBreakers().contains(path) ? ResultStatus.FAIL : ResultStatus.PASS;
                case FAIL -> getCompilationBreakers().contains(path) ? ResultStatus.PASS : ResultStatus.FAIL;
                default -> sourceSolver.getResultStatus();
            };
        }
    }

    private VerificationTask getSourceTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder().withTarget(source);
        final Program program = parseProgram(path);
        final Wmm wmm = parseWmm(ResourceHelper.getCatPath(source, getSourceWmmName()));
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
