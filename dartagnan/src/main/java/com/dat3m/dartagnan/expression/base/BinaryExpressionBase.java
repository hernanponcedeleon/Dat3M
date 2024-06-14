package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.BinaryExpression;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;

import java.util.List;
import java.util.Objects;

@NoInterface
public abstract class BinaryExpressionBase<TType extends Type, TKind extends ExpressionKind>
        extends ExpressionBase<TType> implements BinaryExpression {

    protected final Expression left;
    protected final Expression right;
    protected final TKind kind;

    protected BinaryExpressionBase(TType type, TKind kind, Expression left, Expression right) {
        super(type);
        this.left = left;
        this.right = right;
        this.kind = kind;
    }

    public Expression getLeft() { return left; }
    public Expression getRight() { return right; }

    @Override
    public List<Expression> getOperands() { return List.of(left, right); }

    @Override
    public TKind getKind() { return kind; }

    @Override
    public int hashCode() {
        return Objects.hash(type, kind, left, right);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        final BinaryExpression expr = (BinaryExpression) obj;
        return this.type.equals(expr.getType())
                && this.getKind().equals(expr.getKind())
                && this.left.equals(expr.getLeft())
                && this.right.equals(expr.getRight());
    }
}
