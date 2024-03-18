package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.common.NoInterface;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

/*
    This class is similar to SingleAccessMemoryEvent, but without a memory order.
 */
@NoInterface
public abstract class AbstractMemoryCoreEvent extends AbstractEvent implements MemoryCoreEvent {

    protected Expression address;
    protected Type accessType;

    public AbstractMemoryCoreEvent(Expression address, Type accessType) {
        this.address = Preconditions.checkNotNull(address);
        this.accessType = accessType;
        addTags(VISIBLE, MEMORY);
    }

    protected AbstractMemoryCoreEvent(AbstractMemoryCoreEvent other) {
        super(other);
        this.address = other.address;
        this.accessType = other.accessType;
    }

    public Expression getAddress() { return address; }
    public void setAddress(Expression address) { this.address = address; }

    public Type getAccessType() { return accessType; }
    public void setAccessType(Type type) { this.accessType = type; }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.address = address.accept(exprTransformer);
    }
}

