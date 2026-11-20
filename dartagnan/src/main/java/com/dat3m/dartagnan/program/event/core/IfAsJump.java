package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;

public class IfAsJump extends CondJump {

    private final Label end;

    public IfAsJump(Expression expr, Label label, Label end) {
        super(expr, label);
        this.end = end;
    }

    protected IfAsJump(IfAsJump other) {
        super(other);
        this.end = other.end;
    }

    public Label getEndIf() {
        return end;
    }

    @Override
    public IfAsJump getCopy() {
        return new IfAsJump(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitIfAsJump(this);
    }
}