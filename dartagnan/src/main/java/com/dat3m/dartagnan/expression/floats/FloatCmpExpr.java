package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class FloatCmpExpr extends BinaryExpressionBase<BooleanType, FloatCmpOp> {

    public FloatCmpExpr(BooleanType type, Expression left, FloatCmpOp kind, Expression right) {
        ExpressionHelper.checkSameExpectedType(left, right, FloatType.class);
        super(type, kind, left, right);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatCmpExpression(this);
    }
}