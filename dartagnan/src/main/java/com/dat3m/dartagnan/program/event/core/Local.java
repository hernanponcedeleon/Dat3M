package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.util.LinkedHashSet;
import java.util.Set;

public class Local extends AbstractEvent implements RegWriter, RegReader {

    protected Register register;
    protected Expression expr;
    protected final boolean speculatable;

    public Local(Register register, Expression expr, boolean speculatable) {
        Preconditions.checkArgument(register.getType().equals(expr.getType()));
        this.register = register;
        this.expr = expr;
        this.speculatable = speculatable;
    }

    protected Local(Local other) {
        super(other);
        this.register = other.register;
        this.expr = other.expr;
        this.speculatable = other.speculatable;
    }

    public Expression getExpr() {
        return expr;
    }

    public void setExpr(Expression expr) {
        this.expr = expr;
    }

    /**
     * Indicates that this event does not initialise a register
     * and loads are allowed to speculate that the value does not change.
     */
    public boolean isSpeculatable() { return speculatable; }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> reads = Register.collectRegisterReads(expr, Register.UsageType.DATA, new LinkedHashSet<>());
        if (speculatable) {
            reads.add(new Register.Read(getResultRegister(), Register.UsageType.SPEC));
        }
        return reads;
    }

    @Override
    public String defaultString() {
        return String.format("%s = %s", register, expr);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.accept(exprTransformer);
    }

    @Override
    public Local getCopy() {
        return new Local(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLocal(this);
    }
}