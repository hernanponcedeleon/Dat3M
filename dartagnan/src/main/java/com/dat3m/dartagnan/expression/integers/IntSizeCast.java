package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public class IntSizeCast extends CastExpressionBase<IntegerType, IntegerType> {

    private final boolean preserveSign;

    public IntSizeCast(IntegerType targetType, Expression operand, boolean preserveSign) {
        super(targetType, operand);
        Preconditions.checkArgument(operand.getType() instanceof IntegerType);
        this.preserveSign = (preserveSign && isExtension()) || isNoop();
    }

    public boolean isTruncation() {
        return isExtension(getTargetType(), getSourceType());
    }

    public boolean isExtension() {
        return isExtension(getSourceType(), getTargetType());
    }

    public boolean isNoop() {
        return getSourceType().equals(getTargetType());
    }

    public boolean preservesSign() {
        return preserveSign;
    }

    @Override
    public IntLiteral reduce() {
        final IntLiteral lit = getOperand().reduce();
        final int sourceWidth = getSourceType().getBitWidth();
        final int targetWidth = getTargetType().getBitWidth();
        if (isNoop()) {
            return lit;
        } else if (isTruncation()) {
            return new IntLiteral(targetType, IntegerHelper.truncateNoNormalize(lit.getValue(), targetWidth));
        } else {
            assert isExtension();
            final BigInteger extendedValue = IntegerHelper.extend(lit.getValue(), sourceWidth, targetWidth, preserveSign);
            return new IntLiteral(targetType, extendedValue);
        }
    }

    private static boolean isExtension(IntegerType sourceType, IntegerType targetType) {
        if (sourceType.isMathematical()) {
            return false;
        } else if (targetType.isMathematical()) {
            return true;
        } else {
            return sourceType.getBitWidth() < targetType.getBitWidth();
        }
    }

    @Override
    public String toString() {
        final String opName = isTruncation() ? "trunc" : (preserveSign ? "sext" : "zext");
        return String.format("%s %s to %s", operand, opName, targetType);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntSizeCastExpression(this);
    }
}
