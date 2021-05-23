package com.dat3m.dartagnan.analysis.graphRefinement;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;

public class RefinementResult {
    private Result result;
    private DNF<CoreLiteral> violations;
    private RefinementStats stats;

    public Result getResult() { return result; }
    public DNF<CoreLiteral> getViolations() { return violations; }
    public RefinementStats getStatistics() { return stats; }

    void setResult(Result res) { result = res; }
    void setViolations(DNF<CoreLiteral> violations) { this.violations = violations; }
    void setStats(RefinementStats stats) { this.stats = stats; }

    public RefinementResult() {
        result = Result.UNKNOWN;
        violations = DNF.FALSE;
    }

}
