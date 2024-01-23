package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.base.ExpressionBase;
import com.dat3m.dartagnan.expression.op.Kind;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.Type;

import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

public class ITEExpr extends ExpressionBase<Type> {

    private final Expression condition;
    private final Expression trueCase;
    private final Expression falseCase;

    ITEExpr(Expression condition, Expression trueCase, Expression falseCase) {
        super(trueCase.getType());
        checkArgument(condition.getType() instanceof BooleanType,
                "ITE with non-boolean condition %s.", condition);
        checkArgument(trueCase.getType().equals(falseCase.getType()),
                "ITE with mismatching cases %s and %s.", trueCase, falseCase);
        this.condition = condition;
        this.trueCase = trueCase;
        this.falseCase = falseCase;
    }

    @Override
    public String toString() {
        return String.format("ITE(%s, %s, %s)", condition, trueCase, falseCase);
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
    public ExpressionKind getKind() {
        return Kind.ITE;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
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
