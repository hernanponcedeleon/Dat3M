package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.configuration.OptionNames.METHOD;

@Options
public class VerificationTaskSolver extends TaskSolverBase<VerificationTaskSolver, VerificationTask, VerificationResult> implements AutoCloseable {

    // ================================== Configurables ==================================

    @Option(
            name = METHOD,
            description = "Solving method to be used.",
            toUppercase = true)
    private Method method = Method.getDefault();

    // ====================================== State ======================================

    private ModelChecker modelChecker;

    // =================================== Construction ===================================

    private VerificationTaskSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);
    }

    public static VerificationTaskSolver create(VerificationTask task) throws InvalidConfigurationException {
        return new VerificationTaskSolver(task);
    }

    public static VerificationTaskSolver createWithMethod(VerificationTask task, Method method) throws InvalidConfigurationException {
        final VerificationTaskSolver solver = create(task);
        solver.method = method;
        return solver;
    }

    // ===================================== Solving =====================================

    private void initModelChecker() throws InvalidConfigurationException {
        Preconditions.checkState(modelChecker == null, "Model checker already initialized");
        modelChecker = switch (method) {
            case EAGER -> AssumeSolver.create(task);
            case LAZY -> RefinementSolver.create(task);
        };
        modelChecker.setShutdownManager(shutdownManager);
    }

    public void run() throws SolverException, InterruptedException, InvalidConfigurationException {
        initModelChecker();

        startRun();
        try {
            modelChecker.run();
        } finally {
            endRun();
        }

        result = new VerificationResult(task, modelChecker.getResult(),
                modelChecker.hasModel() ? modelChecker.getModel() : null
        );
    }

    // ===================================== Misc =====================================

    @Override
    protected VerificationTaskSolver getThis() {
        return this;
    }

    @Override
    public void close() {
        // VERY IMPORTANT: Close model before closing model checker!
        if (result != null && result.hasModel()) {
            result.getModel().close();
        }

        if (modelChecker != null) {
            modelChecker.close();
            modelChecker = null;
        }
    }

}
