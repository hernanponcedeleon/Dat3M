package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class PtrSizeCast extends CastExpressionBase<PointerType, PointerType> {

    private final boolean preserveSign;

    public PtrSizeCast(PointerType targetType, Expression operand, boolean preserveSign) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, PointerType.class);
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

    private static boolean isExtension(PointerType sourceType, PointerType targetType) {
        return sourceType.getBitWidth() < targetType.getBitWidth();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrSizeCastExpression(this);
    }
}
