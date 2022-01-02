package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

public class CondJump extends Event implements RegReaderData {

    private Label label;
    private Label label4Copy;
    private final BExpr expr;
    private final ImmutableSet<Register> dataRegs;

    public CondJump(BExpr expr, Label label){
        if(label == null){
            throw new IllegalArgumentException("CondJump event requires non null label event");
        }
        if(expr == null){
            throw new IllegalArgumentException("CondJump event requires non null expression");
        }
        this.label = label;
        this.label.addListener(this);
        this.thread = label.getThread();
        this.expr = expr;
        dataRegs = expr.getRegs();
        addFilters(EType.ANY, EType.JUMP, EType.REG_READER);
    }

    protected CondJump(CondJump other) {
		super(other);
		this.label = other.label4Copy;
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }
    
    public boolean isGoto() {
    	return expr.isTrue();
    }
    
    public Label getLabel(){
        return label;
    }

    public BExpr getGuard(){
        return expr;
    }

    @Override
    public void setThread(Thread thread) {
        super.setThread(thread);
        if (label != null)
            label.setThread(thread);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
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

    
    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkState(successor != null, "Malformed CondJump event has no successor.");
        return super.compile(target);
    }
}
