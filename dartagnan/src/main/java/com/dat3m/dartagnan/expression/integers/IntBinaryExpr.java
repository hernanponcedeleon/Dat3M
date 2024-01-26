package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

import java.math.BigInteger;

public class IntBinaryExpr extends BinaryExpressionBase<IntegerType, IntBinaryOp> {

    public IntBinaryExpr(Expression left, IntBinaryOp op, Expression right) {
        super((IntegerType) left.getType(), op, left, right);
        ExpressionHelper.checkSameType(left, right);
    }

    @Override
    public IntLiteral reduce() {
        BigInteger v1 = left.reduce().getValue();
        BigInteger v2 = right.reduce().getValue();
        return new IntLiteral(getType(), kind.combine(v1, v2));
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntBinaryExpression(this);
    }

    @Override
    public int hashCode() {
        if (kind.equals(IntBinaryOp.RSHIFT)) {
            return left.hashCode() >>> right.hashCode();
        }
        return (kind.combine(BigInteger.valueOf(left.hashCode()), BigInteger.valueOf(right.hashCode()))).intValue();
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof IntBinaryExpr expr
                && kind.equals(expr.kind)
                && left.equals(expr.left)
                && right.equals(expr.right));
    }
}
