package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;

public final class MemoryExtend extends CastExpressionBase<MemoryType, MemoryType> {

    public MemoryExtend(MemoryType targetType, Expression operand) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, MemoryType.class);
        Preconditions.checkArgument(isExtension(getSourceType(), targetType));
    }


    public boolean isExtension() {
        return isExtension(getSourceType(), getTargetType());
    }

    public boolean isNoop() {
        return getSourceType().equals(getTargetType());
    }

    private static boolean isExtension(MemoryType sourceType, MemoryType targetType) {
        return sourceType.getBitWidth() < targetType.getBitWidth();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitMemoryExtend(this);
    }
}
