package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

public class Location implements ExprInterface {

	public static final BigInteger DEFAULT_INIT_VALUE = BigInteger.ZERO;

	private final String name;
	private final Address address;

	public Location(String name, Address address) {
		this.name = name;
		this.address = address;
	}
	
	public String getName() {
		return name;
	}

	public Address getAddress() {
		return address;
	}

	@Override
	public String toString() {
		return name;
	}

	@Override
	public int hashCode(){
		return address.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		} else if (obj == null || getClass() != obj.getClass()) {
			return false;
		}

		return address.hashCode() == obj.hashCode();
	}

	@Override
	public ImmutableSet<Register> getRegs(){
		return ImmutableSet.of();
	}

	@Override
	public ImmutableSet<Location> getLocs() {
		return ImmutableSet.of(this);
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		return address.getLastMemValueExpr(ctx);
	}

	@Override
	public Formula toIntFormula(Event e, SolverContext ctx){
		Preconditions.checkArgument(e instanceof MemEvent, "Attempt to encode memory value for illegal event %s", e);
		return ((MemEvent) e).getMemValueExpr();
	}

	@Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx){
		Preconditions.checkArgument(e instanceof MemEvent, "Attempt to encode memory value for illegal event %s", e);
		IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
		return imgr.greaterThan((IntegerFormula)((MemEvent) e).getMemValueExpr(), imgr.makeNumber(BigInteger.ZERO));
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
		Preconditions.checkArgument(e instanceof MemEvent, "Attempt to obtain memory value for illegal event %s", e);
		if(e instanceof Store || e instanceof Init){
			return ((MemEvent) e).getMemValue().getIntValue(e, model, ctx);
		} else if(e instanceof Load){
			Register reg = ((Load) e).getResultRegister();
			return new BigInteger(model.evaluate(reg.toIntFormulaResult(e, ctx)).toString());
		}

		throw new IllegalArgumentException("Encountered unrecognized MemEvent when retrieving int value from model: " + e);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx) {
		Preconditions.checkArgument(e instanceof MemEvent, "Attempt to obtain memory value for illegal event %s", e);
		return ((MemEvent) e).getMemValue().getBoolValue(e, model, ctx);
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
		return address.getPrecision();
	}

	@Override
	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase not supported for " + this);
	}
}
