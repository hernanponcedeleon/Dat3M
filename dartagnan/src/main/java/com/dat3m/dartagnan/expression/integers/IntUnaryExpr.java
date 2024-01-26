package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;

import static com.google.common.base.Verify.verify;

public class IntUnaryExpr extends UnaryExpressionBase<IntegerType, IntUnaryOp> {

    public IntUnaryExpr(IntUnaryOp operator, Expression operand, IntegerType t) {
        super(t, operator, operand);
    }

    @Override
    public IntLiteral reduce() {
        if (!(operand.getType() instanceof IntegerType innerType)) {
            throw new IllegalStateException(String.format("Non-integer operand %s.", operand));
        }
        IntLiteral inner = operand.reduce();
        verify(inner.getType().equals(innerType),
                "Reduced to wrong type %s instead of %s.", inner.getType(), innerType);
        BigInteger value = inner.getValue();
        IntegerType targetType = getType();
        switch (kind) {
            case MINUS -> {
                return new IntLiteral(targetType, value.negate());
            }
            case CTLZ -> {
                if (innerType.isMathematical()) {
                    throw new UnsupportedOperationException(
                            String.format("Counting leading zeroes in mathematical integer %s.", inner));
                }
                if (value.signum() == -1) {
                    return new IntLiteral(targetType, BigInteger.ZERO);
                }
                int bitWidth = innerType.getBitWidth();
                int length = value.bitLength();
                verify(length <= bitWidth, "Value %s returned by %s not in range of type %s.", value);
                return new IntLiteral(targetType, BigInteger.valueOf(bitWidth - length));
            }
            default -> throw new UnsupportedOperationException("Reduce not supported for " + this);
        }
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntUnaryExpression(this);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj == this || obj instanceof IntUnaryExpr expr
                && type.equals(expr.type)
                && kind.equals(expr.kind)
                && operand.equals(expr.operand));
    }
}
