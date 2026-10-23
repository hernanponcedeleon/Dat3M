package com.dat3m.dartagnan.verification;

import org.sosy_lab.common.configuration.InvalidConfigurationException;

public sealed interface TaskSolver extends AutoCloseable permits TaskSolverBase {
    Task getTask();

    TaskResult<?> getResult();

    void run() throws Exception;


    static TaskSolver create(Task task) throws InvalidConfigurationException {
        return switch (task) {
            case VerificationTask veriTask -> VerificationTaskSolver.create(veriTask);
            case EnumerationTask enumTask -> EnumerationTaskSolver.create(enumTask);
        };
    }
}
