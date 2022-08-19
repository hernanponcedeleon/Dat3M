package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;

//TODO: This event and all its dependents (the whole cond-package) are events that do not get compiled anymore.
// This means we should have these events in our core language in some shape or form.
// But before we can do so, we need to understand their semantics as addressed in issue #200
// (https://github.com/hernanponcedeleon/Dat3M/issues/200)
public abstract class RMWReadCond extends Load implements RegReaderData {

    protected ExprInterface cmp;
    protected BooleanFormula formulaCond;

    RMWReadCond(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
        addFilters(Tag.RMW, Tag.REG_READER);
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        formulaCond = generalEqual(memValueExpr, cmp.toIntFormula(this, ctx), ctx);
    }

    public BooleanFormula getCond(){
    	Preconditions.checkState(formulaCond != null, "formulaCond is requested before it has been initialised in " + this.getClass().getName());
    	return formulaCond;
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