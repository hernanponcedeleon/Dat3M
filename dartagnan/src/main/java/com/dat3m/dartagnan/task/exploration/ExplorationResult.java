package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.task.TaskResult;
import com.dat3m.dartagnan.task.verification.VerificationStatus;

import com.google.common.base.Preconditions;

import java.util.Optional;
import java.util.Set;

public final class ExplorationResult implements TaskResult<ExplorationTask> {

    private final ExplorationTask task;
    private final VerificationStatus status;
    private final TruStExplorer.Statistics statistics;
    private final TruStExplorer.Violation violation;
    private final String reachabilityWitness;
    private final boolean exhaustive;
    private final Set<String> executions;

    public ExplorationResult(ExplorationTask task, VerificationStatus status, TruStExplorer.Statistics statistics,
                             TruStExplorer.Violation violation, String reachabilityWitness, boolean exhaustive,
                             Set<String> executions) {
        this.task = Preconditions.checkNotNull(task);
        this.status = Preconditions.checkNotNull(status);
        this.statistics = statistics;
        this.violation = violation;
        this.reachabilityWitness = reachabilityWitness;
        this.exhaustive = exhaustive;
        this.executions = executions;
    }

    @Override
    public ExplorationTask getTask() { return task; }

    public VerificationStatus getStatus() { return status; }

    public TruStExplorer.Statistics getStatistics() { return statistics; }

    public Optional<TruStExplorer.Violation> getViolation() { return Optional.ofNullable(violation); }

    public Optional<String> getReachabilityWitness() { return Optional.ofNullable(reachabilityWitness); }

    // False if some executions were cut off by the event bound.
    public boolean isExhaustive() { return exhaustive; }

    // Only populated if executions are printed.
    public Set<String> getExecutions() { return executions; }

    @Override
    public String toString() {
        return "ExplorationResult[property=%s, status=%s, exhaustive=%s]".formatted(
                task.getProperties(), status, exhaustive);
    }
}
