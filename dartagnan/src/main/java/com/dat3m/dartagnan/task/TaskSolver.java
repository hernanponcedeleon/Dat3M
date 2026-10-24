package com.dat3m.dartagnan.task;

import com.dat3m.dartagnan.task.enumeration.EnumerationTask;
import com.dat3m.dartagnan.task.enumeration.EnumerationTaskSolver;
import com.dat3m.dartagnan.task.verification.VerificationTask;
import com.dat3m.dartagnan.task.verification.VerificationTaskSolver;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public interface TaskSolver extends AutoCloseable {
    Task getTask();

    TaskResult<?> getResult();

    void run() throws Exception;


    static TaskSolver create(Task task) throws InvalidConfigurationException {
        return switch (task) {
            case VerificationTask veriTask -> VerificationTaskSolver.create(veriTask);
            case EnumerationTask enumTask -> EnumerationTaskSolver.create(enumTask);
            default -> throw new UnsupportedOperationException("Unsupported task: " + task);
        };
    }
}
