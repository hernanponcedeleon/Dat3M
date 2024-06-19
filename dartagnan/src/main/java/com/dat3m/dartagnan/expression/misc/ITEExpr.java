package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.ExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;

import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

public final class ITEExpr extends ExpressionBase<Type> {

    private final Expression condition;
    private final Expression trueCase;
    private final Expression falseCase;

    public ITEExpr(Expression condition, Expression trueCase, Expression falseCase) {
        super(trueCase.getType());
        checkArgument(condition.getType() instanceof BooleanType,
                "ITE with non-boolean condition %s.", condition);
        checkArgument(trueCase.getType().equals(falseCase.getType()),
                "ITE with mismatching cases %s and %s.", trueCase, falseCase);
        this.condition = condition;
        this.trueCase = trueCase;
        this.falseCase = falseCase;
    }

    public Expression getCondition() {
        return condition;
    }

    public Expression getTrueCase() {
        return trueCase;
    }

    public Expression getFalseCase() {
        return falseCase;
    }

    @Override
    public List<Expression> getOperands() {
        return List.of(condition, trueCase, falseCase);
    }

    @Override
    public ExpressionKind.Other getKind() {
        return ExpressionKind.Other.ITE;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitITEExpression(this);
    }

    @Override
    public int hashCode() {
        return condition.hashCode() ^ trueCase.hashCode() + falseCase.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        ITEExpr expr = (ITEExpr) obj;
        return expr.condition.equals(condition) && expr.falseCase.equals(falseCase) && expr.trueCase.equals(trueCase);
    }
}
