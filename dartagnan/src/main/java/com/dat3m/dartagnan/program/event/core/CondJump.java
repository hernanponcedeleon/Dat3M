package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;

import java.util.Map;

public class CondJump extends Event implements RegReaderData {

    private Label label;
    private BExpr expr;

    public CondJump(BExpr expr, Label label){
    	Preconditions.checkNotNull(label, "CondJump event requires non null label event");
    	Preconditions.checkNotNull(expr, "CondJump event requires non null expression");
        this.label = label;
        this.label.getJumpSet().add(this);
        this.thread = label.getThread();
        this.expr = expr;
    }

    protected CondJump(CondJump other) {
		super(other);
		this.label = other.label;;
		this.expr = other.expr;
        this.label.getJumpSet().add(this);
    }
    
    public boolean isGoto() {
    	return expr.isTrue();
    }
    public boolean isDead() {return expr.isFalse(); }
    
    public Label getLabel(){
        return label;
    }

    public BExpr getGuard(){
        return expr;
    }
    public void setGuard(BExpr guard){
        this.expr = guard;
    }

    @Override
    public void setThread(Thread thread) {
        super.setThread(thread);
        if (label != null) {
            label.setThread(thread);
        }
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return expr.getRegs();
    }

    @Override
    public String toString(){
    	String output;
    	if(isGoto()) {
            output = "goto " + label.getName();
    	} else {
            output = "if(" + expr + "); then goto " + label.getName();    		
    	}
        output = hasFilter(Tag.BOUND) ? String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", output) + "\t### BOUND" : output;
        output = hasFilter(Tag.SPINLOOP) ? String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", output) + "\t### SPINLOOP" : output;
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

    public boolean didJump(Model model, FormulaManager m) {
        return expr.getBoolValue(this, model, m);
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