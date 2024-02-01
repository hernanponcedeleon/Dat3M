package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class FloatBinaryExpr extends BinaryExpressionBase<FloatType, FloatBinaryOp> {

    public FloatBinaryExpr(Expression left, FloatBinaryOp op, Expression right) {
        super((FloatType) left.getType(), op, left, right);
        ExpressionHelper.checkSameType(left, right);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatBinaryExpression(this);
    }

    @Override
    public int hashCode() {
        final int leftHash = left.hashCode();
        final int rightHash = right.hashCode();
        return switch (kind) {
            case FADD -> leftHash + rightHash;
            case FSUB -> leftHash - rightHash;
            case FMUL -> leftHash * rightHash;
            case FDIV ->  leftHash * (rightHash + 31);
            case FREM ->  leftHash * (rightHash + 127);
        };
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof FloatBinaryExpr expr
                && kind.equals(expr.kind)
                && left.equals(expr.left)
                && right.equals(expr.right));
    }
}
