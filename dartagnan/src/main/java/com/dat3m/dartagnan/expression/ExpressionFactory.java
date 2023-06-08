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

    public IValue makeOne(IntegerType type) {
        return makeValue(BigInteger.ONE, type);
    }

    public IValue parseValue(String text, IntegerType type) {
        return makeValue(new BigInteger(text), type);
    }

    public IValue makeValue(BigInteger value, IntegerType type) {
        return new IValue(value, type);
    }

    public IExpr makeConditional(Expression condition, Expression ifTrue, Expression ifFalse) {
        return new IfExpr(condition, ifTrue, ifFalse);
    }

    public Expression makeBoolean(Expression operand) {
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

    public IExpr makeNEG(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.MINUS, operand, targetType);
    }

    public IExpr makeCTLZ(Expression operand, IntegerType targetType) {
        return makeUnary(IOpUn.CTLZ, operand, targetType);
    }

    public IExpr makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        if (operand.getType() instanceof BooleanType) {
            return makeConditional(operand, makeOne(targetType), makeZero(targetType));
        }
        return makeUnary(signed ? IOpUn.CAST_SIGNED : IOpUn.CAST_UNSIGNED, operand, targetType);
    }

    public IExpr makeUnary(IOpUn operator, Expression operand, IntegerType targetType) {
        checkArgument(operand instanceof IExpr, String.format("Non-integer operand for %s %s.", operator, operand));
        return new IExprUn(operator, (IExpr) operand, targetType);
    }

    public IExpr makeADD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.PLUS, rightOperand);
    }

    public IExpr makeSUB(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MINUS, rightOperand);
    }

    public IExpr makeMUL(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MULT, rightOperand);
    }

    public IExpr makeDIV(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.DIV : IOpBin.UDIV, rightOperand);
    }

    public IExpr makeMOD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.MOD, rightOperand);
    }

    public IExpr makeREM(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.SREM : IOpBin.UREM, rightOperand);
    }

    public IExpr makeAND(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.AND, rightOperand);
    }

    public IExpr makeOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.OR, rightOperand);
    }

    public IExpr makeXOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.XOR, rightOperand);
    }

    public IExpr makeLSH(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IOpBin.L_SHIFT, rightOperand);
    }

    public IExpr makeRSH(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IOpBin.AR_SHIFT : IOpBin.R_SHIFT, rightOperand);
    }

    public IExpr makeBinary(Expression leftOperand, IOpBin operator, Expression rightOperand) {
        checkArgument(leftOperand instanceof IExpr && rightOperand instanceof IExpr,
                String.format("Non-integer operands for %s %s %s.", leftOperand, operator, rightOperand));
        return new IExprBin((IExpr) leftOperand, operator, (IExpr) rightOperand);
    }
}
