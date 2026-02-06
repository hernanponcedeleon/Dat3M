package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class PtrCmpExpr extends BinaryExpressionBase<BooleanType, PtrCmpOp> {

    public PtrCmpExpr(BooleanType type, Expression left, PtrCmpOp kind, Expression right) {
        super(type, kind, left, right);
        ExpressionHelper.checkSameExpectedType(left, right, PointerType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrCmpExpression(this);
    }
}