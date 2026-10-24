package com.dat3m.dartagnan.task;


public interface TaskResult<TTask extends Task> {

    TTask getTask();
}
