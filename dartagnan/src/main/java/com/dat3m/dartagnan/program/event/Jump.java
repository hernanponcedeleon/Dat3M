package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Jump extends Event {

    protected final Label label;

    public Jump(Label label){
        if(label == null){
            throw new IllegalArgumentException("Jump event requires non null label event");
        }
        this.label = label;
        addFilters(EType.ANY);
    }

    public Label getLabel(){
        return label;
    }

    @Override
    public String toString(){
        return "goto " + label;
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int unroll(int bound, int nextId, Event predecessor) {
        if(label.getOId() < oId){
        	// Here comes a validate
    		if(true){
    			int currentBound = bound;

    			while(currentBound > 1){
    				Skip entry = new Skip();
    				entry.oId = oId;
    				entry.uId = nextId++;

    				predecessor.setSuccessor(entry);
    				predecessor = copyPath(label.successor, this, entry, bound);

    				nextId = entry.successor.unroll(currentBound, nextId, entry);
    				currentBound--;
    			}

    			predecessor.setSuccessor(this.getSuccessor());
    			if(predecessor.getSuccessor() != null){
    				nextId = predecessor.getSuccessor().unroll(bound, nextId, predecessor);
    			}
    			return nextId;
    		}
            throw new UnsupportedOperationException("Malformed Jump");
        }
        return super.unroll(bound, nextId, predecessor);
    }

    @Override
    public Jump getCopy(int bound){
    	Label newLabel = new Label(label.getName() + "_" + bound);
    	return new Jump(newLabel);
        //throw new UnsupportedOperationException("Cloning is not implemented for Jump event");
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
