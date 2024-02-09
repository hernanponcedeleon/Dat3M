package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;

/*
    This is a helper class to be used to traverse/inspect expression with RegReader.transformExpressions,
    without changing the expressions.
 */
public interface ExpressionInspector extends ExpressionVisitor<Expression> {

    @Override
    default Expression visitExpression(Expression expr) {
        expr.getOperands().forEach(op -> op.accept(this));
        return expr;
    }
}
