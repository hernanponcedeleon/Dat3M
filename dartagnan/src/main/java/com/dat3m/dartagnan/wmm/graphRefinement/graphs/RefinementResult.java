package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;

public class RefinementResult {
    Result result;
    DNF<CoreLiteral> violations;
    int saturationDepth;

    public Result getResult() { return result; }
    public DNF<CoreLiteral> getViolations() { return violations; }
    public int getSaturationDepth() { return saturationDepth; }

    public void setResult(Result res) { result = res; }
    public void setViolations(DNF<CoreLiteral> violations) { this.violations = violations; }
    public void setSaturationDepth(int depth) { this.saturationDepth = depth;}

    public RefinementResult() {
        result = Result.UNKNOWN;
        violations = DNF.FALSE;
        saturationDepth = 0;
    }

}
