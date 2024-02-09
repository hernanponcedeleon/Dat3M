package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.Set;

@NoInterface
public abstract class StoreBase extends SingleAccessMemoryEvent {

    protected Expression value;

    public StoreBase(Expression address, Expression value, String mo) {
        super(address, value.getType(), mo);
        this.value = value;
        addTags(Tag.WRITE);
    }

    protected StoreBase(StoreBase other) {
        super(other);
        this.value = other.value;
    }

    public Expression getMemValue() {
        return value;
    }
    public void setMemValue(Expression value) {
        this.value = value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE);
    }

    @Override
    public String defaultString() {
        return String.format("store(*%s, %s%s)", address, value, !mo.isEmpty() ? ", " + mo : "");
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.value = value.accept(exprTransformer);
    }
}