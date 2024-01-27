package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.google.common.base.Preconditions;

import static com.google.common.base.Preconditions.checkArgument;

public final class ExtractExpr extends UnaryExpressionBase<Type, ExpressionKind.Other> {

    private final int index;

    public ExtractExpr(int index, Expression expr) {
        super(extractType(expr, index), ExpressionKind.Other.EXTRACT, expr);
        this.index = index;
    }

    private static Type extractType(Expression expr, int index) {
        final Type exprType = expr.getType();
        Preconditions.checkArgument(exprType instanceof AggregateType || exprType instanceof ArrayType,
                "Cannot extract from a non-aggregate expression: (%s)[%d].", expr, index);
        if (exprType instanceof AggregateType aggregateType) {
            return aggregateType.getDirectFields().get(index);
        } else {
            final ArrayType arrayType = (ArrayType) exprType;
            checkArgument(0 <= index && (!arrayType.hasKnownNumElements() || index < arrayType.getNumElements()),
                    "Index %s out of bounds [0,%s].", index, arrayType.getNumElements() - 1);
            return arrayType.getElementType();
        }
    }

    public int getFieldIndex() {
        return index;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitExtractExpression(this);
    }

    @Override
    public String toString() {
        return String.format("%s[%d]", operand, index);
    }
}
