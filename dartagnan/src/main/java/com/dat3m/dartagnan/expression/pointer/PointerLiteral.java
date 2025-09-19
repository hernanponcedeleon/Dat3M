package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public final class PointerLiteral extends LiteralExpressionBase<PointerType> {

    private final BigInteger value;

    public PointerLiteral(PointerType type, BigInteger value) {
        super(type);
        this.value = value;
    }

    public BigInteger getValue() {
        return value;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitPtrLiteral(this);
    }


    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof PointerLiteral val && getType().equals(val.getType()) && value.equals(val.value);
    }

    @Override
    public String toString() {
        return String.format("%s(%s)", getType(), value);
    }
}
