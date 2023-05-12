package com.dat3m.dartagnan.expr.integers;

import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Literal;
import com.dat3m.dartagnan.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public class IntLiteral extends LeafExpressionBase<IntegerType, ExpressionKind.Leaf> implements Literal<BigInteger> {

    private final BigInteger value;

    protected IntLiteral(IntegerType type, BigInteger value) {
        super(type, ExpressionKind.Leaf.LITERAL);
        this.value = value;
    }

    public static IntLiteral create(IntegerType type, BigInteger value) {
        Preconditions.checkArgument(type.canContain(value),"Value %s does not fit into type %s", value, type);
        return new IntLiteral(type, value);
    }

    public static IntLiteral create(IntegerType type, long value) {
        return create(type, BigInteger.valueOf(value));
    }

    @Override
    public BigInteger getValue() { return value; }

    public boolean isZero() { return this.value.equals(BigInteger.ZERO); }
    public boolean isOne() { return this.value.equals(BigInteger.ONE); }

    @Override
    public String toString() { return value.toString(); }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitIntLiteral(this);
    }
}
