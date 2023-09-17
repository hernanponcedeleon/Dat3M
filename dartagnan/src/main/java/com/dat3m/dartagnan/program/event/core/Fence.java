package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Fence extends TaggedEvent {

    public Fence(String name) {
        super(name, Tag.FENCE);
    }

    protected Fence(Fence other) {
        super(other);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitFence(this);
    }
}