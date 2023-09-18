package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.google.common.base.Preconditions;

@NoInterface
public abstract class FenceBase extends AbstractEvent {

    protected final String name;
    protected final String mo; // For fences that do not support a mo, use Fence instead.

    public FenceBase(String name, String mo) {
        Preconditions.checkArgument(!mo.isEmpty());
        this.name = name;
        this.mo = mo;
        addTags(Tag.VISIBLE, Tag.FENCE, mo);
    }

    protected FenceBase(FenceBase other) {
        super(other);
        this.name = other.name;
        this.mo = other.mo;
    }

    public String getName() {
        return name;
    }

    public String getMo() { return mo; }

    @Override
    public String defaultString() {
        return String.format("%s(%s)", name, mo);
    }

}