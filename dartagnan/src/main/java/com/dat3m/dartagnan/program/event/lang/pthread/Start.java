package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends LoadBase implements EventUser {

    private Event creationEvent;

    public Start(Register reg, Expression address, Event creationEvent) {
        super(reg, address, MO_SC);
        this.creationEvent = creationEvent;
        addTags(Tag.C11.PTHREAD);

        this.creationEvent.registerUser(this);
    }

    private Start(Start other) {
        super(other);
        this.creationEvent = other.creationEvent;
        creationEvent.registerUser(this);
    }

    @Override
    public String defaultString() {
        return "start_thread()";
    }

    public Event getCreationEvent() {
        return creationEvent;
    }

    @Override
    public Start getCopy() {
        return new Start(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitStart(this);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(creationEvent);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        creationEvent = EventUser.moveUserReference(this, creationEvent, updateMapping);
    }
}