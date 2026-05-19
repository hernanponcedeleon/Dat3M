package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.configuration.TimeSpanOption;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.concurrent.TimeUnit;

import static com.dat3m.dartagnan.configuration.OptionNames.METHOD;
import static com.dat3m.dartagnan.configuration.OptionNames.TIMEOUT;
import static com.dat3m.dartagnan.configuration.Property.DATARACEFREEDOM;

@Options
public class TaskSolver implements AutoCloseable {

    private static final Logger logger = LoggerFactory.getLogger(TaskSolver.class);

    // ================================== Configurables ==================================

    @Option(
            name = METHOD,
            description = "Solving method to be used.",
            toUppercase = true)
    private Method method = Method.getDefault();

    @Option(
            name = TIMEOUT,
            description = "Timeout before interrupting the task solver. Can specify time units ns, ms, s (default), min, and h.")
    @TimeSpanOption(min = 0, codeUnit = TimeUnit.MILLISECONDS, defaultUserUnit = TimeUnit.SECONDS)
    private int timeout = 0;

    private boolean hasTimeout() {
        return timeout > 0;
    }

    // ====================================== State ======================================

    private final VerificationTask task;

    private ModelChecker modelChecker;
    private IREvaluator model;
    private ShutdownManager shutdownManager;
    private long runtime = 0;

    public VerificationTask getTask() {
        return task;
    }

    // =================================== Construction ===================================

    private TaskSolver(VerificationTask task) throws InvalidConfigurationException {
        this.task = task;

        task.getConfig().inject(this);
    }

    public static TaskSolver create(VerificationTask task) throws InvalidConfigurationException {
        return new TaskSolver(task);
    }

    public static TaskSolver createWithMethod(VerificationTask task, Method method) throws InvalidConfigurationException {
        final TaskSolver solver = new TaskSolver(task);
        solver.method = method;
        return solver;
    }

    public TaskSolver withShutdownManager(ShutdownManager shutdownManager) {
        this.shutdownManager = shutdownManager;
        return this;
    }

    // ===================================== Solving =====================================

    private void initModelChecker() throws InvalidConfigurationException {
        Preconditions.checkState(modelChecker == null, "Model checker already initialized");

        if (task.getProperty().contains(DATARACEFREEDOM) && method != Method.EAGER) {
            // For DATARACEFREEDOM, we always use EAGER
            logger.warn("Method {} is not supported for property {}. Using EAGER instead.", method, DATARACEFREEDOM);
            method = Method.EAGER;
        }

        modelChecker = switch (method) {
            case EAGER -> AssumeSolver.create(task);
            case LAZY -> RefinementSolver.create(task);
        };
        if (shutdownManager != null) {
            modelChecker.setShutdownManager(shutdownManager);
        }
    }

    public void run() throws SolverException, InterruptedException, InvalidConfigurationException {
        final long startTime = System.currentTimeMillis();

        initModelChecker();
        if (!hasTimeout()) {
            modelChecker.run();
        } else {
            final Thread timeoutThread = createTimeoutThread();
            timeoutThread.start();
            modelChecker.run();
            timeoutThread.interrupt();
            timeoutThread.join();
        }

        if (modelChecker.hasModel()) {
            model = modelChecker.getModel();
        }

        runtime = System.currentTimeMillis() - startTime;
    }

    public Result getResult() {
        checkHasRun();
        return modelChecker.getResult();
    }

    public long getRuntime() {
        checkHasRun();
        return runtime;
    }

    public boolean hasModel() {
        checkHasRun();
        return model != null;
    }

    public IREvaluator getModel() {
        Preconditions.checkState(hasModel(), "No model available");
        return model;
    }

    public ExecutionModelNext getExecutionGraph() {
        return new ExecutionModelManager().buildExecutionModel(getModel());
    }

    // ===================================== Misc =====================================

    @Override
    public void close() {
        // VERY IMPORTANT: Close model before closing model checker!
        if (model != null) {
            model.close();
            model = null;
        }

        if (modelChecker != null) {
            modelChecker.close();
            modelChecker = null;
        }
    }

    protected void checkHasRun() {
        Preconditions.checkState(modelChecker != null, "Model checker has not run yet.");
    }

    private Thread createTimeoutThread() {
        return new Thread(() -> {
            try {
                final long timeoutInMillis = timeout;
                Thread.sleep(timeoutInMillis);
                final String error = String.format("Timeout of %s exceeded.", Utils.toTimeString(timeoutInMillis));
                modelChecker.requestShutdown(error);
            } catch (InterruptedException e) {
                // Verification ended, nothing to be done.
            }
        });
    }

}
