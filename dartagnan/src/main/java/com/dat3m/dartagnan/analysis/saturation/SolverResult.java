package com.dat3m.dartagnan.analysis.saturation;

import com.dat3m.dartagnan.analysis.saturation.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;

public class SolverResult {
    private SolverStatus status;
    private DNF<CoreLiteral> violations;
    private SolverStatistics stats;

    public SolverStatus getStatus() { return status; }
    public DNF<CoreLiteral> getViolations() { return violations; }
    public SolverStatistics getStatistics() { return stats; }

    void setStatus(SolverStatus status) { this.status = status; }
    void setViolations(DNF<CoreLiteral> violations) { this.violations = violations; }
    void setStats(SolverStatistics stats) { this.stats = stats; }

    public SolverResult() {
        status = SolverStatus.INCONCLUSIVE;
        violations = DNF.FALSE();
    }

    @Override
    public String toString() {
        return status + "\n" +
                violations + "\n" +
                stats;
    }
}
