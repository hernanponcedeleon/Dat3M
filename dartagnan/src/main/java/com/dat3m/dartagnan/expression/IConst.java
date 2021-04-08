package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IConst extends IExpr implements ExprInterface {

	// The theory of integers supports numbers which do not  fit 
	// in int or long types, thus we represent them as strings
	private final String value;
	protected final int precision;
	
	public IConst(long value, int precision) {
		this.value = Long.toString(value);
		this.precision = precision;
	}

	public IConst(String value, int precision) {
		this.value = value;
		this.precision = precision;
	}

	@Override
	public Expr toZ3Int(Event e, Context ctx) {
		return precision > 0 ? ctx.mkBV(value, precision) : ctx.mkInt(value);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return value;
	}

	@Override
	public Expr getLastValueExpr(Context ctx){
		return precision > 0 ? ctx.mkBV(value, precision) : ctx.mkInt(value);
	}

	@Override
	public long getIntValue(Event e, Model model, Context ctx){
		return Long.parseLong(value);
	}

    public Expr toZ3Int(Context ctx) {
		return precision > 0 ? ctx.mkBV(value, precision) : ctx.mkInt(value);
    }

	@Override
	public IConst reduce() {
		return this;
	}
	
	public long getValue() {
		return Long.parseLong(value);
	}
    
	@Override
	public int getPrecision() {
    	return precision;
    }

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return precision > 0 ? value.hashCode() : value.hashCode() + precision;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}
		if (obj == null || obj.getClass() != getClass())
			return false;
		IConst expr = (IConst) obj;
		return expr.value.equals(value) && expr.precision == precision;
	}
}
