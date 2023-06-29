package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Fence extends AbstractEvent {

    protected final String name;

    public Fence(String name) {
        this.name = name;
        this.addTags(Tag.VISIBLE, Tag.FENCE, name);
    }

    protected Fence(Fence other) {
        super(other);
        this.name = other.name;
    }

    public String getName() {
        return name;
    }

    @Override
    public String defaultString() {
        return getName();
    }

    @Override
    public Fence getCopy() {
        return new Fence(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitFence(this);
    }
}