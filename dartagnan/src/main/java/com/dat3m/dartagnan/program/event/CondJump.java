package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

public class CondJump extends Event implements RegReaderData {

    private Label label;
    private Label label4Copy;
    private final BExpr expr;
    private final ImmutableSet<Register> dataRegs;

    public CondJump(BExpr expr, Label label){
        Preconditions.checkNotNull(expr, "CondJump event requires non-null expression.");
        Preconditions.checkNotNull(label, "CondJump event requires non-null target label.");

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
    	// This is an under-approximation
    	// We do not detect cases like CondJump(2*x==x+x,label) as jumps
    	// However treating those (unusual) as jumps should not break anything
    	try {
    		return expr.reduce().getValue();
    	} catch (Exception e) {
    		// "Complex" expressions cannot be reduced and thus they are trivially not true.
    		return false;
		}
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
        if (label != null) {
            label.setThread(thread);
        }
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
    protected RecursiveAction simplifyRecursive(Event predecessor, int depth) {
        Event prev = this;
        Event next = successor;
        // If the label immediately follows and the condition is either true or false we can remove the jump
        // (in both cases the next executed event is the successor)
        if(label.equals(successor) && expr instanceof BConst) {
            prev = predecessor;
            label.listeners.remove(this);
            // If the label is only the target of the removed jump, we can also remove the label
            if(label.listeners.isEmpty()) {
                next = successor.getSuccessor();
            }
            predecessor.setSuccessor(next);
        }
        if(next != null){
            if (depth < GlobalSettings.getInstance().getMaxRecursionDepth()) {
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

    public boolean didJump(Model model, SolverContext ctx) {
        return expr.getBoolValue(this, model, ctx);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------


    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        if(label.getOId() < oId){
            if(bound > 1) {
                predecessor = copyPath(label, successor, predecessor);
            }
            Event next = predecessor;
            if(bound == 1) {
                Label target = (Label)getThread().getExit();
                next = EventFactory.newGoto(target);
                next.addFilters(EType.BOUND);
                predecessor.setSuccessor(next);
            }
            if(successor != null) {
                if (depth < GlobalSettings.getInstance().getMaxRecursionDepth()) {
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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        Preconditions.checkState(successor != null, "Malformed CondJump event has no successor.");
        return super.compileRecursive(target, nextId, predecessor, depth);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BooleanFormula encodeCF(SolverContext ctx, BooleanFormula cond) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

    	if(cfEnc == null){
			cfCond = (cfCond == null) ? cond : bmgr.or(cfCond, cond);
            BooleanFormula ifCond = expr.toBoolFormula(this, ctx);
            label.addCfCond(ctx, bmgr.and(ifCond, cfVar));
            cfEnc = bmgr.and(bmgr.equivalence(cfVar, cfCond), encodeExec(ctx));
        }
        return cfEnc;
    }

    @Override
    public BooleanFormula encodePrefixCF(SolverContext ctx, BooleanFormula cond) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : bmgr.or(cfCond, cond);
            BooleanFormula ifCond = expr.toBoolFormula(this, ctx);
            label.addCfCond(ctx, bmgr.and(ifCond, cfVar));
            cfEnc = bmgr.and(bmgr.implication(cfVar, cfCond), encodeExec(ctx));
        }
        return cfEnc;
    }
}
