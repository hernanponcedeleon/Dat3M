package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.verification.VerificationTask;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWStoreExclusiveStatus extends Event implements RegWriter {

    private final Register register;
    private final RMWStoreExclusive storeEvent;
    private Formula regResultExpr;

    public RMWStoreExclusiveStatus(Register register, RMWStoreExclusive storeEvent){
        this.register = register;
        this.storeEvent = storeEvent;
        addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        regResultExpr = register.toZ3IntResult(this, ctx);
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
        return register + " <- status(" + storeEvent.toStringBase() + ")";
    }

    @Override
    protected BooleanFormula encodeExec(SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();

        int precision = register.getPrecision();
		BooleanFormula enc = bmgr.and(
				bmgr.implication(storeEvent.exec(), imgr.equal(
						(IntegerFormula)regResultExpr, 
						(IntegerFormula)new IConst(BigInteger.ZERO, precision).toZ3Int(this, ctx))),
				bmgr.implication(bmgr.not(storeEvent.exec()), imgr.equal(
						(IntegerFormula)regResultExpr, 
						(IntegerFormula)new IConst(BigInteger.ONE, precision).toZ3Int(this, ctx)))
        );
        return bmgr.and(super.encodeExec(ctx), enc);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new RuntimeException("RMWStoreExclusiveStatus cannot be unrolled: event must be generated during compilation");
    }
}
