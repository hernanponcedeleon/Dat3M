package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.ImmutableSet;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected final Register register;
	protected final ExprInterface expr;
	private final ImmutableSet<Register> dataRegs;
	private Formula regResultExpr;
	
	public Local(Register register, ExprInterface expr, int cLine) {
		super(cLine);
		this.register = register;
		this.expr = expr;
		this.dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER, EType.REG_READER);
	}

	public Local(Register register, ExprInterface expr) {
		this(register, expr, -1);
	}
	
	protected Local(Local other){
		super(other);
		this.register = other.register;
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
		this.regResultExpr = other.regResultExpr;
	}

	@Override
	public void initialise(VerificationTask task, SolverContext ctx) {
		super.initialise(task, ctx);
		regResultExpr = register.toZ3IntResult(this, ctx);
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
	protected BooleanFormula encodeExec(SolverContext ctx){
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		
		BooleanFormula enc = super.encodeExec(ctx);
		if(expr instanceof INonDet) {
			enc = bmgr.and(enc, ((INonDet)expr).encodeBounds(expr.toIntFormula(this, ctx) instanceof BitvectorFormula, ctx));
		}
		BooleanFormula eq = regResultExpr instanceof BitvectorFormula ?
				ctx.getFormulaManager().getBitvectorFormulaManager().equal(
						(BitvectorFormula)regResultExpr, 
						(BitvectorFormula)expr.toIntFormula(this, ctx)) :
				ctx.getFormulaManager().getIntegerFormulaManager().equal(
						(IntegerFormula)regResultExpr, 
						(IntegerFormula)expr.toIntFormula(this, ctx));
		return bmgr.and(enc, eq);
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Local getCopy(){
		return new Local(this);
	}
}