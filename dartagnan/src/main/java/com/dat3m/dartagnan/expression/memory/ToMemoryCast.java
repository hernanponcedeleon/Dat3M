package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.MemoryType;

public final class ToMemoryCast extends CastExpressionBase<MemoryType, Type> {

    public ToMemoryCast(MemoryType type, Expression operand) {
        super(type, operand);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitToMemoryCastExpression(this);
    }
}
