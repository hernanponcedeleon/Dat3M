package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.google.common.base.Preconditions;

public final class FromMemoryCast extends CastExpressionBase<Type, MemoryType> {

    public FromMemoryCast(Type type, Expression operand) {
        super(type, operand);
        Preconditions.checkArgument(operand.getType() instanceof MemoryType);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFromMemoryCastExpression(this);
    }
}
