package com.dat3m.dartagnan.expr.pointer;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.helper.CastExpressionBase;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.dat3m.dartagnan.expr.types.PointerType;
import com.google.common.base.Preconditions;

public class PtrToIntExpression extends CastExpressionBase<IntegerType, PointerType> {
    protected PtrToIntExpression(Expression operand) {
        super(IntegerType.ARCH_DEFAULT, ExpressionKind.Cast.REINTERPRET, operand);
    }

    public static PtrToIntExpression create(Expression operand) {
        Preconditions.checkArgument(operand.getType() == PointerType.get());
        return new PtrToIntExpression(operand);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitPtrToIntExpression(this);
    }
}
