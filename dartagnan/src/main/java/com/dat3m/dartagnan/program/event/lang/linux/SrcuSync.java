package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.SingleAddressMemoryEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class SrcuSync extends SingleAddressMemoryEvent {

    public SrcuSync(IExpr address) {
        super(address, Tag.Linux.SRCU_SYNC);
    }

    @Override
    public String toString() {
        return "synchronize_srcu(" + address + ")\t### LKMM";
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSruSync(this);
    }
}
