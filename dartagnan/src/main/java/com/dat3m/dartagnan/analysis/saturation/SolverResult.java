package com.dat3m.dartagnan.analysis.saturation;

import com.dat3m.dartagnan.analysis.saturation.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;

public class SolverResult {
    private SolverStatus status;
    private DNF<CoreLiteral> inconsistencyReasons;
    private SolverStatistics stats;

    public SolverStatus getStatus() { return status; }
    public DNF<CoreLiteral> getInconsistencyReasons() { return inconsistencyReasons; }
    public SolverStatistics getStatistics() { return stats; }

    void setStatus(SolverStatus status) { this.status = status; }
    void setInconsistencyReasons(DNF<CoreLiteral> inconsistencyReasons) {
        this.inconsistencyReasons = inconsistencyReasons;
        stats.numComputedCoreReasons = inconsistencyReasons.getNumberOfCubes();
    }
    void setStats(SolverStatistics stats) { this.stats = stats; }

    public SolverResult() {
        status = SolverStatus.INCONCLUSIVE;
        inconsistencyReasons = DNF.FALSE();
    }

    @Override
    public String toString() {
        return status + "\n" +
                inconsistencyReasons + "\n" +
                stats;
    }
}
