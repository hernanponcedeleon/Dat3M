package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Load extends AbstractCoreMemoryEvent implements Register.Writer {
    private final Register resultRegister;

    protected Load(Register resultRegister, Expression address) {
        super(address, resultRegister.getType(), "");
        this.resultRegister = resultRegister;
    }


    @Override
    public Register getResultRegister() { return resultRegister; }

    @Override
    public MemoryAccess.Mode getAccessMode() {
        return MemoryAccess.Mode.LOAD;
    }
}
