package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.op.CmpOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

public class Atom extends BinaryExpressionBase<BooleanType, CmpOp> {

    public Atom(BooleanType type, CmpOp kind, Expression left, Expression right) {
        super(type, kind, left, right);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}