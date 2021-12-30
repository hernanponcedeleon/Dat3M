package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;

public class ExecutionStatus extends Event implements RegWriter {

    private final Register register;
    private final Event event;
    private Formula regResultExpr;

    public ExecutionStatus(Register register, Event event){
        this.register = register;
        this.event = event;
        addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        regResultExpr = register.toIntFormulaResult(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return register;
    }

    @Override
    public Formula getResultRegisterExpr(){
        return regResultExpr;
    }

    @Override
    public String toString() {
        return register + " <- status(" + event.toString() + ")";
    }

    @Override
    protected BooleanFormula encodeExec(SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        int precision = register.getPrecision();
		BooleanFormula enc = bmgr.and(
				bmgr.implication(event.exec(),
						generalEqual(regResultExpr, new IConst(BigInteger.ZERO, precision).toIntFormula(this, ctx), ctx)),
				bmgr.implication(bmgr.not(event.exec()),
						generalEqual(regResultExpr, new IConst(BigInteger.ONE, precision).toIntFormula(this, ctx), ctx))
        );
        return bmgr.and(super.encodeExec(ctx), enc);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new ProgramProcessingException("ExecutionStatus cannot be unrolled: event must be generated during compilation");
    }
}
