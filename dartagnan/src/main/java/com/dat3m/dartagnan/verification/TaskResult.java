package com.dat3m.dartagnan.verification;


public sealed interface TaskResult<TTask extends Task> permits EnumerationResult, VerificationResult {

    TTask getTask();
    ResultStatus getStatus();
}
