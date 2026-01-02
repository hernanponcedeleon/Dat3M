package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IntervalAnalysisNaive implements IntervalAnalysis{

    static IntervalAnalysis fromConfig() {
        return new IntervalAnalysisNaive();
    }

    IntervalAnalysisNaive() { }

    @Override
    public Interval getIntervalAt(Event event, Register r) throws RuntimeException {
	if (r.getType() instanceof IntegerType itype){
			return Interval.getTop(itype);
		} else throw new InvalidRegisterTypeException(r.getType());
    }
}
