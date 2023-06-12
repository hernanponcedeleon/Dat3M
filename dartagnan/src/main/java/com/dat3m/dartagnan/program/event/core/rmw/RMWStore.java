package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Map;

public class RMWStore extends Store {

    protected Load loadEvent;

    public RMWStore(Load loadEvent, IExpr address, ExprInterface value) {
        super(address, value);
        Preconditions.checkArgument(loadEvent.hasTag(Tag.RMW), "The provided load event %s is not tagged RMW.", loadEvent);
        this.loadEvent = loadEvent;
        addTags(Tag.RMW);
    }

    protected RMWStore(RMWStore other) {
        super(other);
        this.loadEvent = other.loadEvent;
    }

    public Load getLoadEvent() { return loadEvent; }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWStore getCopy() {
        return new RMWStore(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.loadEvent = (Load) updateMapping.getOrDefault(loadEvent, loadEvent);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWStore(this);
    }
}