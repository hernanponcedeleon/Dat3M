package com.dat3m.dartagnan.program.arch.linux.event.cond;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;


public class RMWStoreCond extends RMWStore implements RegReaderData {

    protected transient BooleanFormula execVar;

    public RMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String mo) {
        super(loadEvent, address, value, mo);
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
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + ((RMWReadCond)loadEvent).condToString();
    }

    @Override
    public BooleanFormula encodeExec(SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		return bmgr.equivalence(execVar, bmgr.and(cfVar, ((RMWReadCond)loadEvent).getCond()));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public RMWStoreCond getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }
}
