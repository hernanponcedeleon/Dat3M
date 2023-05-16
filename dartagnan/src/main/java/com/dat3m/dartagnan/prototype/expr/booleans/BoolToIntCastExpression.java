package com.dat3m.dartagnan.prototype.expr.booleans;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.CastExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.BooleanType;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.google.common.base.Preconditions;

public class BoolToIntCastExpression extends CastExpressionBase<IntegerType, BooleanType> {

    protected BoolToIntCastExpression(Expression operand) {
        super(IntegerType.INT1, ExpressionKind.Cast.CONVERT, operand);
    }

    public static BoolToIntCastExpression create(Expression operand) {
        Preconditions.checkArgument(operand.getType() == BooleanType.get());
        return new BoolToIntCastExpression(operand);
    }

    @Override
    public String toString() {
        return getOperand().toString();
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitBoolToIntCastExpression(this);
    }
}
