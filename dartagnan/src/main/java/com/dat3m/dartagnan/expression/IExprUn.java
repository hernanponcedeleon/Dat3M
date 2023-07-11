package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import static com.google.common.base.Verify.verify;

public class IExprUn extends IExpr {

    private final Expression b;
    private final IOpUn op;

    public IExprUn(IOpUn op, Expression b, IntegerType t) {
        super(t);
        this.b = b;
        this.op = op;
    }

    public IOpUn getOp() {
        return op;
    }

    public Expression getInner() {
        return b;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return b.getRegs();
    }

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }

    @Override
    public IConst reduce() {
        if (!(b.getType() instanceof IntegerType innerType)) {
            throw new IllegalStateException(String.format("Non-integer operand %s.", b));
        }
        IConst inner = b.reduce();
        verify(inner.getType().equals(innerType),
                "Reduced to wrong type %s instead of %s.", inner.getType(), innerType);
        BigInteger value = inner.getValue();
        IntegerType targetType = getType();
        switch (op) {
            case CAST_SIGNED, CAST_UNSIGNED -> {
                boolean signed = op.equals(IOpUn.CAST_SIGNED);
                boolean truncate = !targetType.isMathematical() &&
                        (innerType.isMathematical() || targetType.getBitWidth() < innerType.getBitWidth());
                if (truncate) {
                    BigInteger v = value;
                    for (int i = targetType.getBitWidth(); i < value.bitLength(); i++) {
                        v = v.clearBit(i);
                    }
                    return new IValue(v, targetType);
                }
                if (!innerType.isMathematical()) {
                    verify(innerType.canContain(value), "");
                    BigInteger result = innerType.applySign(value, signed);
                    return new IValue(result, targetType);
                }
                return new IValue(value, targetType);
            }
            case MINUS -> {
                return new IValue(value.negate(), targetType);
            }
            case CTLZ -> {
                if (innerType.isMathematical()) {
                    throw new UnsupportedOperationException(
                            String.format("Counting leading zeroes in mathematical integer %s.", inner));
                }
                if (value.signum() == -1) {
                    return new IValue(BigInteger.ZERO, targetType);
                }
                int bitWidth = innerType.getBitWidth();
                int length = value.bitLength();
                verify(length <= bitWidth, "Value %s returned by %s not in range of type %s.", value);
                return new IValue(BigInteger.valueOf(bitWidth - length), targetType);
            }
            default -> throw new UnsupportedOperationException("Reduce not supported for " + this);
        }
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return op.hashCode() ^ b.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        IExprUn expr = (IExprUn) obj;
        return expr.op == op && expr.b.equals(b);
    }
}
