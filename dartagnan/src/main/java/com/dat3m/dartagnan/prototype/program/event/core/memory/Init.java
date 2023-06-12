package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Constant;
import com.dat3m.dartagnan.prototype.expr.Expression;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Init extends Store {

    protected Init(Expression address, Constant value) {
        super(address, value);
    }

    public Constant getValue() {
        return (Constant) value;
    }

}
