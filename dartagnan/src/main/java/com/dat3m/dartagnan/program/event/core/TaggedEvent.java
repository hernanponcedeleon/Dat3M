package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class TaggedEvent extends AbstractEvent {

    protected final String name;

    public TaggedEvent(String name, String ... tags) {
        this.name = name;
        this.addTags(Tag.VISIBLE, name);
        this.addTags(tags);
    }

    protected TaggedEvent(TaggedEvent other) {
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
    public TaggedEvent getCopy() {
        return new TaggedEvent(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitTaggedEvent(this);
    }
}