package com.dat3m.dartagnan.verification;

public interface TaskSolver extends AutoCloseable {
    Task getTask();

    TaskResult<?> getResult();

    void run() throws Exception;
}
