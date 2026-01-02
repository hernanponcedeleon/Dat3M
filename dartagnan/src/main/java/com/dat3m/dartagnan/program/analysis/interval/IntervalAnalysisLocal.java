package com.dat3m.dartagnan.program.analysis.interval;


import com.dat3m.dartagnan.program.Program;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Load;

import java.util.Map;

public class IntervalAnalysisLocal extends IntervalAnalysisWorklist {
    
    private IntervalAnalysisLocal(Program program) {

        super(program);
        computeIntervals(program);
    }

    public static IntervalAnalysis fromConfig(Program program) {
        return new IntervalAnalysisLocal(program);
    }


    @Override
    protected RegisterState analyseLoad(Load l, Map<Register, Interval> prevIntervals) {
        Register result = l.getResultRegister();
        return new RegisterState(result,Interval.getTop((IntegerType) result.getType()));
    }
}
