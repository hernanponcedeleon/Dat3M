package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.misc.CmpOp;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class IntCmpExpr extends BinaryExpressionBase<BooleanType, CmpOp> {

    public IntCmpExpr(BooleanType type, Expression left, CmpOp kind, Expression right) {
        super(type, kind, left, right);
        ExpressionHelper.checkSameExpectedType(left, right, IntegerType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntCmpExpression(this);
    }
}