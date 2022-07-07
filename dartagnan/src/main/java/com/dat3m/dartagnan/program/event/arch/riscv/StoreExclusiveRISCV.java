package com.dat3m.dartagnan.program.event.arch.riscv;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class StoreExclusiveRISCV extends RMWStoreExclusive implements RegWriter {

	// Returns 0 if the store success, i.e. the reservation is still valid.
	private final Register resultRegister;
	
	public StoreExclusiveRISCV(Register register, IExpr address, ExprInterface value, String mo) {
		super(address, value, mo, false);
		this.resultRegister = register;
		addFilters(Tag.RISCV.STCOND);
	}

	@Override
	public Register getResultRegister() {
		return resultRegister;
	}

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        // memValueExpr is the SMT value of resultRegister
        FormulaManager fmgr = ctx.getFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
		memValueExpr = fmgr.getBooleanFormulaManager().ifThenElse(execVar, imgr.makeNumber(0), imgr.makeNumber(1));
    }

    @Override
    public Formula getResultRegisterExpr(){
        return memValueExpr;
    }

    @Override
    public String toString(){
        return String.format("%s = %s", resultRegister, super.toString());
    }

    // TODO
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitStoreExclusiveRISCV(this);
	}
}