package com.dat3m.dartagnan.prototype.expr.booleans;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.BinaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.BooleanType;
import com.google.common.base.Preconditions;

public class BoolBinaryExpression extends BinaryExpressionBase<BooleanType, ExpressionKind.BoolBinary> {

    protected BoolBinaryExpression(Expression left, ExpressionKind.BoolBinary op, Expression right) {
        super(BooleanType.get(), op, left, right);
    }

    public static BoolBinaryExpression create(Expression left, ExpressionKind.BoolBinary op, Expression right) {
        Preconditions.checkArgument(left.getType() == BooleanType.get());
        Preconditions.checkArgument(right.getType() == BooleanType.get());
        return new BoolBinaryExpression(left, op, right);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitBoolBinaryExpression(this);
    }
}
