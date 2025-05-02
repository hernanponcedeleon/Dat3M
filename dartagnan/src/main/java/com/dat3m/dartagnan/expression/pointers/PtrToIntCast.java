package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class PtrToIntCast extends CastExpressionBase<IntegerType, PointerType> {

    public PtrToIntCast(IntegerType archType, Expression operand) {
        super(archType, operand);
        ExpressionHelper.checkExpectedType(operand, PointerType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrToIntCastExperssion(this);
    }
}
