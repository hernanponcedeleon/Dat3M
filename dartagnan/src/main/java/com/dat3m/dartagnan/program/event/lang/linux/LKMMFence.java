package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.FenceBase;

public class LKMMFence extends FenceBase {

    public LKMMFence(String name) {
        super(name, name); // Name and Mo are identical
    }

    protected LKMMFence(LKMMFence other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return name;
    }

    @Override
    public LKMMFence getCopy() {
        return new LKMMFence(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMFence(this);
    }
}
