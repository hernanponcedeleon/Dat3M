package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.op.BoolBinaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

public class BoolBinaryExpr extends BinaryExpressionBase<BooleanType, BoolBinaryOp> {

    public BoolBinaryExpr(BooleanType type, Expression lhs, BoolBinaryOp op, Expression rhs) {
        super(type, op, lhs, rhs);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

}
