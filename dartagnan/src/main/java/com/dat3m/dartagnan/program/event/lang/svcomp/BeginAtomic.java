package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class BeginAtomic extends AbstractEvent {

    public BeginAtomic() {
        addTags(Tag.RMW);
    }

    protected BeginAtomic(BeginAtomic other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return "begin_atomic()";
    }

    @Override
    public BeginAtomic getCopy() {
        return new BeginAtomic(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBeginAtomic(this);
    }
}