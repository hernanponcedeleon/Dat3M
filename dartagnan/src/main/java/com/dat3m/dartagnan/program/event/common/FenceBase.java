package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.google.common.base.Preconditions;

@NoInterface
public abstract class FenceBase extends Fence {

    protected final String mo; // For fences that do not support a mo, use Fence instead.

    public FenceBase(String name, String mo) {
        super(name);
        Preconditions.checkNotNull(mo);
        Preconditions.checkArgument(!mo.isEmpty());
        this.mo = mo;
        addTags(mo);
    }

    protected FenceBase(FenceBase other) {
        super(other);
        this.mo = other.mo;
    }

    public String getMo() { return mo; }

    @Override
    public String defaultString() {
        if (mo == null || mo.isEmpty()) {
            return name;
        } else {
            return String.format("%s(%s)", name, mo);
        }
    }

}