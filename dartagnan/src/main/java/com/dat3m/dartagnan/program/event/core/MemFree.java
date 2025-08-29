package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.List;


public final class MemFree extends AbstractMemoryCoreEvent {
    public MemFree(Expression address) {
        super(address, TypeFactory.getInstance().getArchType());
        removeTags(Tag.MEMORY);
        addTags(Tag.FREE);
    }

    @Override
    public MemFree getCopy() {
        MemFree other = new MemFree(address);
        other.setFunction(this.getFunction());
        other.copyAllMetadataFrom(this);
        return other;
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }

    @Override
    protected String defaultString() {
        return String.format("free(%s)", address);
    }
}
