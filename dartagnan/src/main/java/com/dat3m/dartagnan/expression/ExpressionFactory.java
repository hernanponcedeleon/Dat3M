package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.expression.type.*;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.List;

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
        Type operandType = operand.getType();
        if (operandType instanceof BooleanType) {
            return operand;
        }
        Preconditions.checkArgument(operandType instanceof IntegerType,
                "makeBoolean with unknown-typed operand %s.", operand);
        return makeNEQ(operand, makeZero((IntegerType) operandType));
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
        Preconditions.checkArgument(operand.getType() instanceof IntegerType,
                "Non-integer operand for %s %s.", operator, operand);
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
        Preconditions.checkState(leftOperand.getType() instanceof IntegerType,
                "Non-integer left operand %s %s %s.", leftOperand, operator, rightOperand);
        return new IExprBin((IntegerType) leftOperand.getType(), leftOperand, operator, rightOperand);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Aggregates

    public Expression makeConstruct(List<Expression> arguments) {
        return new Construction(types, arguments);
    }

    public Expression makeExtract(int fieldIndex, Expression object) {
        return new Extraction(fieldIndex, object);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Pointers

    public Expression makeGetElementPointer(Type indexingType, Expression base, List<Expression> offsets) {
        //TODO getPointerType()
        Preconditions.checkArgument(base.getType().equals(types.getArchType()),
                "Applying offsets to non-pointer expression.");
        return new GEPExpression(types.getArchType(), indexingType, base, offsets);
    }
}
