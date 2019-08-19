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
        addFilters(EType.ANY);
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
    	// When the bound is one, we just update the nextId
        if(label.getOId() < oId && bound > 1){
        	int currentBound = bound;    			

        	Event next = null;
        	while(currentBound > 1){
				next = copyPathFrom(label.successor, predecessor);
				nextId = predecessor.successor.unroll(currentBound, nextId, predecessor);
				currentBound--;
	        	// worst case, copyPathFrom will return the initial predecessor
	        	assert(next != null);
	        	predecessor = next;
			}
        	
			predecessor.setSuccessor(this.getSuccessor());
			if(predecessor.getSuccessor() != null){
				nextId = predecessor.getSuccessor().unroll(bound, nextId, predecessor);
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
