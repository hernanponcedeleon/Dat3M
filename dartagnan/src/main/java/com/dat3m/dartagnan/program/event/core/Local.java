package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import java.util.ArrayList;
import java.util.List;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected final Register register;
	protected ExprInterface expr;

	public Local(Register register, ExprInterface expr) {
		this.register = register;
		this.expr = expr;
		addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_WRITER, Tag.REG_READER);
	}
	
	protected Local(Local other){
		super(other);
		this.register = other.register;
		this.expr = other.expr;
	}

	public ExprInterface getExpr(){
		return expr;
	}

	public void setExpr(ExprInterface expr){
		this.expr = expr;
	}

	@Override
	public Register getResultRegister(){
		return register;
	}

	@Override
	public ImmutableSet<Register> getDataRegs(){
		return expr.getRegs();
	}

    @Override
	public String toString() {
		return register + " <- " + expr;
	}

	@Override
	public List<BooleanFormula> encodeExec(EncodingContext context) {
		FormulaManager fmgr = context.getFormulaManager();
		List<BooleanFormula> enc = new ArrayList<>(super.encodeExec(context));
		if(expr instanceof INonDet) {
			enc.add(((INonDet)expr).encodeBounds(expr.toIntFormula(this, fmgr) instanceof BitvectorFormula, fmgr));
		}
		enc.add(context.equal(context.result(this), expr.toIntFormula(this, fmgr)));
		return enc;
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Local getCopy(){
		return new Local(this);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLocal(this);
	}
}