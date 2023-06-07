package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.expression.type.*;

import java.math.BigInteger;

public final class ExpressionFactory {

    private static final ExpressionFactory instance = new ExpressionFactory();

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Boolean

    public BConst makeTrue() {
        return BConst.TRUE;
    }

    public BConst makeFalse() {
        return BConst.FALSE;
    }

    public BConst makeValue(boolean value) {
        return value ? makeTrue() : makeFalse();
    }

    public BExpr makeNot(Expression operand) {
        return makeUnary(BOpUn.NOT, operand);
    }

    public BExpr makeUnary(BOpUn operator, Expression operand) {
        return new BExprUn(operator, operand);
    }

    public BExpr makeAnd(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BOpBin.AND, rightOperand);
    }

    public BExpr makeOr(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BOpBin.OR, rightOperand);
    }

    public BExpr makeBinary(Expression leftOperand, BOpBin operator, Expression rightOperand) {
        return new BExprBin(leftOperand, operator, rightOperand);
    }

    public IValue makeZero(IntegerType type) {
        return makeValue(BigInteger.ZERO, type);
    }

    public IValue makeOne(IntegerType type) {
        return makeValue(BigInteger.ONE, type);
    }

    public IValue parseValue(String text, IntegerType type) {
        return makeValue(new BigInteger(text), type);
    }

    public IValue makeValue(BigInteger value, IntegerType type) {
        return new IValue(value, type);
    }

    public IExpr makeInteger(IntegerType targetType, Expression operand) {
        Type operandType = operand.getType();
        if (operandType instanceof BooleanType) {
            return makeConditional(operand, makeOne(targetType), makeZero(targetType));
        }
        throw new UnsupportedOperationException(String.format("makeInteger with unknown-typed operand %s.", operand));
    }

    public IExpr makeConditional(Expression condition, Expression ifTrue, Expression ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    public BExpr makeBoolean(Expression operand) {
        if (operand.getType() instanceof BooleanType) {
            assert operand instanceof BExpr;
            return (BExpr) operand;
        }
        if (operand.getType() instanceof IntegerType integerType) {
            return makeNotEqual(operand, makeZero(integerType));
        }
        throw new UnsupportedOperationException(String.format("makeBoolean with unknown-typed operand %s.", operand));
    }

    public BExpr makeEqual(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, COpBin.EQ, rightOperand);
    }

    public BExpr makeNotEqual(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, COpBin.NEQ, rightOperand);
    }

    public BExpr makeLess(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LT : COpBin.ULT, rightOperand);
    }

    public BExpr makeGreater(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.GT : COpBin.UGT, rightOperand);
    }

    public BExpr makeLessOrEqual(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LTE : COpBin.ULTE, rightOperand);
    }

    public BExpr makeGreaterOrEqual(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LTE : COpBin.ULTE, rightOperand);
    }

    public BExpr makeBinary(Expression leftOperand, COpBin operator, Expression rightOperand) {
        return new Atom(leftOperand, operator, rightOperand);
    }

    public IExpr makeNegate(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.MINUS, operand, targetType);
    }

    public IExpr makeCountLeadingZeroes(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.CTLZ, operand, targetType);
    }

    public IExpr makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        return makeUnary(signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED, operand, targetType);
    }

    public IExpr makeUnary(IOpUn operator, Expression operand, IntegerType targetType) {
        return new IExprUn(operator, (IExpr) operand, targetType);
    }

    public IExpr makePlus(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.PLUS, rightOperand);
    }

    public IExpr makeMinus(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MINUS, rightOperand);
    }

    public IExpr makeMultiply(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MULT, rightOperand);
    }

    public IExpr makeDivision(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.DIV : IOpBin.UDIV, rightOperand);
    }

    public IExpr makeModulo(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MOD, rightOperand);
    }

    public IExpr makeRemainder(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.SREM : IOpBin.UREM, rightOperand);
    }

    public IExpr makeBitwiseAnd(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.AND, rightOperand);
    }

    public IExpr makeBitwiseOr(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.OR, rightOperand);
    }

    public IExpr makeXor(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.XOR, rightOperand);
    }

    public IExpr makeLeftShift(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.L_SHIFT, rightOperand);
    }

    public IExpr makeRightShift(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.AR_SHIFT : IOpBin.R_SHIFT, rightOperand);
    }

    public IExpr makeBinary(Expression leftOperand, IOpBin operator, Expression rightOperand) {
        return new IExprBin((IExpr) leftOperand, operator, (IExpr) rightOperand);
    }
}
