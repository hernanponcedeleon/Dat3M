package com.dat3m.dartagnan.programNew.event.core.memory;

import com.dat3m.dartagnan.expr.Constant;
import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.MemoryAccess;
import com.dat3m.dartagnan.programNew.event.MemoryEvent;

import java.util.List;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Init extends AbstractEvent implements MemoryEvent {
    protected final MemoryAccess memoryAccess;
    protected final Constant value;

    protected Init(Expression address, Constant value) {
        this.memoryAccess = new MemoryAccess(address, value.getType(), MemoryAccess.Mode.STORE);
        this.value = value;
    }

    public Expression getAddress() {
        return memoryAccess.address();
    }
    public Expression getValue() {
        return value;
    }
    public Type getValueType() { return value.getType(); }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(memoryAccess);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Set.of();
    }
}
