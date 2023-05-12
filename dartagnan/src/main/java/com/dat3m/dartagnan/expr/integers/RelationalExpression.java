package com.dat3m.dartagnan.expr.integers;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.helper.BinaryExpressionBase;
import com.dat3m.dartagnan.expr.types.BooleanType;
import com.dat3m.dartagnan.expr.types.IntegerType;
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
