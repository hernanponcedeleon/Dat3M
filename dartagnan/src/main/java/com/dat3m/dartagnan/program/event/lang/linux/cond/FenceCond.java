package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

public class FenceCond extends Fence {

    private final RMWReadCond loadEvent;

    public FenceCond (RMWReadCond loadEvent, String name){
        super(name);
        this.loadEvent = loadEvent;
    }

    @Override
    public boolean cfImpliesExec() {
        return false;
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + loadEvent.condToString();
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		return bmgr.equivalence(ctx.execution(this), bmgr.and(ctx.controlFlow(this), loadEvent.getCond(ctx)));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public FenceCond getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitFenceCond(this);
	}
}