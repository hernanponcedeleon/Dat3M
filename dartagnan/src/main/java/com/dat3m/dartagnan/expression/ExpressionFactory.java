package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.booleans.*;
import com.dat3m.dartagnan.expression.floats.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.ExtractExpr;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.google.common.base.Preconditions;

import java.math.BigDecimal;
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
        return new BoolUnaryExpr(operator, operand);
    }

    public Expression makeAnd(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BoolBinaryOp.AND, rightOperand);
    }

    public Expression makeOr(Expression leftOperand, Expression rightOperand) {
        return makeBinary(leftOperand, BoolBinaryOp.OR, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, BoolBinaryOp operator, Expression rightOperand) {
        return new BoolBinaryExpr(leftOperand, operator, rightOperand);
    }

    public Expression makeBooleanCast(Expression operand) {
        final Type sourceType = operand.getType();
        if (sourceType instanceof BooleanType) {
            return operand;
        } else if (sourceType instanceof IntegerType intType) {
            makeNEQ(operand, makeZero(intType));
        }
        throw new UnsupportedOperationException(String.format("Cannot cast %s to %s.", sourceType, booleanType));
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Integers

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
        return new IntLiteral(type, value);
    }

    public Expression makeLT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntCmpOp.LT : IntCmpOp.ULT, rightOperand);
    }

    public Expression makeGT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntCmpOp.GT : IntCmpOp.UGT, rightOperand);
    }

    public Expression makeLTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntCmpOp.LTE : IntCmpOp.ULTE, rightOperand);
    }

    public Expression makeGTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeBinary(leftOperand, signed ? IntCmpOp.GTE : IntCmpOp.UGTE, rightOperand);
    }

    public Expression makeBinary(Expression leftOperand, IntCmpOp operator, Expression rightOperand) {
        return new IntCmpExpr(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeNEG(Expression operand) {
        return makeUnary(IntUnaryOp.MINUS, operand);
    }

    public Expression makeCTLZ(Expression operand) {
        return makeUnary(IntUnaryOp.CTLZ, operand);
    }

    public Expression makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        final Type sourceType = operand.getType();

        if (sourceType instanceof BooleanType) {
            return makeITE(operand, makeOne(targetType), makeZero(targetType));
        } else if (sourceType instanceof IntegerType) {
            return sourceType.equals(targetType) ? operand : new IntSizeCast(targetType, operand, signed);
        }

        throw new UnsupportedOperationException(String.format("Cannot cast %s to %s.", sourceType, targetType));
    }

    public Expression makeUnary(IntUnaryOp operator, Expression operand) {
        Preconditions.checkArgument(operand.getType() instanceof IntegerType,
                "Non-integer operand for %s %s.", operator, operand);
        return new IntUnaryExpr(operator, operand);
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
        return new IntBinaryExpr(leftOperand, operator, rightOperand);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Floats

    public FloatLiteral makeValue(BigDecimal value, FloatType type) {
        return new FloatLiteral(type, value, false, false);
    }

    public Expression makeFADD(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FADD, y);
    }

    public Expression makeFSUB(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FSUB, y);
    }

    public Expression makeFMUL(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FMUL, y);
    }

    public Expression makeFDIV(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FDIV, y);
    }

    public Expression makeFREM(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FREM, y);
    }

    public Expression makeFloatBinary(Expression x, FloatBinaryOp op, Expression y) {
        return new FloatBinaryExpr(x, op, y);
    }

    public Expression makeFNEG(Expression expr) {
        return new FloatUnaryExpr(FloatUnaryOp.NEG, expr);
    }

    public Expression makeFloatUnary(FloatUnaryOp op, Expression expr) {
        return new FloatUnaryExpr(op, expr);
    }

    public Expression makeFloatCmp(Expression x, FloatCmpOp op, Expression y) {
        return new FloatCmpExpr(booleanType, x, op, y);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Aggregates

    public Expression makeConstruct(List<Expression> arguments) {
        final AggregateType type = types.getAggregateType(arguments.stream().map(Expression::getType).toList());
        return new ConstructExpr(type, arguments);
    }

    public Expression makeArray(Type elementType, List<Expression> items, boolean fixedSize) {
        final ArrayType type = fixedSize ? types.getArrayType(elementType, items.size()) :
                types.getArrayType(elementType);
        return new ConstructExpr(type, items);
    }

    public Expression makeExtract(int fieldIndex, Expression object) {
        return new ExtractExpr(fieldIndex, object);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Pointers

    public Expression makeGetElementPointer(Type indexingType, Expression base, List<Expression> offsets) {
        //TODO getPointerType()
        Preconditions.checkArgument(base.getType().equals(types.getArchType()),
                "Applying offsets to non-pointer expression.");
        return new GEPExpr(indexingType, base, offsets);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Misc
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
        } else if (type instanceof BooleanType) {
            return makeFalse();
        } else if (type instanceof FloatType floatType) {
            return makeValue(BigDecimal.ZERO, floatType);
        } else {
            throw new UnsupportedOperationException("Cannot create zero of type " + type);
        }
    }

    public Expression makeCast(Expression expression, Type type, boolean signed) {
        if (type instanceof BooleanType) {
            return makeBooleanCast(expression);
        } else if (type instanceof IntegerType integerType) {
            return makeIntegerCast(expression, integerType, signed);
        }
        throw new UnsupportedOperationException(String.format("Cast %s into %s unsupported.", expression, type));
    }

    public Expression makeCast(Expression expression, Type type) {
        return makeCast(expression, type, false);
    }

    public Expression makeITE(Expression condition, Expression ifTrue, Expression ifFalse) {
        return new ITEExpr(condition, ifTrue, ifFalse);
    }

    public Expression makeEQ(Expression leftOperand, Expression rightOperand) {
        final Type type = leftOperand.getType();
        if (type instanceof BooleanType) {
            return makeBinary(leftOperand, BoolBinaryOp.IFF, rightOperand);
        } else if (type instanceof IntegerType) {
            return makeBinary(leftOperand, IntCmpOp.EQ, rightOperand);
        } else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.OEQ, rightOperand);
        }
        throw new UnsupportedOperationException("Equality not supported on type: " + type);
    }

    public Expression makeNEQ(Expression leftOperand, Expression rightOperand) {
        final Type type = leftOperand.getType();
        if (type instanceof BooleanType) {
            return makeNot(makeBinary(leftOperand, BoolBinaryOp.IFF, rightOperand));
        } else if (type instanceof IntegerType) {
            return makeBinary(leftOperand, IntCmpOp.NEQ, rightOperand);
        } else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.ONEQ, rightOperand);
        }
        throw new UnsupportedOperationException("Disequality not supported on type: " + type);
    }

    public Expression makeUnary(ExpressionKind op, Expression expr) {
        if (op instanceof BoolUnaryOp boolOp) {
            return makeUnary(boolOp, expr);
        } else if (op instanceof IntUnaryOp intOp) {
            return makeUnary(intOp, expr);
        } else if (op instanceof FloatUnaryOp floatOp) {
            return makeFloatUnary(floatOp, expr);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no binary operator.", op));
    }

    public Expression makeBinary(Expression x, ExpressionKind op, Expression y) {
        if (op instanceof BoolBinaryOp boolOp) {
            return makeBinary(x, boolOp, y);
        } else if (op instanceof IntBinaryOp intOp) {
            return makeBinary(x, intOp, y);
        } else if (op instanceof FloatBinaryOp floatOp) {
            return makeFloatBinary(x, floatOp, y);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no binary operator.", op));
    }

    public Expression makeCompare(Expression x, ExpressionKind cmpOp, Expression y) {
        if (cmpOp instanceof IntCmpOp intCmpOp) {
            return makeBinary(x, intCmpOp, y);
        } else if (cmpOp instanceof FloatCmpOp floatOp) {
            return makeFloatCmp(x, floatOp, y);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no comparison operator.", cmpOp));
    }
}
