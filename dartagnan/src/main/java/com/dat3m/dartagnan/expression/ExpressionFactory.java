package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.expression.type.*;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public final class ExpressionFactory {

    private static final ExpressionFactory instance = new ExpressionFactory();

    private final TypeFactory types = TypeFactory.getInstance();
    private final BooleanType booleanType = types.getBooleanType();
    private final BoolLiteral falseConstant = new BoolLiteral(booleanType, false);
    private final BoolLiteral trueConstant = new BoolLiteral(booleanType, true);

    private ExpressionFactory() {}

    public static ExpressionFactory getInstance() {
        return instance;
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Boolean

    public BoolLiteral makeTrue() {
        return trueConstant;
    }

    public BoolLiteral makeFalse() {
        return falseConstant;
    }

    public BoolLiteral makeValue(boolean value) {
        return value ? makeTrue() : makeFalse();
    }

    public Expression makeNot(Expression operand) {
        return makeUnary(BoolUnaryOp.NOT, operand);
    }

    public Expression makeUnary(BoolUnaryOp operator, Expression operand) {
        return new BoolUnaryExpr(types.getBooleanType(), operator, operand);
    }

    public Expression makeAnd(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BoolBinaryOp.AND, rightOperand);
    }

    public Expression makeOr(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BoolBinaryOp.OR, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, BoolBinaryOp operator, Expression rightOperand) {
        return new BoolBinaryExpr(booleanType, leftOperand, operator, rightOperand);
    }

    public Expression makeGeneralZero(Type type) {
        if (type instanceof ArrayType arrayType) {
            Expression zero = makeGeneralZero(arrayType.getElementType());
            List<Expression> zeroes = new ArrayList<>(arrayType.getNumElements());
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                zeroes.add(zero);
            }
            return makeArray(arrayType.getElementType(), zeroes, true);
        } else if (type instanceof AggregateType structType) {
            List<Expression> zeroes = new ArrayList<>(structType.getDirectFields().size());
            for (Type fieldType : structType.getDirectFields()) {
                zeroes.add(makeGeneralZero(fieldType));
            }
            return makeConstruct(zeroes);
        } else if (type instanceof IntegerType intType) {
            return makeZero(intType);
        } else if (type == booleanType) {
            return makeFalse();
        } else {
            throw new UnsupportedOperationException("Cannot create zero of type " + type);
        }
    }

    public IntLiteral makeZero(IntegerType type) {
        return makeValue(BigInteger.ZERO, type);
    }

    public IntLiteral makeOne(IntegerType type) {
        return makeValue(BigInteger.ONE, type);
    }

    public IntLiteral parseValue(String text, IntegerType type) {
        return makeValue(new BigInteger(text), type);
    }

    public IntLiteral makeValue(long value, IntegerType type) {
        return makeValue(BigInteger.valueOf(value), type);
    }

    public IntLiteral makeValue(BigInteger value, IntegerType type) {
        return new IntLiteral(value, type);
    }

    public Expression makeCast(Expression expression, Type type, boolean signed) {
        if (type instanceof BooleanType) {
            return makeBooleanCast(expression);
        }
        if (type instanceof IntegerType integerType) {
            return makeIntegerCast(expression, integerType, signed);
        }
        throw new UnsupportedOperationException(String.format("Cast %s into %s.", expression, type));
    }

    public Expression makeCast(Expression expression, Type type) {
        return makeCast(expression, type, false);
    }

    public Expression makeITE(Expression condition, Expression ifTrue, Expression ifFalse) {
        return new ITEExpr(condition, ifTrue, ifFalse);
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
        return makeBinary(leftOperand, CmpOp.EQ, rightOperand);
    }

    public Expression makeNEQ(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, CmpOp.NEQ, rightOperand);
    }

    public Expression makeLT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? CmpOp.LT : CmpOp.ULT, rightOperand);
    }

    public Expression makeGT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? CmpOp.GT : CmpOp.UGT, rightOperand);
    }

    public Expression makeLTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? CmpOp.LTE : CmpOp.ULTE, rightOperand);
    }

    public Expression makeGTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? CmpOp.GTE : CmpOp.UGTE, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, CmpOp operator, Expression rightOperand) {
        return new Atom(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeNEG(Expression operand, IntegerType targetType) {
        return makeUnary(IntUnaryOp.MINUS, operand, targetType);
    }

    public Expression makeCTLZ(Expression operand, IntegerType targetType) {
        return makeUnary(IntUnaryOp.CTLZ, operand, targetType);
    }

    public Expression makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        if (operand.getType() instanceof BooleanType) {
            return makeITE(operand, makeOne(targetType), makeZero(targetType));
        }
        return makeUnary(signed ? IntUnaryOp.CAST_SIGNED : IntUnaryOp.CAST_UNSIGNED, operand, targetType);
    }

    public Expression makeUnary(IntUnaryOp operator, Expression operand, IntegerType targetType) {
        Preconditions.checkArgument(operand.getType() instanceof IntegerType,
                "Non-integer operand for %s %s.", operator, operand);
        return new IntUnaryExpr(operator, operand, targetType);
    }

    public Expression makeADD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.ADD, rightOperand);
    }

    public Expression makeSUB(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.SUB, rightOperand);
    }

    public Expression makeMUL(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.MUL, rightOperand);
    }

    public Expression makeDIV(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntBinaryOp.DIV : IntBinaryOp.UDIV, rightOperand);
    }

    public Expression makeMOD(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.MOD, rightOperand);
    }

    public Expression makeREM(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntBinaryOp.SREM : IntBinaryOp.UREM, rightOperand);
    }

    public Expression makeAND(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.AND, rightOperand);
    }

    public Expression makeOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.OR, rightOperand);
    }

    public Expression makeXOR(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.XOR, rightOperand);
    }

    public Expression makeLSH(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, IntBinaryOp.LSHIFT, rightOperand);
    }

    public Expression makeRSH(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntBinaryOp.ARSHIFT : IntBinaryOp.RSHIFT, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, IntBinaryOp operator, Expression rightOperand) {
        Preconditions.checkState(leftOperand.getType() instanceof IntegerType,
                "Non-integer left operand %s %s %s.", leftOperand, operator, rightOperand);
        return new IntBinaryExpr((IntegerType) leftOperand.getType(), leftOperand, operator, rightOperand);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Aggregates

    public Expression makeConstruct(List<Expression> arguments) {
        final AggregateType type = types.getAggregateType(arguments.stream().map(Expression::getType).toList());
        return new Construction(type, arguments);
    }

    public Expression makeArray(Type elementType, List<Expression> items, boolean fixedSize) {
        final ArrayType type = fixedSize ? types.getArrayType(elementType, items.size()) :
                types.getArrayType(elementType);
        return new Construction(type, items);
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
