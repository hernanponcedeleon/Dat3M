package com.dat3m.dartagnan.prototype.expr.integers;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.UnaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.google.common.base.Preconditions;

public class IntUnaryExpression extends UnaryExpressionBase<IntegerType, ExpressionKind.IntUnary> {

    protected IntUnaryExpression(ExpressionKind.IntUnary op, Expression operand) {
        super((IntegerType) operand.getType(), op, operand);
    }

    public static IntUnaryExpression create(ExpressionKind.IntUnary op, Expression operand) {
        Preconditions.checkArgument(operand.getType() instanceof IntegerType);
        return new IntUnaryExpression(op, operand);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitIntUnaryExpression(this);
    }
}