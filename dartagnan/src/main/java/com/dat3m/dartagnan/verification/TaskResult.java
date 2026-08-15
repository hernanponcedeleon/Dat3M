package com.dat3m.dartagnan.verification;


public interface TaskResult<TTask extends Task> {

    TTask getTask();
    ResultStatus getStatus();
}
