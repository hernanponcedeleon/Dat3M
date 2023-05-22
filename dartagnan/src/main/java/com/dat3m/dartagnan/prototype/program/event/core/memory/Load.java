package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;
import com.dat3m.dartagnan.prototype.program.event.MemoryEvent;

import java.util.List;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Load extends AbstractEvent implements MemoryEvent, Register.Writer {
    private final Register resultRegister;
    private final MemoryAccess memoryAccess;

    protected Load(Register resultRegister, Expression address) {
        this.resultRegister = resultRegister;
        this.memoryAccess = new MemoryAccess(address, resultRegister.getType(), MemoryAccess.Mode.LOAD);
    }

    public Expression getAddress() {
        return memoryAccess.address();
    }
    public Type getValueType() { return memoryAccess.accessType(); }

    @Override
    public Register getResultRegister() { return resultRegister; }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(memoryAccess);
    }
}