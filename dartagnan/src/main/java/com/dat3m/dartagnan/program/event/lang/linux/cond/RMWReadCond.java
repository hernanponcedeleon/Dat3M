package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;

//TODO: This event and all its dependents (the whole cond-package) are events that do not get compiled anymore.
// This means we should have these events in our core language in some shape or form.
// But before we can do so, we need to understand their semantics as addressed in issue #200
// (https://github.com/hernanponcedeleon/Dat3M/issues/200)
public abstract class RMWReadCond extends Load implements RegReaderData {

    protected ExprInterface cmp;

    RMWReadCond(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
        addFilters(Tag.RMW, Tag.REG_READER);
    }

    public BooleanFormula getCond(EncodingContext ctx) {
    	return ctx.equal(ctx.value(this), cmp.toIntFormula(this, ctx.getSolverContext()));
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return cmp.getRegs();
    }

    public abstract String condToString();

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public RMWReadCond getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWReadCond(this);
	}
}