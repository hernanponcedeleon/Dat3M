package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Tag;


public final class MemFree extends GenericMemoryEvent {
    public MemFree(Expression address) {
        super(address, "free");
        addTags(Tag.FREE);
        removeTags(Tag.MEMORY);
    }

    @Override
    public MemFree getCopy() {
        MemFree other = new MemFree(address);
        other.setFunction(this.getFunction());
        other.copyAllMetadataFrom(this);
        return other;
    }
}
