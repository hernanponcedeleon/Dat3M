package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

/*
    This is a non-value-returning RMW (e.g. like the one's in LKMM).
 */
@NoInterface
public abstract class RMWOpBase extends SingleAccessMemoryEvent {

    protected IOpBin operator;
    protected Expression operand;

    protected RMWOpBase(Expression address, IOpBin operator, Expression operand, String mo) {
        super(address, operand.getType(), mo);
        this.operator = operator;
        this.operand = operand;
        addTags(READ, WRITE, RMW);
    }

    protected RMWOpBase(RMWOpBase other) {
        super(other);
        this.operator = other.operator;
        this.operand = other.operand;
    }

    public Expression getOperand() { return operand; }
    public void setOperand(Expression operand) { this.operand = operand; }

    public IOpBin getOperator() { return this.operator; }
    public void setOperator(IOpBin operator)  { this.operator = operator; }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.operand = operand.visit(exprTransformer);
    }

    @Override
    protected String defaultString() {
        return String.format("rmw %s(%s, %s)", operator.toLinuxName(), address, operand);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(operand, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

}