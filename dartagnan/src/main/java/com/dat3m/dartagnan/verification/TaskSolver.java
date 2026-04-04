package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.configuration.OptionNames.METHOD;

@Options
public class TaskSolver implements AutoCloseable {

    private static final Logger logger = LoggerFactory.getLogger(TaskSolver.class);

    // ================================== Configurables ==================================

    @Option(
            name = METHOD,
            description = "Method to be used.",
            toUppercase = true)
    private Method method = Method.getDefault();

    // ====================================== State ======================================

    private final VerificationTask task;

    protected transient ModelChecker modelChecker;
    protected transient ShutdownManager shutdownManager;

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
        modelChecker = ModelChecker.create(task, method);
        if (shutdownManager != null) {
            modelChecker.setShutdownManager(shutdownManager);
        }
    }

    public void run() throws InterruptedException, InvalidConfigurationException, SolverException {
        initModelChecker();
        modelChecker.run();
    }

    public Result getResult() {
        checkHasRun();
        return modelChecker.getResult();
    }

    public boolean hasModel() {
        checkHasRun();
        return modelChecker.hasModel();
    }

    public IREvaluator getModel() throws SolverException {
        checkHasRun();
        return modelChecker.getModel();
    }

    public ExecutionModelNext getExecutionGraph() throws SolverException {
        Preconditions.checkState(hasModel(), "No model available");
        try (IREvaluator evaluator = getModel()) {
            return new ExecutionModelManager().buildExecutionModel(evaluator);
        }
    }

    // ===================================== Misc =====================================

    @Override
    public void close() {
        if (modelChecker != null) {
            modelChecker.close();
        }
    }

    private void checkHasRun() {
        Preconditions.checkState(modelChecker != null, "Model checker has not run yet.");
    }

}
