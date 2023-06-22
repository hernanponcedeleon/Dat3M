package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.expression.type.*;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkArgument;

public final class ExpressionFactory {

    private static final ExpressionFactory instance = new ExpressionFactory();

    private final TypeFactory types = TypeFactory.getInstance();
    private final BooleanType booleanType = types.getBooleanType();
    private final BConst falseConstant = new BConst(booleanType, false);
    private final BConst trueConstant = new BConst(booleanType, true);

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Boolean

    public BConst makeTrue() {
        return trueConstant;
    }

    public BConst makeFalse() {
        return falseConstant;
    }

    public BConst makeValue(boolean value) {
        return value ? makeTrue() : makeFalse();
    }

    public Expression makeNot(Expression operand) {
        return makeUnary(BOpUn.NOT, operand);
    }

    public Expression makeUnary(BOpUn operator, Expression operand) {
        return new BExprUn(types.getBooleanType(), operator, operand);
    }

    public Expression makeAnd(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BOpBin.AND, rightOperand);
    }

    public Expression makeOr(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BOpBin.OR, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, BOpBin operator, Expression rightOperand) {
        return new BExprBin(booleanType, leftOperand, operator, rightOperand);
    }

    public IValue makeZero(IntegerType type) {
        return makeValue(BigInteger.ZERO, type);
    }

    @Deprecated
    public IValue makeZero(Type type) {
        if (type instanceof IntegerType t) {
            return makeZero(t);
        }
        throw new IllegalArgumentException("Non-integer type " + type);
    }

    public IValue makeOne(IntegerType type) {
        return makeValue(BigInteger.ONE, type);
    }

    @Deprecated
    public IValue makeOne(Type type) {
        if (type instanceof IntegerType t) {
            return makeOne(t);
        }
        throw new IllegalArgumentException("Non-integer type " + type);
    }

    public IValue parseValue(String text, IntegerType type) {
        return makeValue(new BigInteger(text), type);
    }

    @Deprecated
    public IValue parseValue(String text, Type type) {
        if (type instanceof IntegerType t) {
            return parseValue(text, t);
        }
        throw new IllegalArgumentException("Non-integer type " + type);
    }

    public IValue makeValue(BigInteger value, IntegerType type) {
        return new IValue(value, type);
    }

    @Deprecated
    public IValue makeValue(BigInteger value, Type type) {
        if (type instanceof IntegerType t) {
            return makeValue(value, t);
        }
        throw new IllegalArgumentException("Non-integer type " + type);
    }

    public Expression makeCast(Expression expression, Type type) {
        if (type instanceof BooleanType) {
            return makeBooleanCast(expression);
        }
        if (type instanceof IntegerType integerType) {
            return makeIntegerCast(expression, integerType, false);
        }
        throw new UnsupportedOperationException(String.format("Cast %s into %s.", expression, type));
    }

    public Expression makeConditional(Expression condition, Expression ifTrue, Expression ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    public Expression makeBooleanCast(Expression operand) {
        if (operand.getType() instanceof BooleanType) {
            return operand;
        }
        if (operand.getType() instanceof IntegerType integerType) {
            return makeNEQ(operand, makeZero(integerType));
        }
        throw new UnsupportedOperationException(String.format("makeBoolean with unknown-typed operand %s.", operand));
    }

    public Expression makeEQ(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, COpBin.EQ, rightOperand);
    }

    public Expression makeNEQ(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, COpBin.NEQ, rightOperand);
    }

    public Expression makeLT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LT : COpBin.ULT, rightOperand);
    }

    public Expression makeGT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.GT : COpBin.UGT, rightOperand);
    }

    public Expression makeLTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LTE : COpBin.ULTE, rightOperand);
    }

    public Expression makeGTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.GTE : COpBin.UGTE, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, COpBin operator, Expression rightOperand) {
        return new Atom(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeNEG(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.MINUS, operand, targetType);
    }

    public Expression makeCTLZ(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.CTLZ, operand, targetType);
    }

    public Expression makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        if (operand.getType() instanceof BooleanType) {
            return makeConditional(operand, makeOne(targetType), makeZero(targetType));
        }
        return makeUnary(signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED, operand, targetType);
    }

    public Expression makeUnary(IOpUn operator, Expression operand, IntegerType targetType) {
        checkArgument(operand.getType() instanceof IntegerType,
                String.format("Non-integer operand for %s %s.", operator, operand));
        return new IExprUn(operator, operand, targetType);
    }

    public Expression makeADD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.PLUS, rightOperand);
    }

    public Expression makeSUB(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MINUS, rightOperand);
    }

    public Expression makeMUL(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MULT, rightOperand);
    }

    public Expression makeDIV(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.DIV : IOpBin.UDIV, rightOperand);
    }

    public Expression makeMOD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MOD, rightOperand);
    }

    public Expression makeREM(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.SREM : IOpBin.UREM, rightOperand);
    }

    public Expression makeAND(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.AND, rightOperand);
    }

    public Expression makeOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.OR, rightOperand);
    }

    public Expression makeXOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.XOR, rightOperand);
    }

    public Expression makeLSH(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.L_SHIFT, rightOperand);
    }

    public Expression makeRSH(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.AR_SHIFT : IOpBin.R_SHIFT, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, IOpBin operator, Expression rightOperand) {
        if (!(leftOperand.getType() instanceof IntegerType type)) {
            throw new IllegalArgumentException(
                    String.format("Non-integer left operand %s %s %s.", leftOperand, operator, rightOperand));
        }
        return new IExprBin(type, leftOperand, operator, rightOperand);
    }
}
