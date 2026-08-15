package com.dat3m.dartagnan.verification;

public interface TaskSolver<TTask extends Task, TResult extends TaskResult<TTask>> extends AutoCloseable {
    TTask getTask();

    TResult getResult();

    void run() throws Exception;
}
