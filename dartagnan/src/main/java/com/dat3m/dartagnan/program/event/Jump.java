package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Jump extends Event {

    protected Label label;
    protected Label label4Copy;
    
    public Jump(Label label){
        if(label == null){
            throw new IllegalArgumentException("Jump event requires non null label event");
        }
        this.label = label;
        this.label.addListener(this);
        addFilters(EType.ANY, EType.JUMP);
    }

    protected Jump(Jump other) {
		super(other);
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }
    
    public Label getLabel(){
        return label;
    }

    @Override
    public String toString(){
        return "goto " + label;
    }

    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public void unroll(int bound, Event predecessor) {
        if(label.getOId() < oId){
        	if(bound > 1) {
        		predecessor = copyPath(label, successor, predecessor);
        	}
        	if(successor != null) {
        		successor.unroll(bound, predecessor);
        	}
    	    return;
        }
        super.unroll(bound, predecessor);
    }

    @Override
    public Jump getCopy(){
    	return new Jump(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed Jump event");
        }
        return successor.compile(target, nextId, this);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
            label.addCfCond(ctx, cfVar);
            cfEnc = ctx.mkAnd(ctx.mkEq(cfVar, cfCond), encodeExec(ctx));
            cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkFalse()));
        }
        return cfEnc;
    }
}
