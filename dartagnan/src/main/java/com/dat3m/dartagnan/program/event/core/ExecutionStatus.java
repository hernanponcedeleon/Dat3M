package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;

import java.math.BigInteger;
import java.util.Map;
import java.util.Set;

public class ExecutionStatus extends AbstractEvent implements RegWriter, EventUser {

    private Register register;
    private Event event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep) {
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;

        this.event.registerUser(this);
    }

    protected ExecutionStatus(ExecutionStatus other) {
        super(other);
        this.register = other.register;
        this.event = other.event;
        this.trackDep = other.trackDep;

        this.event.registerUser(this);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    public Event getStatusEvent() {
        return event;
    }

    public boolean doesTrackDep() {
        return trackDep;
    }

    @Override
    public String defaultString() {
        return register + " <- not_exec(" + event + ")";
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Type type = register.getType();
        final BooleanFormula eventExecuted = context.execution(event);
        final Formula result = context.result(this);

        if (type instanceof IntegerType integerType) {
            final Formula one = context.makeLiteral(integerType, BigInteger.ONE);
            return bmgr.and(super.encodeExec(context),
                    bmgr.ifThenElse(eventExecuted, context.equalZero(result), context.equal(result, one))
            );
        } else if (type instanceof BooleanType) {
            //TODO: We have "result == not exec(event)", because we use 0/false for executed events.
            // The reason is that ExecutionStatus follows the behavior of Store-Conditionals on hardware.
            // However, this is very counterintuitive and I think we should return 1/true on success and instead
            // change the compilation of Store-Conditional to invert the value.
            return bmgr.and(super.encodeExec(context), context.equal(result, bmgr.not(eventExecuted)));
        }
        throw new UnsupportedOperationException(String.format("Encoding ExecutionStatus on type %s.", type));
    }

    @Override
    public Event getCopy() {
        return new ExecutionStatus(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.event = EventUser.moveUserReference(this, this.event, updateMapping);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(event);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitExecutionStatus(this);
    }

}