package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class BoolBinaryExpr extends BinaryExpressionBase<BooleanType, BoolBinaryOp> {

    public BoolBinaryExpr(Expression lhs, BoolBinaryOp op, Expression rhs) {
        super((BooleanType) lhs.getType(), op, lhs, rhs);
        ExpressionHelper.checkSameType(lhs, rhs);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitBoolBinaryExpression(this);
    }

}
