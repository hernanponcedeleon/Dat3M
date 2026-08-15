package com.dat3m.dartagnan.verification;


public sealed interface TaskResult<TTask extends Task> permits VerificationResult {

    TTask getTask();
    ResultStatus getStatus();
}
