package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Tag;

@NoInterface
public abstract class FenceBase extends AbstractEvent {

    protected final String name;
    protected final String mo; // May be NULL or empty for fences that do not support a mo.

    public FenceBase(String name, String mo) {
        this.name = name;
        this.mo = mo;
        this.addTags(Tag.VISIBLE, Tag.FENCE);
        if (mo != null && !mo.isEmpty()) {
            addTags(mo);
        }
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
        if (mo == null || mo.isEmpty()) {
            return name;
        } else {
            return String.format("%s(%s)", name, mo);
        }
    }

}