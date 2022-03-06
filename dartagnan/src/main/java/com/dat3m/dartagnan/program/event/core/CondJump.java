package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

public class CondJump extends Event implements RegReaderData {

    private Label label;
    private Label label4Copy;
    private BExpr expr;

    public CondJump(BExpr expr, Label label){
    	Preconditions.checkNotNull(label, "CondJump event requires non null label event");
    	Preconditions.checkNotNull(expr, "CondJump event requires non null expression");
        this.label = label;
        this.label.addListener(this);
        this.thread = label.getThread();
        this.expr = expr;
        addFilters(Tag.ANY, Tag.JUMP, Tag.REG_READER);
    }

    protected CondJump(CondJump other) {
		super(other);
		this.label = other.label4Copy;
		this.expr = other.expr;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }
    
    public boolean isGoto() {
    	return expr.isTrue();
    }
    
    public boolean isDead() {
    	return expr.isFalse();
    }
    
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
        if (label != null)
            label.setThread(thread);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return expr.getRegs();
    }

    @Override
    public String toString(){
    	if(isGoto()) {
            return "goto " + label;
    	}
        return "if(" + expr + "); then goto " + label;
    }

    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    @Override
    public void delete(Event pred) {
        super.delete(pred);
        label.listeners.remove(this);
    }

    public boolean didJump(Model model, SolverContext ctx) {
        return expr.getBoolValue(this, model, ctx);
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