package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;

import java.util.Map;
import java.util.Set;

public class RMWStore extends Store implements EventUser {

    protected Load loadEvent;

    public RMWStore(Load loadEvent, Expression address, Expression value) {
        super(address, value);
        Preconditions.checkArgument(loadEvent.hasTag(Tag.RMW), "The provided load event %s is not tagged RMW.", loadEvent);
        this.loadEvent = loadEvent;
        this.loadEvent.registerUser(this);
        addTags(Tag.RMW);
    }

    protected RMWStore(RMWStore other) {
        super(other);
        this.loadEvent = other.loadEvent;
        this.loadEvent.registerUser(this);
    }

    public Load getLoadEvent() { return loadEvent; }

    @Override
    public String defaultString() {
        return "rmw " + super.defaultString();
    }

    @Override
    public RMWStore getCopy() {
        return new RMWStore(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.loadEvent = (Load) EventUser.moveUserReference(this, this.loadEvent, updateMapping);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(loadEvent);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWStore(this);
    }

}