package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.program.Program;

public class IntervalAnalysisLocal extends IntervalAnalysisWorklist {
    
    private IntervalAnalysisLocal(Program program) {
        super();
        computeIntervals(program);
    }

    public static IntervalAnalysis fromConfig(Program program) {
        return new IntervalAnalysisLocal(program);
    }
}
