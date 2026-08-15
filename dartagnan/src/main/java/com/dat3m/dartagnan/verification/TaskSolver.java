package com.dat3m.dartagnan.verification;

import org.sosy_lab.common.configuration.InvalidConfigurationException;

public sealed interface TaskSolver extends AutoCloseable permits TaskSolverBase {
    Task getTask();

    TaskResult<?> getResult();

    void run() throws Exception;


    static TaskSolver create(Task task) throws InvalidConfigurationException {
        if (task instanceof VerificationTask veriTask) {
            return VerificationTaskSolver.create(veriTask);
        }

        throw new UnsupportedOperationException("Cannot create task solver for task " + task.getClass().getSimpleName());
    }
}
