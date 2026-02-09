package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

final class IntervalAnalysisNone implements IntervalAnalysis {

    @Override
    public Interval getIntervalAt(Event event, Register r) throws RuntimeException {
        final IntegerType type = (IntegerType) r.getType();
        return new Interval(type.getMinimumValue(true), type.getMaximumValue(false), type);
    }
}
