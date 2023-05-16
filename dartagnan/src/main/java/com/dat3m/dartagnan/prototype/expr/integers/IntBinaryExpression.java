package com.dat3m.dartagnan.prototype.expr.integers;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.BinaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.google.common.base.Preconditions;

public class IntBinaryExpression extends BinaryExpressionBase<IntegerType, ExpressionKind.IntBinary> {

    protected IntBinaryExpression(Expression left, ExpressionKind.IntBinary op, Expression right) {
        super((IntegerType) left.getType(), op, left, right);
    }

    public static IntBinaryExpression create(Expression left, ExpressionKind.IntBinary op, Expression right) {
        Preconditions.checkArgument(left.getType() instanceof IntegerType);
        Preconditions.checkArgument(left.getType() == right.getType());
        return new IntBinaryExpression(left, op, right);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitIntBinaryExpression(this);
    }
}
