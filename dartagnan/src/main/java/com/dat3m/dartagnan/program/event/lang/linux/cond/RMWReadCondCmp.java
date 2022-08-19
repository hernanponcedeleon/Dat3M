package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWReadCondCmp extends RMWReadCond {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    @Override
    public String condToString(){
        return "# if " + resultRegister + " = " + cmp;
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWReadCondCmp(this);
	}
}
