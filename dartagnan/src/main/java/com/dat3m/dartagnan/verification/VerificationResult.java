package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.encoding.IREvaluator;
import com.google.common.base.Preconditions;

public final class VerificationResult implements TaskResult<VerificationTask> {

    private final VerificationTask task;
    private final ResultStatus status;
    private final IREvaluator model;

    public VerificationResult(VerificationTask task, ResultStatus status, IREvaluator model) {
        this.task = Preconditions.checkNotNull(task);
        this.status = status;
        this.model = model;
    }

    @Override
    public ResultStatus getStatus() {
        return status;
    }

    public IREvaluator getModel() {
        Preconditions.checkState(hasModel(), "No model available");
        return model;
    }

    public boolean hasModel() {
        return model != null;
    }

    @Override
    public VerificationTask getTask() {
        return task;
    }

    @Override
    public String toString() {
        return "VerificationResult[property=%s, status=%s, model=%s]".formatted(
                task.getProperties(), status, hasModel() ? "yes" : "no"
        );
    }

}
