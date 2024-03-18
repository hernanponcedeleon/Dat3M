package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;

public final class FloatUnaryExpr extends UnaryExpressionBase<FloatType, FloatUnaryOp> {

    public FloatUnaryExpr(FloatUnaryOp operator, Expression operand) {
        super((FloatType) operand.getType(), operator, operand);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatUnaryExpression(this);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj == this || obj instanceof FloatUnaryExpr expr
                && kind.equals(expr.kind)
                && operand.equals(expr.operand));
    }
}
