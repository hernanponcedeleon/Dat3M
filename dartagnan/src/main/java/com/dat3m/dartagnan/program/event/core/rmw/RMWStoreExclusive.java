package com.dat3m.dartagnan.program.event.core.rmw;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class RMWStoreExclusive extends Store {

    protected transient BooleanFormula execVar;

    public RMWStoreExclusive(IExpr address, ExprInterface value, String mo, boolean strong){
        super(address, value, mo);
        addFilters(Tag.EXCL, Tag.RMW);
        if(strong) {
        	addFilters(Tag.STRONG);
        }
    }

    @Override
    public BooleanFormula exec() {
        return execVar;
    }

    @Override
    public boolean cfImpliesExec() {
        return is(Tag.STRONG); // Strong RMWs always succeed
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        execVar = is(Tag.STRONG) ? cfVar : ctx.getFormulaManager().makeVariable(BooleanType, "exec(" + repr() + ")");
    }

    @Override
    public String toString(){
    	String tag = is(Tag.STRONG) ? " strong" : "";
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt" + tag;
    }

    @Override
    public BooleanFormula encodeExec(SolverContext ctx){
    	return ctx.getFormulaManager().getBooleanFormulaManager().implication(execVar, cfVar);
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