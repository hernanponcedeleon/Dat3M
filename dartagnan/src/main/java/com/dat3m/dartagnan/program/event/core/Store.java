package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.List;
import java.util.Set;

public class Store extends AbstractMemoryCoreEvent {

    protected Expression value;

    public Store(Expression address, Expression value) {
        super(address, value.getType());
        this.value = value;
        addTags(Tag.WRITE);
    }

    protected Store(Store other) {
        super(other);
        this.value = other.value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE));
    }

    public Expression getMemValue() {
        return value;
    }

    public void setMemValue(Expression value) {
        this.value = value;
    }

    public String defaultString() {
        final MemoryOrder mo = getMetadata(MemoryOrder.class);
        return String.format("store(*%s, %s%s)", address, value, mo != null ? ", " + mo.value() : "");
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.value = value.accept(exprTransformer);
    }

    @Override
    public Store getCopy() {
        return new Store(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitStore(this);
    }
}