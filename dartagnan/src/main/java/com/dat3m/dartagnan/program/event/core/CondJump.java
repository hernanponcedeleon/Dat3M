package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class CondJump extends AbstractEvent implements RegReader, EventUser {

    private Label label;
    private Expression guard;

    public CondJump(Expression guard, Label label) {
        Preconditions.checkNotNull(label, "CondJump event requires non null label event");
        Preconditions.checkNotNull(guard, "CondJump event requires non null expression");
        Preconditions.checkArgument(guard.getType() instanceof BooleanType,
                "CondJump event with non-boolean guard %s.", guard);
        this.label = label;
        this.guard = guard;
        this.thread = label.getThread();

        this.label.registerUser(this);
    }

    protected CondJump(CondJump other) {
        super(other);
        this.label = other.label;
        this.guard = other.guard;

        this.label.registerUser(this);
    }

    public boolean isGoto() {
        return guard instanceof BConst constant && constant.getValue();
    }

    public boolean isDead() {
        return guard instanceof BConst constant && !constant.getValue();
    }

    public Label getLabel() {
        return label;
    }

    public Expression getGuard() {
        return guard;
    }

    public void setGuard(Expression guard) {
        this.guard = guard;
    }

    @Override
    public void setThread(Thread thread) {
        super.setThread(thread);
        if (label != null) {
            label.setThread(thread);
        }
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(guard, Register.UsageType.CTRL, new HashSet<>());
    }

    @Override
    public String toString() {
        String output;
        if (isGoto()) {
            output = "goto " + label.getName();
        } else {
            output = "if(" + guard + "); then goto " + label.getName();
        }
        output = hasTag(Tag.BOUND) ? String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", output) + "\t### BOUND" : output;
        output = hasTag(Tag.SPINLOOP) ? String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", output) + "\t### SPINLOOP" : output;
        return output;
    }


    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        Label old = this.label;
        this.label = (Label) updateMapping.getOrDefault(this.label, this.label);
        if (old != this.label) {
            old.removeUser(this);
            this.label.registerUser(this);
;        }
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(label);
    }

    @Override
    public void delete() {
        super.delete();
        label.removeUser(this);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public CondJump getCopy() {
        return new CondJump(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitCondJump(this);
    }

}