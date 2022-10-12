package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import org.sosy_lab.java_smt.api.BooleanFormula;

public class RMWReadCondUnless extends RMWReadCond {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String mo) {
        super(reg, cmp, address, mo);
    }

    @Override
    public BooleanFormula getCond(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().not(super.getCond(ctx));
    }

    @Override
    public String condToString(){
        return "# if not " + resultRegister + " = " + cmp;
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWReadCondUnless(this);
	}
}
