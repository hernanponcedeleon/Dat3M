package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends LoadBase {

    private final Event creationEvent;

    public Start(Register reg, Expression address, Event creationEvent) {
        super(reg, address, MO_SC);
        this.creationEvent = creationEvent;
        addTags(Tag.C11.PTHREAD);
    }

    private Start(Start other) {
        super(other);
        this.creationEvent = other.creationEvent;
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
}