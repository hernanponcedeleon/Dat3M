package com.dat3m.dartagnan.program.arch.linux.event.cond;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class FenceCond extends Fence {

    private final RMWReadCond loadEvent;
    protected transient BooleanFormula execVar;

    public FenceCond (RMWReadCond loadEvent, String name){
        super(name);
        this.loadEvent = loadEvent;
    }

    @Override
    public BooleanFormula exec() {
        return execVar;
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        execVar = ctx.getFormulaManager().makeVariable(BooleanType, "exec(" + repr() + ")");
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + loadEvent.condToString();
    }

    @Override
    public BooleanFormula encodeExec(SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		return bmgr.equivalence(execVar, bmgr.and(cfVar, loadEvent.getCond()));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public FenceCond getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }
}