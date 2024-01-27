package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;

public final class IntUnaryExpr extends UnaryExpressionBase<IntegerType, IntUnaryOp> {

    public IntUnaryExpr(IntUnaryOp operator, Expression operand) {
        super((IntegerType) operand.getType(), operator, operand);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntUnaryExpression(this);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj == this || obj instanceof IntUnaryExpr expr
                && kind.equals(expr.kind)
                && operand.equals(expr.operand));
    }
}
