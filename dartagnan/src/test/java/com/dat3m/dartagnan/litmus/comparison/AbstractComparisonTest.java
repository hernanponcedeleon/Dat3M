package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.litmus.AbstractLitmusTest;
import com.dat3m.dartagnan.program.Program;
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

public abstract class AbstractComparisonTest extends AbstractLitmusTest {

    private final Arch source;

    AbstractComparisonTest(Arch source, Arch target, Path path) {
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

    @Override
    protected ResultStatus getExpected() throws Exception {
        final VerificationTask task = getSourceTask();
        try (VerificationTaskSolver sourceSolver = VerificationTaskSolver.createWithMethod(task, Method.EAGER)
                .withShutdownManager(shutdownManager.get())) {
            sourceSolver.run();
            return sourceSolver.getResultStatus();
        }
    }

    private VerificationTask getSourceTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder().withTarget(source);
        final Program program = parseProgram(programPath);
        final String wmmName = getSourceWmmName();
        final Wmm wmm = parseWmm(ResourceHelper.getCatPath(source, wmmName));
        return task.build(program, wmm, getTestedProperties());
    }
}
