package com.dat3m.dartagnan.program.event.rmw.cond;

import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.verification.VerificationTask;

public class RMWReadCondUnless extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String mo) {
        super(reg, cmp, address, mo);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        this.formulaCond = ctx.getFormulaManager().getBooleanFormulaManager().not(formulaCond);
    }

    @Override
    public String condToString(){
        return "# if not " + resultRegister + " = " + cmp;
    }
}
