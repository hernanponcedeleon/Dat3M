package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;

//TODO instances of this class should be managed by the program
public class BNonDet extends BExpr {

	public BNonDet(BooleanType type) {
		super(type);
	}

	@Override
	public String toString() {
		return "nondet_bool()";
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}
}
