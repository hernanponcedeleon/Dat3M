package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.Register;

/*
    RMWLoadExclusive is a "normal" Load that can pair with a subsequent RMWStoreExclusive to
    form LL/SC-type RMW operations.
 */

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class RMWLoadExclusive extends Load {

    protected RMWLoadExclusive(Register resultRegister, Expression address) {
        super(resultRegister, address);
    }
}
