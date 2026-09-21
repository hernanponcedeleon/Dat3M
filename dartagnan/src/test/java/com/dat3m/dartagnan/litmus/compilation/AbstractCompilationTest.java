package com.dat3m.dartagnan.litmus.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.litmus.AbstractLitmusTest;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Utils.hasExtension;
import static com.dat3m.dartagnan.test.TestHelper.*;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;

public abstract class AbstractCompilationTest extends AbstractLitmusTest {

    private final Arch source;

    AbstractCompilationTest(Arch source, Arch target, Path path) {
        super(target, path, null);
        this.source = source;
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

    // Tests that are known to show bugs in the compilation scheme and thus the expected result should be FAIL instead of PASS
    protected boolean isCompilationBroken() { return false; }

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
                case PASS -> isCompilationBroken() ? ResultStatus.FAIL : ResultStatus.PASS;
                case FAIL -> isCompilationBroken() ? ResultStatus.PASS : ResultStatus.FAIL;
                default -> sourceSolver.getResultStatus();
            };
        }
    }

    private VerificationTask getSourceTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder().withTarget(source);
        final Program program = parseProgram(programPath);
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
