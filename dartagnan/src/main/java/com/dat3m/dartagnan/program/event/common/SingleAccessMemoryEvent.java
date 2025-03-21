package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

/*
    A SingleAccessMemoryEvent is memory event that performs a single access to memory.
    This includes simple loads and stores but also RMW events or abstract events like SRCU.
    Complex events like MemCpy access two different addresses and hence are unable to
    reuse the implementation given by this class.

    NOTE: This class is intended as a basis for language-level memory events which support a memory order (mo).

 */
@NoInterface
public abstract class SingleAccessMemoryEvent extends AbstractEvent implements MemoryEvent {

    protected Expression address;
    protected Type accessType;
    protected String mo;

    // The empty string means no memory order 
    public SingleAccessMemoryEvent(Expression address, Type accessType, String mo) {
        Preconditions.checkNotNull(mo, "The memory ordering cannot be null");
        this.address = address;
        this.mo = mo;
        this.accessType = accessType;
        addTags(VISIBLE, MEMORY);
        if (!mo.isEmpty()) {
            addTags(mo);
        }
    }

    protected SingleAccessMemoryEvent(SingleAccessMemoryEvent other) {
        super(other);
        this.address = other.address;
        this.mo = other.mo;
        this.accessType = other.accessType;
    }

    public Expression getAddress() { return address; }
    public void setAddress(Expression address) { this.address = address; }

    public Type getAccessType() { return accessType; }
    public void setAccessType(Type type) { this.accessType = type; }

    public String getMo() {
        return mo;
    }

    public abstract MemoryAccess getMemoryAccess();

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(getMemoryAccess());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.address = address.accept(exprTransformer);
    }
}

