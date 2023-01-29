package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;

import java.math.BigInteger;

public class ExecutionStatus extends Event implements RegWriter {

    private final Register register;
    private final Event event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep){
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;
        addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_WRITER);
    }

    @Override
    public Register getResultRegister(){
        return register;
    }

    public Event getStatusEvent(){
        return event;
    }

    public boolean doesTrackDep(){
        return trackDep;
    }

    @Override
    public String toString() {
        return register + " <- status(" + event.toString() + ")";
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        int precision = register.getPrecision();
        return bmgr.and(super.encodeExec(context),
                bmgr.implication(context.execution(event),
                        context.equalZero(context.result(this))),
                bmgr.or(context.execution(event),
                        context.equal(context.result(this), new IValue(BigInteger.ONE, precision).toIntFormula(this, fmgr))));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public Event getCopy(){
        throw new ProgramProcessingException(getClass().getName() + " cannot be unrolled: event must be generated during compilation");
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitExecutionStatus(this);
	}
}