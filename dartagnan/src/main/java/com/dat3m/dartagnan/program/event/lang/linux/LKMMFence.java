package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.program.event.common.FenceBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMFence extends FenceBase {

    public LKMMFence(String name) {
        super(name, name); // Name and Mo are identical
    }

    protected LKMMFence(LKMMFence other) {
        super(other);
    }

    @Override
    public LKMMFence getCopy() {
        return new LKMMFence(this);
    }

    @Override
    public String defaultString() {
        return name;
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMFence(this);
    }
}
