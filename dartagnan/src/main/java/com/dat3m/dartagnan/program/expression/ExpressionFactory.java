package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.expression.type.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.google.common.base.Preconditions.checkArgument;

public final class ExpressionFactory {

    private static final Logger logger = LogManager.getLogger(ExpressionFactory.class);
    private final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory instance = new ExpressionFactory();

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    public Literal makeTrue() {
        return makeValue(BigInteger.ONE, types.getBooleanType());
    }

    public Literal makeFalse() {
        return makeValue(BigInteger.ZERO, types.getBooleanType());
    }

    public Literal makeValue(boolean value) {
        return value ? makeTrue() : makeFalse();
    }

    public Literal makeZero(Type type) {
        return makeValue(BigInteger.ZERO, type);
    }

    public Literal makeOne(Type type) {
        return makeValue(BigInteger.ONE, type);
    }

    public Literal parseValue(String text, Type type) {
        return makeValue(new BigInteger(text), type);
    }

    public Literal makeValue(BigInteger value, Type type) {
        return new Literal(value, type);
    }

    public Expression makeNot(Expression inner) {
        if (!inner.isBoolean()) {
            logger.warn("Non-boolean operand for (not {}).", inner);
        }
        if (inner instanceof Literal) {
            return makeValue(inner.isFalse());
        }
        if (inner instanceof UnaryBooleanExpression) {
            assert ((UnaryBooleanExpression) inner).getOp().equals(BOpUn.NOT);
            return ((UnaryBooleanExpression) inner).getInner();
        }
        return new UnaryBooleanExpression(types.getBooleanType(), BOpUn.NOT, inner);
    }

    public Expression makeUnary(BOpUn operator, Expression inner) {
        assert operator.equals(BOpUn.NOT);
        return makeNot(inner);
    }

    public Expression makeNegative(Expression inner) {
        return makeUnary(inner.getType(), IOpUn.MINUS, inner);
    }

    public Expression makeCountLeadingZeroes(Expression inner) {
        return makeUnary(inner.getType(), IOpUn.CTLZ, inner);
    }

    public Expression makeSignedCast(Type target, Expression inner) {
        return makeUnary(target, IOpUn.SIGNED_CAST, inner);
    }

    public Expression makeUnsignedCast(Type target, Expression inner) {
        return makeUnary(target, IOpUn.UNSIGNED_CAST, inner);
    }

    public Expression makeCast(Type target, Expression inner) {
        // Should only be used for isomorphisms and truncation.
        return makeSignedCast(target, inner);
    }

    public Expression makeUnary(Type targetType, IOpUn operator, Expression inner) {
        Type innerType = inner.getType();
        if (inner instanceof Literal) {
            BigInteger value = ((Literal) inner).getValue();
            BigInteger v;
            switch (operator) {
                case MINUS -> v = value.negate();
                case SIGNED_CAST, UNSIGNED_CAST -> {
                    boolean truncate = innerType instanceof UnboundedIntegerType ||
                            innerType instanceof BoundedIntegerType &&
                                    targetType instanceof BoundedIntegerType &&
                                    ((BoundedIntegerType) targetType).getBitWidth() < ((BoundedIntegerType) innerType).getBitWidth();
                    if (truncate) {
                        v = value;
                        for (int i = ((BoundedIntegerType) targetType).getBitWidth(); i < value.bitLength(); i++) {
                            v = v.clearBit(i);
                        }
                    } else {
                        checkArgument(inner.getType() instanceof BoundedIntegerType, "Type mismatch for %s %s.", operator, inner);
                        int bitWidth = ((BoundedIntegerType) inner.getType()).getBitWidth();
                        assert BigInteger.TWO.pow(bitWidth - 1).negate().compareTo(value) <= 0;
                        assert BigInteger.TWO.pow(bitWidth).compareTo(value) > 0;
                        if (operator.equals(IOpUn.SIGNED_CAST)) {
                            v = value.testBit(bitWidth - 1) ? value.subtract(BigInteger.TWO.pow(bitWidth)) : value;
                        } else {
                            v = value.signum() >= 0 ? value : BigInteger.TWO.pow(bitWidth).add(value);
                        }
                    }
                }
                case CTLZ -> {
                    checkArgument(targetType instanceof BoundedIntegerType, "Type mismatch for %s %s.", operator, inner);
                    int leadingZeroes = ((BoundedIntegerType) targetType).getBitWidth() - value.bitLength();
                    checkArgument(leadingZeroes >= 0, "Range miss in %s %s.", operator, inner);
                    v = BigInteger.valueOf(leadingZeroes);
                }
                default -> throw new UnsupportedOperationException(String.format("Reduce not supported for (%s) %s %s.", targetType, operator, inner));
            }
            return makeValue(v, targetType);
        }
        if (inner instanceof UnaryIntegerExpression && operator.equals(IOpUn.MINUS) && ((UnaryIntegerExpression) inner).getOp().equals(IOpUn.MINUS)) {
            return ((UnaryIntegerExpression) inner).getInner();
        }
        //TODO expansion followed by truncation
        return new UnaryIntegerExpression(targetType, operator, inner);
    }

    public Expression makeAnd(Expression left, Expression right) {
        return makeBinary(left, BOpBin.AND, right);
    }

    public Expression makeOr(Expression left, Expression right) {
        return makeBinary(left, BOpBin.OR, right);
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
        return new BinaryBooleanExpression(types.getBooleanType(), left, operator, right);
    }

    public Expression makeBinary(Expression left, COpBin comparator, Expression right) {
        checkTypes(left, comparator, right);
        checkArgument(!left.isBoolean() || comparator.equals(COpBin.EQ) || comparator.equals(COpBin.NEQ),
                "Incompatible types for %s %s %s.", left, comparator, right);
        if (left instanceof Literal leftLiteral && right instanceof Literal rightLiteral) {
            int value = leftLiteral.getValue().compareTo(rightLiteral.getValue());
            boolean result = switch (comparator) {
                case EQ -> value == 0;
                case NEQ -> value != 0;
                case LT, ULT -> value < 0;
                case LTE, ULTE -> value <= 0;
                case GT, UGT -> value > 0;
                case GTE, UGTE -> value >= 0;
            };
            return makeValue(result);
        }
        if (left.equals(right) && left.getRegs().isEmpty()) {
            switch (comparator) {
                case EQ: case LTE: case ULTE: case GTE: case UGTE:
                    return makeTrue();
            }
            return makeFalse();
        }
        if (left.isTrue() || left.isFalse()) {
            return comparator.equals(COpBin.EQ) == left.isTrue() ? right : makeNot(right);
        }
        if (right.isTrue() || right.isFalse()) {
            return comparator.equals(COpBin.EQ) == right.isTrue() ? left : makeNot(left);
        }
        return new Comparison(types.getBooleanType(), left, comparator, right);
    }

    public Expression makeBinary(Expression left, IOpBin operator, Expression right) {
        if (left.getType() instanceof PointerType) {
            boolean rightIsPointer = right.getType() instanceof PointerType;
            Type type;
            if (operator.equals(IOpBin.PLUS)) {
                if (rightIsPointer) {
                    logger.warn("Pointer addition is not allowed in {} + {}.", left, right);
                }
                type = left.getType();
            } else if (operator.equals(IOpBin.MINUS)) {
                int precision = getArchPrecision();
                type = rightIsPointer ? precision < 0 ? types.getIntegerType() : types.getIntegerType(precision) : left.getType();
            } else {
                logger.warn("Unsupported expression {} {} {}", left, operator, right);
                type = left.getType();
            }
            return new BinaryIntegerExpression(type, left, operator, right);
        }
        checkTypes(left, operator, right);
        if (left instanceof Literal && right instanceof Literal) {
            BigInteger result = operator.combine(((Literal) left).getValue(), ((Literal) right).getValue());
            return makeValue(result, left.getType());
        }
        switch (operator) {
            case PLUS:
                if (left instanceof Literal && ((Literal) left).getValue().equals(BigInteger.ZERO)) {
                    return right;
                }
                if (right instanceof Literal && ((Literal) right).getValue().equals(BigInteger.ZERO)) {
                    return left;
                }
                break;
            case MULT:
                if (left instanceof Literal && ((Literal) left).getValue().equals(BigInteger.ZERO)) {
                    return left;
                }
                if (right instanceof Literal && ((Literal) right).getValue().equals(BigInteger.ZERO)) {
                    return right;
                }
                if (left instanceof Literal && ((Literal) left).getValue().equals(BigInteger.ONE)) {
                    return right;
                }
                if (right instanceof Literal && ((Literal) right).getValue().equals(BigInteger.ONE)) {
                    return left;
                }
                break;
            case XOR:
                if (right instanceof Literal && ((Literal) right).getValue().equals(BigInteger.ZERO)) {
                    return left;
                }
                //TODO replace with complement if applicable
        }
        return new BinaryIntegerExpression(left.getType(), left, operator, right);
    }

    public Expression makeConditional(Expression condition, Expression ifTrue, Expression ifFalse) {
        if (!condition.isBoolean()) {
            logger.warn("Non-boolean guard for {} ? {} : {}.", condition, ifTrue, ifFalse);
        }
        if (ifTrue.equals(ifFalse) && condition.getRegs().isEmpty() ||
                condition.isFalse() && ifFalse.getRegs().containsAll(ifTrue.getRegs())) {
            return ifFalse;
        }
        if (condition.isTrue() && ifTrue.getRegs().containsAll(ifFalse.getRegs())) {
            return ifTrue;
        }
        return new ConditionalExpression(condition, ifTrue, ifFalse);
    }

    private void checkTypes(Expression left, Object operator, Expression right) {
        checkArgument(left.getType().equals(right.getType()),
                "Type mismatch: %s %s %s.", left, operator, right);
    }
}
