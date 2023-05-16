package com.dat3m.dartagnan.prototype.expr.pointer;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.CastExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.dat3m.dartagnan.prototype.expr.types.PointerType;
import com.google.common.base.Preconditions;

public class IntToPtrExpression extends CastExpressionBase<PointerType, IntegerType> {
    protected IntToPtrExpression(Expression operand) {
        super(PointerType.get(), ExpressionKind.Cast.REINTERPRET, operand);
    }

    public static IntToPtrExpression create(Expression operand) {
        Preconditions.checkArgument(operand.getType() == IntegerType.ARCH_DEFAULT);
        return new IntToPtrExpression(operand);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitIntToPtrExpression(this);
    }
}
