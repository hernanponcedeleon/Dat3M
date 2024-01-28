package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

import java.math.BigInteger;

public final class IntBinaryExpr extends BinaryExpressionBase<IntegerType, IntBinaryOp> {

    public IntBinaryExpr(Expression left, IntBinaryOp op, Expression right) {
        super((IntegerType) left.getType(), op, left, right);
        ExpressionHelper.checkSameType(left, right);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntBinaryExpression(this);
    }

    @Override
    public int hashCode() {
        final BigInteger leftHash = BigInteger.valueOf(left.hashCode());
        final BigInteger rightHash = BigInteger.valueOf(right.hashCode());
        return kind.apply(leftHash, rightHash, 32).intValue();
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof IntBinaryExpr expr
                && kind.equals(expr.kind)
                && left.equals(expr.left)
                && right.equals(expr.right));
    }
}
