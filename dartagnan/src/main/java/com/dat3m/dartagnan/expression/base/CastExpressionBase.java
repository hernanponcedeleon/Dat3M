package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.CastExpression;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;

import java.util.List;
import java.util.Objects;

@NoInterface
public abstract class CastExpressionBase<TTargetType extends Type, TSourceType extends Type> extends ExpressionBase<TTargetType>
        implements CastExpression {

    protected final Expression operand;

    protected CastExpressionBase(TTargetType targetType, Expression operand) {
        super(targetType);
        this.operand = operand;
    }

    @Override
    public TTargetType getTargetType() { return getType(); }

    @Override @SuppressWarnings("unchecked")
    public TSourceType getSourceType() {
        return (TSourceType) operand.getType();
    }

    @Override
    public Expression getOperand() { return operand; }

    @Override
    public List<Expression> getOperands() { return List.of(operand); }

    @Override
    public ExpressionKind.Other getKind() { return ExpressionKind.Other.CAST; }

    @Override
    public int hashCode() {
        return Objects.hash(type, operand);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        final CastExpression expr = (CastExpression) obj;
        return this.type.equals(expr.getTargetType())
                && this.operand.equals(expr.getOperand());
    }
}
