package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractMemoryCoreEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.List;

// This event is a MemEvent because it needs to contribute to the loc relation
// (due to let srcu-rscs = ([Srcu-lock] ; pass-cookie ; [Srcu-unlock]) & loc).
// FIXME: Add generic memory event in the core that can represent SRCU.
public class SrcuSync extends AbstractMemoryCoreEvent {

    public SrcuSync(Expression address) {
        super(address);
        tags.add(Tag.Linux.SRCU_SYNC);
    }

    @Override
    public String toString() {
        return "synchronize_srcu(" + address + ")\t### LKMM";
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSrcuSync(this);
    }
}
