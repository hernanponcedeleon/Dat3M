package com.dat3m.dartagnan.programNew.event.core.memory;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.program.event.Tag;

/*
    An RMWStoreExclusive is used to model LL/SC-type RMW operations.
    An RMWStoreExclusive tries to pair with the most recently executed RMWLoadExclusive as follows:
        (1) If there is no preceding RMWLoadExclusive, the RMWStoreExclusive will fail to execute.
        (2) If there is a preceding RMWLoadExclusive, but there is a mismatch of addresses, then either
            (i) the RMWStoreExclusive will fail to execute
         OR (ii) it will execute but NOT form an RMW pair (i.e., the operation is not atomic).
            The behavior is configurable: (i) is used for PPC and RISCV, while (ii) is used for ARM8.
        (3) Even if paired, an RMWStoreExclusive may spuriously fail if it is not "strong" (configurable).
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class RMWStoreExclusive extends Store {

    protected boolean isStrong;
    protected boolean requiresMatchingAddresses;

    protected RMWStoreExclusive(Expression address, Expression value, boolean isStrong, boolean requiresMatchingAddresses) {
        super(address, value);
        this.isStrong = isStrong;
        this.requiresMatchingAddresses = requiresMatchingAddresses;
        if (isStrong) {
            addTag(Tag.STRONG);
        }
    }
}
