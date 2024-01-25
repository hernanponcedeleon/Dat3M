package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public class IntSizeCast extends CastExpressionBase<IntegerType, IntegerType> {

    private final boolean preserveSign;

    protected IntSizeCast(IntegerType targetType, Expression operand, boolean preserveSign) {
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
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return null;
    }

    @Override
    public IntLiteral reduce() {
        // NOTE: The following computations are quite convoluted due to the fact that
        // we use non-unique BigInteger representations of values.
        final IntLiteral lit = operand.reduce();
        final int targetWidth = targetType.getBitWidth();
        final int sourceWidth = getSourceType().getBitWidth();
        if (isNoop()) {
            return lit;
        } else if (isTruncation()) {
            return new IntLiteral( targetType, IntegerHelper.truncateNoNormalize(lit.getValue(), targetWidth));
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
            return sourceType.getBitWidth() > targetType.getBitWidth();
        }
    }
}
