package com.dat3m.dartagnan.program.arch.linux.event.cond;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.verification.VerificationTask;
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
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
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
    protected RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new ProgramProcessingException("FenceCond cannot be unrolled: event must be generated during compilation");
    }
}
