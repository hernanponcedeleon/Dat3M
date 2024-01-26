package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.op.BoolUnaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

public class BoolUnaryExpr extends UnaryExpressionBase<BooleanType, BoolUnaryOp> {

    public BoolUnaryExpr(BooleanType type, BoolUnaryOp operatorKind, Expression operand) {
        super(type, operatorKind, operand);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitBoolUnaryExpression(this);
    }
}
