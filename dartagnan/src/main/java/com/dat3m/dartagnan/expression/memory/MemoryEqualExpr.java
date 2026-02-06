package com.dat3m.dartagnan.expression.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public class MemoryEqualExpr extends BinaryExpressionBase<BooleanType, ExpressionKind> {

    public MemoryEqualExpr(BooleanType type, Expression left, Expression right) {
        super(type, () -> "EQ", left, right);
        ExpressionHelper.checkSameExpectedType(left, right, MemoryType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitMemoryEqualExpression(this);
    }
}
