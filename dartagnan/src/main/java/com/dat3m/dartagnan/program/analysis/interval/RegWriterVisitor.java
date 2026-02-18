package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.Map;

public class RegWriterVisitor implements EventVisitor<RegisterState> {

    private final Map<Register, Interval> eventState;
    private final RegisterState state;

    public RegisterState getState() {
        return state;
    }

    public RegWriterVisitor(Event e, Map<Register, Interval> eventState) {
        this.eventState = eventState;
        state = e.accept(this);
    }

    @Override
    public RegisterState visitEvent(Event e) {
        if (e instanceof RegWriter rw) {
            Register reg = rw.getResultRegister();
            if (reg.getType() instanceof IntegerType regType) {
                return new RegisterState(reg, Interval.getTop(regType));
            }
        }
        return null;
    }

    @Override
    public RegisterState visitLocal(Local l) {
        Register result = l.getResultRegister();
        Expression expr = l.getExpr();
        return new RegisterState(result, new AbstractExpressionEvaluator((IntegerType) result.getType(), expr, eventState).getResultInterval());
    }
}
