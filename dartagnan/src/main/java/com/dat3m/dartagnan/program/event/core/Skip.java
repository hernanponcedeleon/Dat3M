package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;

public class Skip extends AbstractEvent {

    public Skip() {
    }

    protected Skip(Skip other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return "skip";
    }

    @Override
    public Skip getCopy() {
        return new Skip(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSkip(this);
    }
}