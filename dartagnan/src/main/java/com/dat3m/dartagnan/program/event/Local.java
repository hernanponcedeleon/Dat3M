package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected final Register register;
	protected final ExprInterface expr;
	private final ImmutableSet<Register> dataRegs;
	private Formula regResultExpr;
	
	public Local(Register register, ExprInterface expr) {
		this.register = register;
		this.expr = expr;
		this.dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER, EType.REG_READER);
	}
	
	protected Local(Local other){
		super(other);
		this.register = other.register;
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
		this.regResultExpr = other.regResultExpr;
	}

	@Override
	public void initializeEncoding(SolverContext ctx) {
		super.initializeEncoding(ctx);
		regResultExpr = register.toIntFormulaResult(this, ctx);
	}

	public ExprInterface getExpr(){
		return expr;
	}

	@Override
	public Register getResultRegister(){
		return register;
	}

	@Override
	public Formula getResultRegisterExpr(){
		return regResultExpr;
	}

	@Override
	public ImmutableSet<Register> getDataRegs(){
		return dataRegs;
	}

    @Override
	public String toString() {
		return register + " <- " + expr;
	}

	@Override
	public BooleanFormula encodeExec(SolverContext ctx){
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		
		BooleanFormula enc = super.encodeExec(ctx);
		if(expr instanceof INonDet) {
			enc = bmgr.and(enc, ((INonDet)expr).encodeBounds(expr.toIntFormula(this, ctx) instanceof BitvectorFormula, ctx));
		}

		return bmgr.and(enc, generalEqual(regResultExpr, expr.toIntFormula(this, ctx), ctx));
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Local getCopy(){
		return new Local(this);
	}
}