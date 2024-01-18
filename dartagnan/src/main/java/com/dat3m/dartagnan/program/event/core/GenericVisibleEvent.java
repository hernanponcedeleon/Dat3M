package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;

public class GenericVisibleEvent extends AbstractEvent {

    protected final String name;

    public GenericVisibleEvent(String name, String ... tags) {
        Preconditions.checkArgument(!name.isEmpty());
        this.name = name;
        this.addTags(Tag.VISIBLE);
        this.addTags(tags);
    }

    protected GenericVisibleEvent(GenericVisibleEvent other) {
        super(other);
        this.name = other.name;
    }

    public String getName() {
        return name;
    }

    @Override
    public String defaultString() {
        return name;
    }

    @Override
    public GenericVisibleEvent getCopy() {
        return new GenericVisibleEvent(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitGenericVisibleEvent(this);
    }
}