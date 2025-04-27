package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ExpressionEncoder;
import com.dat3m.dartagnan.encoding.formulas.TypedFormula;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

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
        final ExpressionEncoder exprEncoder = context.getExpressionEncoder();
        final ExpressionFactory exprs = context.getExpressionFactory();

        //TODO: We have "result == not exec(event)", because we use 0/false for executed events.
        // The reason is that ExecutionStatus follows the behavior of Store-Conditionals on hardware.
        // However, this is very counterintuitive and I think we should return 1/true on success and instead
        // change the compilation of Store-Conditional to invert the value.
        final TypedFormula<BooleanType, BooleanFormula> notExec = exprEncoder.wrap(bmgr.not(context.execution(event)));
        final Expression successEq = exprs.makeEQ(context.result(this), exprEncoder.convert(notExec, register.getType()));
        return bmgr.and(
                super.encodeExec(context),
                exprEncoder.encodeBooleanAt(successEq, this).formula()
        );
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