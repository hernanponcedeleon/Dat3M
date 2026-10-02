package com.dat3m.dartagnan.test;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.*;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;

import java.nio.file.Path;

import static org.junit.Assert.assertEquals;

public abstract class AbstractEnumerationTaskSolverTest {

    protected final Provider<ShutdownManager> shutdownManager = Provider.fromSupplier(ShutdownManager::create);

    @Test
    public void testStateCount() throws Exception {
        final EnumerationTask task = getTask();
        final int expectedNumStates = getExpectedNumStates();
        try (EnumerationTaskSolver solver = EnumerationTaskSolver.create(task)
                .withShutdownManager(shutdownManager.get())) {
            solver.run();
            assertEquals(expectedNumStates, solver.getResult().getEnumeratedStates().size());
        }
    }

    @Rule
    public RuleChain ruleChain() {
        return RuleChain.outerRule(shutdownManager)
                .around(RequestShutdownOnError.create(shutdownManager))
                .around(Timeout.seconds(getTimeoutSeconds()));
    }

    protected long getTimeoutSeconds() { return 600; }

    protected Task.TaskBuilder getTaskBuilder() { return Task.builder(); }

    protected abstract Path getProgramPath();

    protected abstract Path getTargetWmmPath();

    protected abstract int getExpectedNumStates() throws Exception;

    private EnumerationTask getTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder();
        final Program program = TestHelper.parseProgram(getProgramPath());
        final Wmm targetModel = TestHelper.parseWmm(getTargetWmmPath());
        return task.buildEnumerationTask(program, targetModel);
    }
}
