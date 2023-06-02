package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Map;

public class RMWStore extends Store {

    protected Load loadEvent;

    public RMWStore(Load loadEvent, IExpr address, ExprInterface value, String mo) {
        super(address, value, mo);
        Preconditions.checkArgument(loadEvent.hasTag(Tag.RMW), "The provided load event " + loadEvent + " is not tagged RMW.");
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
    public void updateReferences(Map<AbstractEvent, AbstractEvent> updateMapping) {
        this.loadEvent = (Load) updateMapping.getOrDefault(loadEvent, loadEvent);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWStore(this);
    }
}