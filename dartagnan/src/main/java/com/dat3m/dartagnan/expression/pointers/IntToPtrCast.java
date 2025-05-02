package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class IntToPtrCast extends CastExpressionBase<PointerType, IntegerType> {

    public IntToPtrCast(PointerType pointerType, Expression operand) {
        super(pointerType, operand);
        ExpressionHelper.checkExpectedType(operand, IntegerType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntToPtrCastExpression(this);
    }
}
