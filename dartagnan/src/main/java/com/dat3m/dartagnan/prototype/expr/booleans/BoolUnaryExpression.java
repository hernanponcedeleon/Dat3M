package com.dat3m.dartagnan.prototype.expr.booleans;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.UnaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.BooleanType;
import com.google.common.base.Preconditions;

public class BoolUnaryExpression extends UnaryExpressionBase<BooleanType, ExpressionKind.BoolUnary> {

    protected BoolUnaryExpression(ExpressionKind.BoolUnary op, Expression operand) {
        super(BooleanType.get(), op, operand);
    }

    public static BoolUnaryExpression create(ExpressionKind.BoolUnary op, Expression operand) {
        Preconditions.checkArgument(operand.getType() == BooleanType.get());
        return new BoolUnaryExpression(op, operand);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitBoolUnaryExpression(this);
    }
}
