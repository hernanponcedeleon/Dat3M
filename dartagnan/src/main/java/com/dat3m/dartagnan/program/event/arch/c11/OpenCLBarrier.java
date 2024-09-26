package com.dat3m.dartagnan.program.event.arch.c11;

import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.expression.Expression;

public class OpenCLBarrier extends ControlBarrier {

    public OpenCLBarrier(String name, Expression id) {
        super(name, id);
    }

    private OpenCLBarrier(OpenCLBarrier other) {
        super(other);
    }

    @Override
    public OpenCLBarrier getCopy() {
        return new OpenCLBarrier(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitOpenCLBarrier(this);
    }
}
