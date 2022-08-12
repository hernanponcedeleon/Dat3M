package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;

public class ExecutionStatus extends Event implements RegWriter {

    private final Register register;
    private final Event event;
    private Formula regResultExpr;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep){
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;
        addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_WRITER);
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        regResultExpr = register.toIntFormulaResult(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return register;
    }

    @Override
    public Formula getResultRegisterExpr(){
        return regResultExpr;
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
    public BooleanFormula encodeExec(SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        int precision = register.getPrecision();
		BooleanFormula enc = bmgr.and(
				bmgr.implication(event.exec(),
						generalEqual(regResultExpr, new IValue(BigInteger.ZERO, precision).toIntFormula(this, ctx), ctx)),
				bmgr.implication(bmgr.not(event.exec()),
						generalEqual(regResultExpr, new IValue(BigInteger.ONE, precision).toIntFormula(this, ctx), ctx))
        );
        return bmgr.and(super.encodeExec(ctx), enc);
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