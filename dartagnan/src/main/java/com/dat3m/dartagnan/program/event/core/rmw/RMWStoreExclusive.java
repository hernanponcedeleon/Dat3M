package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

public class RMWStoreExclusive extends Store {

    public RMWStoreExclusive(IExpr address, ExprInterface value, String mo, boolean strong){
        super(address, value, mo);
        addFilters(Tag.EXCL, Tag.RMW);
        if(strong) {
        	addFilters(Tag.STRONG);
        }
    }

    @Override
    public boolean cfImpliesExec() {
        return is(Tag.STRONG); // Strong RMWs always succeed
    }

    @Override
    public String toString(){
    	String tag = is(Tag.STRONG) ? " strong" : "";
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt" + tag;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
    	return ctx.getBooleanFormulaManager().implication(ctx.execution(this), ctx.controlFlow(this));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public RMWStoreExclusive getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWStoreExclusive(this);
	}
}