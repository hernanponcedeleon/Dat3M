package com.dat3m.dartagnan.expr.helper;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.Type;
import com.google.common.collect.Iterables;

import java.util.List;
import java.util.Objects;

public abstract class ExpressionBase<TType extends Type, TKind extends ExpressionKind> implements Expression {

    protected final TType type;
    protected final TKind kind;
    protected final List<? extends Expression> operands;

    protected ExpressionBase(TType type, TKind kind, List<? extends Expression> operands) {
        this.type = type;
        this.kind = kind;
        this.operands = operands;
    }

    @Override
    public TType getType() { return type; }
    @Override
    public List<? extends Expression> getOperands() { return operands; }
    @Override
    public TKind getKind() { return kind; }

    @Override
    public String toString() {
        return String.format("(%s %s)", kind,
                String.join(" ", Iterables.transform(operands, Objects::toString)));
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, kind, operands);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }
        Expression other = (Expression) obj;
        return (other.getType() == this.getType())
                && (other.getKind().equals(this.kind))
                && (other.getOperands().equals(this.operands));
    }
}
