package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;
import com.google.common.base.Preconditions;

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
        Type registerType = result.getType();
        Preconditions.checkArgument(registerType instanceof IntegerType);
        Expression expr = l.getExpr();

        return new RegisterState(result, new AbstractExpressionEvaluator((IntegerType) registerType, expr, eventState).getResultInterval());
    }
}
