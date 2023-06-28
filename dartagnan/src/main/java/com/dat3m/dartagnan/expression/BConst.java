package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

public class BConst extends BExpr {

	private final boolean value;
	
	public BConst(BooleanType type, boolean value) {
		super(type);
		this.value = value;
	}

    @Override
	public String toString() {
		return value ? "True" : "False";
	}

    public boolean getValue() {
		return value;
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return Boolean.hashCode(value);
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		} else if (obj == null || obj.getClass() != getClass()) {
			return false;
		}
		return ((BConst)obj).value == value;
	}
}
