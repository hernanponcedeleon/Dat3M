package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;


public class RMWStoreCond extends RMWStore {

    public RMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String mo) {
        super(loadEvent, address, value, mo);
    }

    @Override
    public boolean cfImpliesExec() {
        return false;
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + ((RMWReadCond)loadEvent).condToString();
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		return bmgr.equivalence(ctx.execution(this), bmgr.and(ctx.controlFlow(this), ((RMWReadCond)loadEvent).getCond(ctx)));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public RMWStoreCond getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWStoreCond(this);
	}
}