package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.List;

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

    public List<Event> getBranchesEvents() {
        // Because it is used for RelCtrlDirect
        Preconditions.checkState(getFunction().getProgram().isCompiled(),
                "getBranchesEvents() must be called after compilation");
        final List<Event> events = getSuccessor().getSuccessors();
        final int end = this.end == null ? events.size() : events.indexOf(this.end);
        return events.subList(0, end);
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