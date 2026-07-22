package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.encoding.IREvaluator;


public interface TaskResult<TTask extends Task> {

    TTask getTask();
    ResultStatus getStatus();

    // TODO: Maybe remove these two; they are not general for all types of tasks
    IREvaluator getModel();
    boolean hasModel();

    record Verify(ResultStatus result, IREvaluator model, Task.Verify task) implements TaskResult<Task.Verify> {
        @Override
        public ResultStatus getStatus() {
            return result;
        }

        @Override
        public IREvaluator getModel() {
            return model;
        }

        @Override
        public boolean hasModel() {
            return model != null;
        }

        @Override
        public Task.Verify getTask() {
            return task;
        }
    }
}
