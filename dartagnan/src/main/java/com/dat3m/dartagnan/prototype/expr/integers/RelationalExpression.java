package com.dat3m.dartagnan.prototype.expr.integers;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.BinaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.BooleanType;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.google.common.base.Preconditions;

public class RelationalExpression extends BinaryExpressionBase<BooleanType, ExpressionKind.IntCmp> {

    protected RelationalExpression(Expression left, ExpressionKind.IntCmp intCmp, Expression right) {
        super(BooleanType.get(), intCmp, left, right);
    }

    public static RelationalExpression create(Expression left, ExpressionKind.IntCmp intCmp, Expression right) {
        Preconditions.checkArgument(left.getType() instanceof IntegerType);
        Preconditions.checkArgument(left.getType() == right.getType());
        return new RelationalExpression(left, intCmp, right);
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitRelationalExpression(this);
    }
}
