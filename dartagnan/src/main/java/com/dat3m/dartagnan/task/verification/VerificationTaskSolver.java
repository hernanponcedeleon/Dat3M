package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.model.Execution;
import com.dat3m.dartagnan.task.TaskSolverBase;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.SolverException;

import static com.dat3m.dartagnan.configuration.OptionNames.METHOD;

@Options
public final class VerificationTaskSolver extends TaskSolverBase<VerificationTaskSolver, VerificationTask, VerificationResult> implements AutoCloseable {

    private static final Logger logger = LoggerFactory.getLogger(VerificationTaskSolver.class);

    // ================================== Configurables ==================================

    @Option(
            name = METHOD,
            description = "Solving method to be used.",
            toUppercase = true)
    private Method method = Method.getDefault();

    // ====================================== State ======================================

    private Verifier verifier;

    // =================================== Construction ===================================

    private VerificationTaskSolver(VerificationTask task) throws InvalidConfigurationException {
        super(task);

        task.getConfig().inject(this);
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

    private void initVerifier() throws InvalidConfigurationException {
        Preconditions.checkState(verifier == null, "Verifier already initialized");
        verifier = switch (method) {
            case EAGER -> AssumeSolver.create(task);
            case LAZY -> RefinementSolver.create(task);
        };
        verifier.setShutdownManager(shutdownManager);
    }

    @Override
    public void run() throws SolverException, InterruptedException, InvalidConfigurationException {
        initVerifier();

        startRun();
        try {
            result = verifier.verify();
        } finally {
            endRun();
        }
        if (result.hasExecution()) {
            validateExecution(result.getExecution());
        }
    }

    private static void validateExecution(Execution execution) {
        for (Execution.RegisterRead read : execution.getUninitializedRegisterReads()) {
            logger.warn("Encountered uninitialized register {} read by {}: {}.",
                    read.register(), read.reader().getGlobalId(), read.reader());
        }
        // TODO: Check if there is OOB or any aliasing violation
    }

    // ===================================== Misc =====================================

    @Override
    protected VerificationTaskSolver getThis() {
        return this;
    }

    @Override
    public void close() {
        if (verifier != null) {
            verifier.close();
        }

        result = null;
        verifier = null;
    }

}
