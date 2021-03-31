package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalFlags;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

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

    private static Context defaultCtx = new Context();
    public boolean isGoto() {
        /*try(Context ctx = new Context()) {
            return expr.toZ3Bool(this, ctx).simplify().isTrue();
            // NOTE: this seems to be worse, despite giving more accurate branching...
        }*/
        return expr.toZ3Bool(this, defaultCtx).simplify().isTrue();
        //return expr instanceof BConst && ((BConst)expr).getValue();
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
    
    /*@Override
    public void simplify(Event predecessor) {
    	Event prev = this;
    	Event next = successor;
    	// If the label immediately follows and the condition is either true or false we can remove the jump
    	// (in both cases the next executed event is the successor)
    	if(label.equals(successor) && expr instanceof BConst) {
    		prev = predecessor;
    		// If the label is only the target of the removed jump, we can also remove the label
    		if(label.listeners.size() == 1) {
    			next = successor.getSuccessor();
    		}
    		predecessor.setSuccessor(next);
    	}
		if(next != null){
			next.simplify(prev);
		}
    }*/

    @Override
    protected RecursiveAction simplifyRecursive(Event predecessor, int depth) {
        Event prev = this;
        Event next = successor;
        // If the label immediately follows and the condition is either true or false we can remove the jump
        // (in both cases the next executed event is the successor)
        if(label.equals(successor) && expr instanceof BConst) {
            prev = predecessor;
            // If the label is only the target of the removed jump, we can also remove the label
            if(label.listeners.size() == 1) {
                next = successor.getSuccessor();
            }
            predecessor.setSuccessor(next);
        }
        if(next != null){
            if (depth < GlobalFlags.MAX_RECURSION_DEPTH) {
                return next.simplifyRecursive(prev, depth + 1);
            } else {
                Event finalNext = next;
                Event finalPrev = prev;
                return RecursiveAction.call(() -> finalNext.simplifyRecursive(finalPrev,0));
            }
        }
        return RecursiveAction.done();
    }

    @Override
    public void delete(Event pred) {
        super.delete(pred);
        label.listeners.remove(this);
    }

    public boolean didJump(Model model, Context ctx) {
        return expr.getBoolValue(this, model, ctx);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    /*@Override
    public void unroll(int bound, Event predecessor) {
        if(label.getOId() < oId){
        	if(bound > 1) {
        		predecessor = copyPath(label, successor, predecessor);
        	}
        	Event next = predecessor;
        	if(bound == 1) {
            	next = new BoundEvent();
        		predecessor.setSuccessor(next);        		
        	}
        	if(successor != null) {
        		successor.unroll(bound, next);
        	}
    	    return;
        }
        super.unroll(bound, predecessor);
    }*/

    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        if(label.getOId() < oId){
            if(bound > 1) {
                predecessor = copyPath(label, successor, predecessor);
            }
            Event next = predecessor;
            if(bound == 1) {
                next = new BoundEvent();
                predecessor.setSuccessor(next);
            }
            if(successor != null) {
                if (depth < GlobalFlags.MAX_RECURSION_DEPTH) {
                    return successor.unrollRecursive(bound, next, depth + 1);
                } else {
                    Event finalNext = next;
                    return RecursiveAction.call(() -> successor.unrollRecursive(bound, finalNext, 0));
                }
            }
        }
        return super.unrollRecursive(bound, predecessor, depth);
    }


    @Override
    public CondJump getCopy(){
    	return new CondJump(this);
    }

    
    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed CondJump event");
        }
        return successor.compile(target, nextId, this);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
            BoolExpr ifCond = expr.toZ3Bool(this, ctx);
            label.addCfCond(ctx, ctx.mkAnd(ifCond, cfVar));
            cfEnc = ctx.mkAnd(ctx.mkEq(cfVar, cfCond), encodeExec(ctx));
//            cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkAnd(ctx.mkNot(ifCond), cfVar)));
        }
        return cfEnc;
    }
}
