package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;

import java.util.Map;

// Visits expressions and has a final result interval as a field
final class AbstractExpressionEvaluator implements ExpressionVisitor<Interval> {
    private final Map<Register, Interval> eventState;
    private final Interval resultInterval;
    private final IntegerType type;

    public Interval getResultInterval() {
        return resultInterval;
    }
    AbstractExpressionEvaluator(IntegerType type, Expression expr, Map<Register, Interval> eventState) {
        this.eventState = eventState;
        this.type = type;
        resultInterval = expr.accept(this);
    }

    @Override
    public Interval visitExpression(Expression expr) {
        return Interval.getTop(type);
    }

    @Override
    public Interval visitIntLiteral(IntLiteral lit) {
        return new Interval(lit.getValue(), type);
    }

    @Override
    public Interval visitRegister(Register regExpr) {
        Interval registerInterval = eventState.getOrDefault(regExpr, Interval.getTop(type));
        return new Interval(registerInterval.getLowerbound(), registerInterval.getUpperbound(), type);
    }

    @Override
    public Interval visitIntSizeCastExpression(IntSizeCast cast) {
        Interval operandInterval = cast.getOperand().accept(this);
        IntegerType targetType = cast.getTargetType();

        if (!cast.preservesSign() && cast.isExtension()) {
            return Interval.getTop(targetType);
        } else {

            // Interval constructor to return top with eventual overflow regarding truncation.
            return new Interval(operandInterval.getLowerbound(), operandInterval.getUpperbound(), targetType);
        }
    }

    @Override
    public Interval visitIntBinaryExpression(IntBinaryExpr binExpr) {
        IntBinaryOp op = binExpr.getKind();
        Interval intervalLeft = binExpr.getLeft().accept(this);
        Interval intervalRight = binExpr.getRight().accept(this);

        return intervalLeft.applyOperator(op, intervalRight);
    }

    @Override
    public Interval visitIntUnaryExpression(IntUnaryExpr expr) {
        return expr.getOperand().accept(this).applyOperator(expr.getKind());
    }

    @Override
    public Interval visitITEExpression(ITEExpr ite) {
        Interval trueInterval = ite.getTrueCase().accept(this);
        Interval falseInterval = ite.getFalseCase().accept(this);

        return trueInterval.join(falseInterval);
    }
}
