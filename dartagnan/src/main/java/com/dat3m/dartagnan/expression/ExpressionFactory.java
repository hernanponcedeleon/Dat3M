package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.aggregates.AggregateCmpExpr;
import com.dat3m.dartagnan.expression.aggregates.AggregateCmpOp;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.booleans.*;
import com.dat3m.dartagnan.expression.floats.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
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
        return makeBoolUnary(BoolUnaryOp.NOT, operand);
    }

    public Expression makeAnd(Expression leftOperand, Expression rightOperand) {
        return makeBoolBinary(leftOperand, BoolBinaryOp.AND, rightOperand);
    }

    public Expression makeOr(Expression leftOperand, Expression rightOperand) {
        return makeBoolBinary(leftOperand, BoolBinaryOp.OR, rightOperand);
    }

    public Expression makeBoolUnary(BoolUnaryOp operator, Expression operand) {
        return new BoolUnaryExpr(operator, operand);
    }

    public Expression makeBoolBinary(Expression leftOperand, BoolBinaryOp operator, Expression rightOperand) {
        return new BoolBinaryExpr(leftOperand, operator, rightOperand);
    }

    public Expression makeBooleanCast(Expression operand) {
        final Type sourceType = operand.getType();
        if (sourceType instanceof BooleanType) {
            return operand;
        } else if (sourceType instanceof IntegerType intType) {
            return makeNEQ(operand, makeZero(intType));
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
        return makeIntCmp(leftOperand, signed ? IntCmpOp.LT : IntCmpOp.ULT, rightOperand);
    }

    public Expression makeGT(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntCmp(leftOperand, signed ? IntCmpOp.GT : IntCmpOp.UGT, rightOperand);
    }

    public Expression makeLTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntCmp(leftOperand, signed ? IntCmpOp.LTE : IntCmpOp.ULTE, rightOperand);
    }

    public Expression makeGTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntCmp(leftOperand, signed ? IntCmpOp.GTE : IntCmpOp.UGTE, rightOperand);
    }

    public Expression makeNeg(Expression operand) {
        return makeIntUnary(IntUnaryOp.MINUS, operand);
    }

    public Expression makeCTLZ(Expression operand) {
        return makeIntUnary(IntUnaryOp.CTLZ, operand);
    }

    public Expression makeCTTZ(Expression operand) {
        return makeIntUnary(IntUnaryOp.CTTZ, operand);
    }

    public Expression makeAdd(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.ADD, rightOperand);
    }

    public Expression makeSub(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.SUB, rightOperand);
    }

    public Expression makeMul(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.MUL, rightOperand);
    }

    public Expression makeDiv(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntBinary(leftOperand, signed ? IntBinaryOp.DIV : IntBinaryOp.UDIV, rightOperand);
    }

    public Expression makeRem(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntBinary(leftOperand, signed ? IntBinaryOp.SREM : IntBinaryOp.UREM, rightOperand);
    }

    public Expression makeIntAnd(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.AND, rightOperand);
    }

    public Expression makeIntOr(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.OR, rightOperand);
    }

    public Expression makeIntXor(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.XOR, rightOperand);
    }

    public Expression makeLshift(Expression leftOperand, Expression rightOperand) {
        return makeIntBinary(leftOperand, IntBinaryOp.LSHIFT, rightOperand);
    }

    public Expression makeRshift(Expression leftOperand, Expression rightOperand, boolean signed) {
        return makeIntBinary(leftOperand, signed ? IntBinaryOp.ARSHIFT : IntBinaryOp.RSHIFT, rightOperand);
    }

    public Expression makeIntUnary(IntUnaryOp operator, Expression operand) {
        return new IntUnaryExpr(operator, operand);
    }

    public Expression makeIntCmp(Expression leftOperand, IntCmpOp operator, Expression rightOperand) {
        return new IntCmpExpr(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeIntBinary(Expression leftOperand, IntBinaryOp operator, Expression rightOperand) {
        return new IntBinaryExpr(leftOperand, operator, rightOperand);
    }

    public Expression makeIntegerCast(Expression operand, IntegerType targetType, boolean signed) {
        final Type sourceType = operand.getType();

        if (sourceType instanceof BooleanType) {
            return makeITE(operand, makeOne(targetType), makeZero(targetType));
        } else if (sourceType instanceof IntegerType) {
            return sourceType.equals(targetType) ? operand : new IntSizeCast(targetType, operand, signed);
        } else if (sourceType instanceof FloatType) {
            return new FloatToIntCast(targetType, operand, signed);
        }

        throw new UnsupportedOperationException(String.format("Cannot cast %s to %s.", sourceType, targetType));
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Floats

    public FloatLiteral makeZero(FloatType type) {
        return makeValue(BigDecimal.ZERO, type);
    }

    public FloatLiteral makeValue(BigDecimal value, FloatType type) {
        return new FloatLiteral(type, value, false, false);
    }

    public Expression makeFAdd(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FADD, y);
    }

    public Expression makeFSub(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FSUB, y);
    }

    public Expression makeFMul(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FMUL, y);
    }

    public Expression makeFDiv(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FDIV, y);
    }

    public Expression makeFRem(Expression x, Expression y) {
        return new FloatBinaryExpr(x, FloatBinaryOp.FREM, y);
    }

    public Expression makeFNeg(Expression expr) {
        return new FloatUnaryExpr(FloatUnaryOp.NEG, expr);
    }

    public Expression makeFloatUnary(FloatUnaryOp op, Expression expr) {
        return new FloatUnaryExpr(op, expr);
    }

    public Expression makeFloatCmp(Expression x, FloatCmpOp op, Expression y) {
        return new FloatCmpExpr(booleanType, x, op, y);
    }

    public Expression makeFloatBinary(Expression x, FloatBinaryOp op, Expression y) {
        return new FloatBinaryExpr(x, op, y);
    }

    public Expression makeFloatCast(Expression operand, FloatType targetType, boolean signed) {
        final Type sourceType = operand.getType();

        if (sourceType instanceof FloatType) {
            return sourceType.equals(targetType) ? operand : new FloatSizeCast(targetType, operand);
        } else if (sourceType instanceof IntegerType) {
            return new IntToFloatCast(targetType, operand, signed);
        }

        throw new UnsupportedOperationException(String.format("Cannot cast %s to %s.", sourceType, targetType));
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Aggregates

    public Expression makeConstruct(Type type, List<? extends Expression> arguments) {
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

    public Expression makeAggregateCmp(Expression x, AggregateCmpOp op, Expression y) {
        return new AggregateCmpExpr(booleanType, x, op, y);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Pointers

    public Expression makeGetElementPointer(Type indexingType, Expression base, List<Expression> offsets) {
        //TODO getPointerType()
        Preconditions.checkArgument(base.getType().equals(types.getArchType()),
                "Applying offsets to non-pointer expression.");
        return new GEPExpr(indexingType, base, offsets);
    }

    public ScopedPointer makeScopedPointer(String id, String scopeId, Type type, Expression address) {
        return new ScopedPointer(id, scopeId, type, address);
    }

    public ScopedPointerVariable makeScopedPointerVariable(String id, String scopeId, Type type, MemoryObject address) {
        return new ScopedPointerVariable(id, scopeId, type, address);
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
            List<Expression> zeroes = new ArrayList<>(structType.getTypeOffsets().size());
            for (TypeOffset typeOffset : structType.getTypeOffsets()) {
                zeroes.add(makeGeneralZero(typeOffset.type()));
            }
            return makeConstruct(structType, zeroes);
        } else if (type instanceof IntegerType intType) {
            return makeZero(intType);
        } else if (type instanceof BooleanType) {
            return makeFalse();
        } else if (type instanceof FloatType floatType) {
            return makeZero(floatType);
        } else {
            throw new UnsupportedOperationException("Cannot create zero of type " + type);
        }
    }

    public Expression makeCast(Expression expression, Type type, boolean signed) {
        if (type instanceof BooleanType) {
            return makeBooleanCast(expression);
        } else if (type instanceof IntegerType integerType) {
            return makeIntegerCast(expression, integerType, signed);
        } else if (type instanceof FloatType floatType) {
            return makeFloatCast(expression, floatType, signed);
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
            return makeBoolBinary(leftOperand, BoolBinaryOp.IFF, rightOperand);
        } else if (type instanceof IntegerType) {
            return makeIntCmp(leftOperand, IntCmpOp.EQ, rightOperand);
        } else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.OEQ, rightOperand);
        } else if (type instanceof AggregateType) {
            return makeAggregateCmp(leftOperand, AggregateCmpOp.EQ, rightOperand);
        }
        throw new UnsupportedOperationException("Equality not supported on type: " + type);
    }

    public Expression makeNEQ(Expression leftOperand, Expression rightOperand) {
        final Type type = leftOperand.getType();
        if (type instanceof BooleanType) {
            return makeNot(makeBoolBinary(leftOperand, BoolBinaryOp.IFF, rightOperand));
        } else if (type instanceof IntegerType) {
            return makeIntCmp(leftOperand, IntCmpOp.NEQ, rightOperand);
        } else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.ONEQ, rightOperand);
        } else if (type instanceof AggregateType) {
            return makeAggregateCmp(leftOperand, AggregateCmpOp.NEQ, rightOperand);
        }
        throw new UnsupportedOperationException("Disequality not supported on type: " + type);
    }

    public Expression makeUnary(ExpressionKind op, Expression expr) {
        if (op instanceof BoolUnaryOp boolOp) {
            return makeBoolUnary(boolOp, expr);
        } else if (op instanceof IntUnaryOp intOp) {
            return makeIntUnary(intOp, expr);
        } else if (op instanceof FloatUnaryOp floatOp) {
            return makeFloatUnary(floatOp, expr);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no binary operator.", op));
    }

    public Expression makeBinary(Expression x, ExpressionKind op, Expression y) {
        if (op instanceof BoolBinaryOp boolOp) {
            return makeBoolBinary(x, boolOp, y);
        } else if (op instanceof IntBinaryOp intOp) {
            return makeIntBinary(x, intOp, y);
        } else if (op instanceof FloatBinaryOp floatOp) {
            return makeFloatBinary(x, floatOp, y);
        } else if (op instanceof IntCmpOp cmpOp) {
            return makeCompare(x, cmpOp, y);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no binary operator.", op));
    }

    public Expression makeCompare(Expression x, ExpressionKind cmpOp, Expression y) {
        if (cmpOp instanceof IntCmpOp intCmpOp) {
            return makeIntCmp(x, intCmpOp, y);
        } else if (cmpOp instanceof FloatCmpOp floatOp) {
            return makeFloatCmp(x, floatOp, y);
        } else if (cmpOp instanceof AggregateCmpOp aggrCmpOp) {
            return makeAggregateCmp(x, aggrCmpOp, y);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no comparison operator.", cmpOp));
    }
}
