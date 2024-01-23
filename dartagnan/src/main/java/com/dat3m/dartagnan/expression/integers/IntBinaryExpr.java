package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.op.IntBinaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public class IntBinaryExpr extends BinaryExpressionBase<IntegerType, IntBinaryOp> {

    public IntBinaryExpr(Expression lhs, IntBinaryOp op, Expression rhs) {
        super((IntegerType) lhs.getType(), op, lhs, rhs);
        Preconditions.checkArgument(lhs.getType().equals(rhs.getType()),
                "The types of %s and %s do not match.", lhs, rhs);
    }

    @Override
    public IntLiteral reduce() {
        BigInteger v1 = left.reduce().getValue();
        BigInteger v2 = right.reduce().getValue();
        return new IntLiteral(getType(), kind.combine(v1, v2));
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
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
