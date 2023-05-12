package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

public class IExprUn extends IExpr {

    private final IExpr b;
    private final IOpUn op;

    public IExprUn(IOpUn op, IExpr b) {
        this.b = b;
        this.op = op;
    }

    public IOpUn getOp() {
        return op;
    }

    public IExpr getInner() {
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
        IConst inner = b.reduce();
        switch (op) {
            case MINUS:
            return new IValue(inner.getValue().negate(), b.getType());
            case BV2UINT: case BV2INT:
            case INT2BV1: case INT2BV8: case INT2BV16: case INT2BV32: case INT2BV64: 
            case TRUNC6432: case TRUNC6416: case TRUNC648: case TRUNC641: case TRUNC3216: case TRUNC328: case TRUNC321: case TRUNC168: case TRUNC161: case TRUNC81:
            case ZEXT18: case ZEXT116: case ZEXT132: case ZEXT164: case ZEXT816: case ZEXT832: case ZEXT864: case ZEXT1632: case ZEXT1664: case ZEXT3264: 
            case SEXT18: case SEXT116: case SEXT132: case SEXT164: case SEXT816: case SEXT832: case SEXT864: case SEXT1632: case SEXT1664: case SEXT3264:
                return inner;
            case CTLZ:
                int leading;
                IntegerType type = (IntegerType) inner.getType();
                switch (type.getBitWidth()) {
                    case 32:
                        leading = Integer.numberOfLeadingZeros(inner.getValueAsInt());
                        break;
                    case 64:
                        leading = Long.numberOfLeadingZeros(inner.getValueAsInt());
                        break;
                    default:
                        throw new UnsupportedOperationException(
                                "Reduce not supported for " + this + " with precision " + type.getBitWidth());
                }
                return new IValue(BigInteger.valueOf(leading), inner.getType());
            default:
                throw new UnsupportedOperationException("Reduce not supported for " + this);
        }
    }

    @Override
    public Type getType() {
        TypeFactory types = TypeFactory.getInstance();
        switch (op) {
            case MINUS:
                return b.getType();
            case BV2UINT: case BV2INT:
                return types.getPointerType();
            case INT2BV1: case TRUNC321: case TRUNC641: case TRUNC161: case TRUNC81:
                return types.getIntegerType(1);
            case INT2BV8: case TRUNC648: case TRUNC328: case TRUNC168: case ZEXT18: case SEXT18:
                return types.getIntegerType(8);
            case INT2BV16: case TRUNC6416: case TRUNC3216: case ZEXT116: case ZEXT816: case SEXT116: case SEXT816:
                return types.getIntegerType(16);
            case INT2BV32: case TRUNC6432: case ZEXT132: case ZEXT832: case ZEXT1632: case SEXT132: case SEXT832: case SEXT1632:
                return types.getIntegerType(32);
            case INT2BV64: case ZEXT164: case ZEXT864: case ZEXT1664: case ZEXT3264: case SEXT164: case SEXT864: case SEXT1664: case SEXT3264:
                return types.getIntegerType(64);
            default:
                throw new UnsupportedOperationException("getPrecision not supported for " + this);
        }
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
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
