package com.dat3m.dartagnan.analysis.graphRefinement;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;

public class RefinementResult {
    private RefinementStatus status;
    private DNF<CoreLiteral> violations;
    private RefinementStats stats;

    public RefinementStatus getStatus() { return status; }
    public DNF<CoreLiteral> getViolations() { return violations; }
    public RefinementStats getStatistics() { return stats; }

    void setStatus(RefinementStatus status) { this.status = status; }
    void setViolations(DNF<CoreLiteral> violations) { this.violations = violations; }
    void setStats(RefinementStats stats) { this.stats = stats; }

    public RefinementResult() {
        status = RefinementStatus.INCONCLUSIVE;
        violations = DNF.FALSE();
    }

}
