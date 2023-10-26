package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;

public final class GEPExpression implements Expression {

    private final PointerType type;
    private final Type indexingType;
    private final Expression base;
    private final List<Expression> offsets;

    GEPExpression(PointerType t, Type e, Expression b, List<Expression> o) {
        type = t;
        indexingType = e;
        base = b;
        offsets = List.copyOf(o);
    }

    public Type getIndexingType() {
        return indexingType;
    }

    public List<Type> getIndexingTypes() {
        List<Type> result = new ArrayList<>();
        result.add(indexingType);
        Type t = indexingType;
        for (Expression offset : offsets.subList(1, offsets.size())) {
            if (t instanceof ArrayType array) {
                t = array.getElementType();
            } else {
                checkState(t instanceof AggregateType struct &&
                        offset instanceof IValue literal &&
                        literal.getValueAsInt() >= 0 &&
                        literal.getValueAsInt() < struct.getDirectFields().size());
                t = ((AggregateType) t).getDirectFields().get(((IValue) offset).getValueAsInt());
            }
            result.add(t);
        }
        return result;
    }

    public Expression getBaseExpression() {
        return base;
    }

    public List<Expression> getOffsetExpressions() {
        return offsets;
    }

    @Override
    public PointerType getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        final ImmutableSet.Builder<Register> set = ImmutableSet.builder();
        set.addAll(base.getRegs());
        for (final Expression offset : offsets) {
            set.addAll(offset.getRegs());
        }
        return set.build();
    }

    @Override
    public String toString() {
        final StringBuilder string = new StringBuilder();
        string.append("GEP(").append(base);
        for (Expression offset : offsets) {
            string.append(", ").append(offset);
        }
        return string.append(")").toString();
    }
}
