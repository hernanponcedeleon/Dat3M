package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.Type;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkArgument;

public final class ExpressionFactory {

    private static final Logger logger = LogManager.getLogger(ExpressionFactory.class);
    private static final ExpressionFactory instance = new ExpressionFactory();

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    public BConst makeTrue() {
        return BConst.TRUE;
    }

    public BConst makeFalse() {
        return BConst.FALSE;
    }

    public BConst makeValue(boolean value) {
        return value ? BConst.TRUE : BConst.FALSE;
    }

    public IValue makeZero(Type type) {
        return makeValue(BigInteger.ZERO, type);
    }

    public IValue makeOne(Type type) {
        return makeValue(BigInteger.ONE, type);
    }

    public IValue parseValue(String text, Type type) {
        return makeValue(new BigInteger(text), type);
    }

    public IValue makeValue(BigInteger value, Type type) {
        return new IValue(value, type);
    }

    public Expression makeUnary(BOpUn operator, Expression inner) {
        if (!inner.isBoolean()) {
            logger.warn("Non-boolean operand for {} {}.", operator, inner);
        }
        assert operator.equals(BOpUn.NOT);
        if (inner instanceof BConst) {
            return makeValue(inner.isFalse());
        }
        if (inner instanceof BExprUn) {
            assert ((BExprUn) inner).getOp().equals(BOpUn.NOT);
            return ((BExprUn) inner).getInner();
        }
        return new BExprUn(operator, inner);
    }

    public Expression makeUnary(IOpUn operator, Expression inner) {
        Type type = inner.getType();
        if (inner instanceof IValue) {
            BigInteger value = ((IValue) inner).getValue();
            switch (operator) {
                case MINUS:
                    return new IValue(value.negate(), type);
                case BV2UINT: case BV2INT:
                case INT2BV1: case INT2BV8: case INT2BV16: case INT2BV32: case INT2BV64:
                case TRUNC6432: case TRUNC6416: case TRUNC648: case TRUNC641: case TRUNC3216: case TRUNC328: case TRUNC321: case TRUNC168: case TRUNC161: case TRUNC81:
                case ZEXT18: case ZEXT116: case ZEXT132: case ZEXT164: case ZEXT816: case ZEXT832: case ZEXT864: case ZEXT1632: case ZEXT1664: case ZEXT3264:
                case SEXT18: case SEXT116: case SEXT132: case SEXT164: case SEXT816: case SEXT832: case SEXT864: case SEXT1632: case SEXT1664: case SEXT3264:
                    //TODO adjust type and truncate
                    return inner;
                case CTLZ:
                    checkArgument(type instanceof IntegerType, "Type mismatch for %s %s.", operator, inner);
                    int leadingZeroes = ((IntegerType) type).getBitWidth() - value.bitLength();
                    checkArgument(leadingZeroes >= 0, "Range miss in %s %s.", operator, inner);
                    return makeValue(BigInteger.valueOf(leadingZeroes), type);
                default:
                    throw new UnsupportedOperationException("Reduce not supported for " + this);
            }
        }
        if (inner instanceof IExprUn && operator.equals(IOpUn.MINUS) && ((IExprUn) inner).getOp().equals(IOpUn.MINUS)) {
            return ((IExprUn) inner).getInner();
        }
        //TODO expansion followed by truncation
        return new IExprUn(operator, inner);
    }

    public Expression makeBinary(Expression left, BOpBin operator, Expression right) {
        if (!left.isBoolean() || !right.isBoolean()) {
            logger.warn("Non-boolean operands {} {} {}.", left, operator, right);
        }
        boolean isAnd = operator.equals(BOpBin.AND);
        assert isAnd || operator.equals(BOpBin.OR);
        if (left.equals(right)) {
            return left;
        }
        if (left.isTrue() || right.isFalse()) {
            return isAnd ? right : left;
        }
        if (left.isFalse() || right.isTrue()) {
            return isAnd ? left : right;
        }
        return new BExprBin(left, operator, right);
    }

    public Expression makeBinary(Expression left, COpBin comparator, Expression right) {
        checkTypes(left, comparator, right);
        checkArgument(!left.isBoolean() || comparator.equals(COpBin.EQ) || comparator.equals(COpBin.NEQ),
                "Incompatible types for %s %s %s.", left, comparator, right);
        if (left.equals(right)) {
            switch (comparator) {
                case EQ: case LTE: case ULTE: case GTE: case UGTE:
                    return makeTrue();
            }
            return makeFalse();
        }
        if (left.isTrue() || left.isFalse()) {
            return comparator.equals(COpBin.EQ) == left.isTrue() ? right : makeUnary(BOpUn.NOT, right);
        }
        if (right.isTrue() || right.isFalse()) {
            return comparator.equals(COpBin.EQ) == right.isTrue() ? left : makeUnary(BOpUn.NOT, left);
        }
        return new Atom(left, comparator, right);
    }

    public Expression makeBinary(Expression left, IOpBin operator, Expression right) {
        checkTypes(left, operator, right);
        if (left instanceof IValue && right instanceof IValue) {
            BigInteger result = operator.combine(((IValue) left).getValue(), ((IValue) right).getValue());
            return makeValue(result, left.getType());
        }
        switch (operator) {
            case PLUS:
                if (left instanceof IValue && ((IValue) left).getValue().equals(BigInteger.ZERO)) {
                    return right;
                }
                if (right instanceof IValue && ((IValue) right).getValue().equals(BigInteger.ZERO)) {
                    return left;
                }
            case MULT:
                if (left instanceof IValue && ((IValue) left).getValue().equals(BigInteger.ZERO)) {
                    return left;
                }
                if (right instanceof IValue && ((IValue) right).getValue().equals(BigInteger.ZERO)) {
                    return right;
                }
                if (left instanceof IValue && ((IValue) left).getValue().equals(BigInteger.ONE)) {
                    return right;
                }
                if (right instanceof IValue && ((IValue) right).getValue().equals(BigInteger.ONE)) {
                    return left;
                }
        }
        return new IExprBin(left, operator, right);
    }

    public Expression makeConditional(Expression condition, Expression ifTrue, Expression ifFalse) {
        if (!condition.isBoolean()) {
            logger.warn("Non-boolean guard for {} ? {} : {}.", condition, ifTrue, ifFalse);
        }
        if (ifTrue.equals(ifFalse) || condition.isFalse()) {
            return ifFalse;
        }
        if (condition.isTrue()) {
            return ifTrue;
        }
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    private void checkTypes(Expression left, Object operator, Expression right) {
        if (!left.getType().equals(right.getType())) {
            logger.warn("Type mismatch: {} {} {}", left, operator, right);
        }
    }
}
