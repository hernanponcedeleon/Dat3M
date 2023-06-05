package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class CondJump extends AbstractEvent implements RegReader {

    private Label label;
    private BExpr guard;

    public CondJump(BExpr guard, Label label){
    	Preconditions.checkNotNull(label, "CondJump event requires non null label event");
    	Preconditions.checkNotNull(guard, "CondJump event requires non null expression");
        this.label = label;
        this.label.getJumpSet().add(this);
        this.thread = label.getThread();
        this.guard = guard;
    }

    protected CondJump(CondJump other) {
		super(other);
		this.label = other.label;;
		this.guard = other.guard;
        this.label.getJumpSet().add(this);
    }
    
    public boolean isGoto() {
    	return guard.isTrue();
    }
    public boolean isDead() {return guard.isFalse(); }
    
    public Label getLabel(){
        return label;
    }

    public BExpr getGuard(){
        return guard;
    }
    public void setGuard(BExpr guard){
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
    public Set<Register.Read> getRegisterReads(){
        return Register.collectRegisterReads(guard, Register.UsageType.CTRL, new HashSet<>());
    }

    @Override
    public String toString(){
    	String output;
    	if(isGoto()) {
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
        this.label = (Label)updateMapping.getOrDefault(this.label, this.label);
        if (old != this.label) {
            old.getJumpSet().remove(this);
            this.label.getJumpSet().add(this);
        }
    }

    @Override
    public void delete() {
        super.delete();
        label.getJumpSet().remove(this);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public CondJump getCopy(){
    	return new CondJump(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitCondJump(this);
	}
}