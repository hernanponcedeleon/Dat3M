package com.dat3m.dartagnan.test;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;

import java.nio.file.Path;
import java.util.EnumSet;

import static org.junit.Assert.assertEquals;
import static org.junit.Assume.assumeNotNull;
import static org.junit.Assume.assumeTrue;

public abstract class AbstractVerificationTaskSolverTest {

    protected final Provider<ShutdownManager> shutdownManager = Provider.fromSupplier(ShutdownManager::create);

    @Test
    public void testAssume() throws Exception {
        assumeTrue(isEagerMethodEnabled());
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        assumeTrue(isLazyMethodEnabled());
        testSolver(Method.LAZY);
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

    protected abstract EnumSet<Property> getTestedProperties();

    protected abstract ResultStatus getExpected() throws Exception;

    protected boolean isEagerMethodEnabled() { return true; }
    protected boolean isLazyMethodEnabled() { return true; }

    private void testSolver(Method method) throws Exception {
        final VerificationTask task = getTask();
        final ResultStatus expected = getExpected();
        assumeNotNull(expected);
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, method)
                .withShutdownManager(shutdownManager.get())) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }

    private VerificationTask getTask() throws Exception {
        final Task.TaskBuilder task = getTaskBuilder();
        final Program program = TestHelper.parseProgram(getProgramPath());
        final Wmm targetModel = TestHelper.parseWmm(getTargetWmmPath());
        final EnumSet<Property> properties = getTestedProperties();
        return task.build(program, targetModel, properties);
    }
}
