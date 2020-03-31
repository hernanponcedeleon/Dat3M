package com.dat3m.dartagnan.program.event;

import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Jump extends Event {

    protected Label label;
    
    public Jump(Label label){
        if(label == null){
            throw new IllegalArgumentException("Jump event requires non null label event");
        }
        this.label = label;
        addFilters(EType.ANY, EType.JUMP);
    }

    protected Jump(Jump other) {
		super(other);
		this.label = other.label;
    }
    
    public Label getLabel(){
        return label;
    }

    @Override
    public String toString(){
        return "goto " + label;
    }

    public void updateLabel(Label label) {
    	this.label = label;
    }
        
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int unroll(int bound, int nextId, Event predecessor) {
        if(label.getOId() < oId){
        	int currentBound = bound;    			

        	while(currentBound > 1){
        		predecessor = copyPathFrom(label.successor, predecessor);
				currentBound--;
			}        	
    		if(successor != null){
    			nextId = successor.unroll(bound, nextId, predecessor);
    		}
    	    return nextId;
        }
        return super.unroll(bound, nextId, predecessor);
    }

    @Override
    public Jump getCopy(){
    	Jump copy = new Jump(this);
    	label.addReference(copy);
    	return copy;
    }

	Event copyPathFrom(Event from, Event appendTo){
		// The method can be called in the presence of cycles
		// We add a check to avoid non termination
		Set<Object> visited = new HashSet<>();
		while(from != null && !from.equals(this) && !visited.contains(from.uId)){
			visited.add(from.uId);
			Event copy = from.getCopy();
			appendTo.setSuccessor(copy);
			if(from instanceof If){
				from = ((If)from).getExitElseBranch();
				appendTo = ((If)copy).getExitElseBranch();
			} else if(from instanceof While){
				from = ((While)from).getExitEvent();
				appendTo = ((While)copy).getExitEvent();
			} else {
				appendTo = copy;
			}
			from = from.successor;
		}
		return appendTo;
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
