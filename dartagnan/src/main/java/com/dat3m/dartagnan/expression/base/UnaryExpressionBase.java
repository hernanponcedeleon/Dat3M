package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.UnaryExpression;
import com.dat3m.dartagnan.program.event.common.NoInterface;

import java.util.List;
import java.util.Objects;

@NoInterface
public abstract class UnaryExpressionBase<TType extends Type, TKind extends ExpressionKind>
        extends ExpressionBase<TType> implements UnaryExpression {

    protected final Expression operand;
    protected final TKind kind;

    protected UnaryExpressionBase(TType type, TKind kind, Expression operand) {
        super(type);
        this.operand = operand;
        this.kind = kind;
    }

    public Expression getOperand() { return operand; }

    @Override
    public List<Expression> getOperands() { return List.of(operand); }

    @Override
    public TKind getKind() { return kind; }

    @Override
    public int hashCode() {
        return Objects.hash(type, kind, operand);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        final UnaryExpression expr = (UnaryExpression) obj;
        return this.type.equals(expr.getType())
                && this.getKind().equals(expr.getKind())
                && this.operand.equals(expr.getOperand());
    }
}
