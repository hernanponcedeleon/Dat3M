package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import org.sosy_lab.java_smt.api.*;

import java.util.Map;

public class ExecutionStatus extends Event implements RegWriter {

    private final Register register;
    private Event event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep) {
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;
    }

    protected ExecutionStatus(ExecutionStatus other) {
        super(other);
        this.register = other.register;
        this.event = other.event;
        this.trackDep = other.trackDep;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    public Event getStatusEvent() {
        return event;
    }

    public boolean doesTrackDep() {
        return trackDep;
    }

    @Override
    public String toString() {
        return register + " <- status(" + event.toString() + ")";
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        Formula zero = context.encodeFinalIntegerExpression(expressions.makeZero(register.getType()));
        Formula one = context.encodeFinalIntegerExpression(expressions.makeOne(register.getType()));
        return bmgr.and(super.encodeExec(context),
                context.equal(context.result(this), bmgr.ifThenElse(context.execution(event), one, zero)));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Event getCopy() {
        return new ExecutionStatus(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.event = updateMapping.getOrDefault(event, event);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitExecutionStatus(this);
    }
}