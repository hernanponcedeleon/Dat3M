package com.dat3m.dartagnan.analysis.saturation;

import com.dat3m.dartagnan.analysis.saturation.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;

public class SolverResult {
    private SolverStatus status;
    private DNF<CoreLiteral> coreReasons;
    private SolverStatistics stats;

    public SolverStatus getStatus() { return status; }
    public DNF<CoreLiteral> getCoreReasons() { return coreReasons; }
    public SolverStatistics getStatistics() { return stats; }

    void setStatus(SolverStatus status) { this.status = status; }
    void setCoreReasons(DNF<CoreLiteral> coreReasons) {
        this.coreReasons = coreReasons;
        stats.numComputedCoreReasons = coreReasons.getNumberOfCubes();
    }
    void setStats(SolverStatistics stats) { this.stats = stats; }

    public SolverResult() {
        status = SolverStatus.INCONCLUSIVE;
        coreReasons = DNF.FALSE();
    }

    @Override
    public String toString() {
        return status + "\n" +
                coreReasons + "\n" +
                stats;
    }
}
