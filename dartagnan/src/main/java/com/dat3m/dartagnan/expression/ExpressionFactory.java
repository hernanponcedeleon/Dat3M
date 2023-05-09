package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;

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
        return value ? BConst.TRUE : BConst.FALSE;
    }

    public BExpr makeNot(ExprInterface operand) {
        return makeUnary(BOpUn.NOT, operand);
    }

    public BExpr makeUnary(BOpUn operator, ExprInterface operand) {
        return new BExprUn(operator, operand);
    }

    public BExpr makeAnd(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, BOpBin.AND, rightOperand);
    }

    public BExpr makeOr(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, BOpBin.OR, rightOperand);
    }

    public BExpr makeBinary(ExprInterface leftOperand, BOpBin operator, ExprInterface rightOperand) {
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

    public IExpr makeInteger(IntegerType targetType, ExprInterface operand) {
        if (operand.isBoolean()) {
            return makeConditional(operand, makeOne(targetType), makeZero(targetType));
        }
        throw new UnsupportedOperationException(String.format("makeInteger with unknown-typed operand %s.", operand));
    }

    public IExpr makeConditional(ExprInterface condition, ExprInterface ifTrue, ExprInterface ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    public BExpr makeBoolean(ExprInterface operand) {
        if (operand.getType() instanceof BooleanType) {
            assert operand instanceof BExpr;
            return (BExpr) operand;
        }
        if (operand.getType() instanceof IntegerType integerType) {
            return makeNotEqual(operand, makeZero(integerType));
        }
        throw new UnsupportedOperationException(String.format("makeBoolean with unknown-typed operand %s.", operand));
    }

    public BExpr makeEqual(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, COpBin.EQ, rightOperand);
    }

    public BExpr makeNotEqual(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, COpBin.NEQ, rightOperand);
    }

    public BExpr makeLess(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LT : COpBin.ULT, rightOperand);
    }

    public BExpr makeGreater(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.GT : COpBin.UGT, rightOperand);
    }

    public BExpr makeLessOrEqual(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LTE : COpBin.ULTE, rightOperand);
    }

    public BExpr makeGreaterOrEqual(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? COpBin.LTE : COpBin.ULTE, rightOperand);
    }

    public BExpr makeBinary(ExprInterface leftOperand, COpBin operator, ExprInterface rightOperand) {
        return new Atom(leftOperand, operator, rightOperand);
    }

    public IExpr makeNegate(ExprInterface operand, IntegerType targetType) {
        return makeUnary(IOpUn.MINUS, operand, targetType);
    }

    public IExpr makeCountLeadingZeroes(ExprInterface operand, IntegerType targetType) {
        return makeUnary(IOpUn.CTLZ, operand, targetType);
    }

    public IExpr makeIntegerCast(ExprInterface operand, IntegerType targetType, boolean signed) {
        return makeUnary(signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED, operand, targetType);
    }

    public IExpr makeUnary(IOpUn operator, ExprInterface operand, IntegerType targetType) {
        return new IExprUn(operator, (IExpr) operand, targetType);
    }

    public IExpr makePlus(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.PLUS, rightOperand);
    }

    public IExpr makeMinus(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.MINUS, rightOperand);
    }

    public IExpr makeMultiply(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.MULT, rightOperand);
    }

    public IExpr makeDivision(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.DIV : IOpBin.UDIV, rightOperand);
    }

    public IExpr makeModulo(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.MOD, rightOperand);
    }

    public IExpr makeRemainder(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.SREM : IOpBin.UREM, rightOperand);
    }

    public IExpr makeBitwiseAnd(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.AND, rightOperand);
    }

    public IExpr makeBitwiseOr(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.OR, rightOperand);
    }

    public IExpr makeLeftShift(ExprInterface leftOperand, ExprInterface rightOperand) {
        return makeBinary(leftOperand, IOpBin.L_SHIFT, rightOperand);
    }

    public IExpr makeRightShift(ExprInterface leftOperand, ExprInterface rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.AR_SHIFT : IOpBin.R_SHIFT, rightOperand);
    }

    public IExpr makeBinary(ExprInterface leftOperand, IOpBin operator, ExprInterface rightOperand) {
        return new IExprBin((IExpr) leftOperand, operator, (IExpr) rightOperand);
    }
}
