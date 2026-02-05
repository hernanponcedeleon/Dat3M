package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.aggregates.*;
import com.dat3m.dartagnan.expression.booleans.*;
import com.dat3m.dartagnan.expression.floats.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.pointers.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.expression.type.TypeFactory.isStaticTypeOf;

public final class ExpressionFactory {

    private static final ExpressionFactory instance = new ExpressionFactory();

    private final TypeFactory types = TypeFactory.getInstance();
    private final IntegerType archType = types.getArchType();
    private final PointerType pointerType = types.getPointerType();
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
        }else if (sourceType instanceof PointerType) {
            return makeBooleanCast(makePtrToIntCast(operand, archType));
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

    public IntLiteral makeValue(BigInteger value) {
        return new IntLiteral(archType, value);
    }

    public IntLiteral makeValue(BigInteger value, int bitwidth) {
        return new IntLiteral(types.getIntegerType(bitwidth), value);
    }

    public IntLiteral makeValue(long value, IntegerType type) {
        return makeValue(BigInteger.valueOf(value), type);
    }

    public IntLiteral makeValue(BigInteger value, IntegerType type) {
        return new IntLiteral(type, value);
    }

    public Expression makeLT(Expression leftOperand, Expression rightOperand, boolean signed) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(leftOperand,IntCmpOp.ULT,rightOperand);
        }
        return makeIntCmp(leftOperand, signed ? IntCmpOp.LT : IntCmpOp.ULT, rightOperand);
    }

    public Expression makeGT(Expression leftOperand, Expression rightOperand, boolean signed) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(leftOperand,IntCmpOp.UGT,rightOperand);
        }
        return makeIntCmp(leftOperand, signed ? IntCmpOp.GT : IntCmpOp.UGT, rightOperand);
    }

    public Expression makeLTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(leftOperand,IntCmpOp.ULTE,rightOperand);
        }
        return makeIntCmp(leftOperand, signed ? IntCmpOp.LTE : IntCmpOp.ULTE, rightOperand);
    }

    public Expression makeGTE(Expression leftOperand, Expression rightOperand, boolean signed) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(leftOperand,IntCmpOp.UGTE,rightOperand);
        }
        return makeIntCmp(leftOperand, signed ? IntCmpOp.GTE : IntCmpOp.UGTE, rightOperand);

    }


//    public Expression makeLTfromInts(Expression leftOperand, Expression rightOperand, boolean signed) {
//        return makeIntCmpfromInts(leftOperand, signed ? IntCmpOp.LT : IntCmpOp.ULT, rightOperand);
//    }

//    public Expression makeGTfromInts(Expression leftOperand, Expression rightOperand, boolean signed) {
//        return makeIntCmpfromInts(leftOperand, signed ? IntCmpOp.GT : IntCmpOp.UGT, rightOperand);
//    }
//
//    public Expression makeLTEfromInts(Expression leftOperand, Expression rightOperand, boolean signed) {
//        return makeIntCmpfromInts(leftOperand, signed ? IntCmpOp.LTE : IntCmpOp.ULTE, rightOperand);
//    }
//
//    public Expression makeGTEfromInts(Expression leftOperand, Expression rightOperand, boolean signed) {
//        return makeIntCmpfromInts(leftOperand, signed ? IntCmpOp.GTE : IntCmpOp.UGTE, rightOperand);
//    }

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

    public Expression makeIntConcat(List<? extends Expression> operands) {
        return new IntConcat(operands);
    }

    public Expression makeIntExtract(Expression operand, int lowBit, int highBit) {
        return new IntExtract(operand, lowBit, highBit);
    }

    public Expression makeIntUnary(IntUnaryOp operator, Expression operand) {
        return new IntUnaryExpr(operator, operand);
    }

    public Expression makeIntCmp(Expression leftOperand, IntCmpOp operator, Expression rightOperand) {
        return new IntCmpExpr(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeIntCmpfromInts(Expression leftOperand, IntCmpOp operator, Expression rightOperand) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(makePtrToIntCast(leftOperand, archType), operator, rightOperand);
        }
        if (rightOperand.getType() instanceof PointerType){
            return makeIntCmpfromInts(leftOperand, operator, makePtrToIntCast(rightOperand, archType));
        }
        return new IntCmpExpr(types.getBooleanType(), leftOperand, operator, rightOperand);
    }

    public Expression makeIntBinary(Expression leftOperand, IntBinaryOp operator, Expression rightOperand) {
        return new IntBinaryExpr(leftOperand, operator, rightOperand);
    }

    public Expression makeIntBinaryfromInts(Expression leftOperand, IntBinaryOp operator, Expression rightOperand) {
        if (leftOperand.getType() instanceof PointerType){
            return makeIntBinaryfromInts(makePtrToIntCast(leftOperand, archType), operator, rightOperand);
        }
        if (rightOperand.getType() instanceof PointerType){
            return makeIntBinaryfromInts(leftOperand, operator, makePtrToIntCast(rightOperand, archType));
        }
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
        }else if (sourceType instanceof PointerType) {
            return makePtrToIntCast(operand, targetType);
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
    public List<Type> unpackTypeHelper(Type type){
        if(type instanceof AggregateType ag){
            return ag.getFields().stream().map(TypeOffset::type).toList();
        }
        if(type instanceof ArrayType ar){
            return new ArrayList<>(Collections.nCopies(ar.getNumElements(),ar.getElementType()));
        }
        return List.of(type);
    }
    public List<Type> unpackTypes(List<Type> type){
        List<Type> newResult = type.stream().map(this::unpackTypeHelper).flatMap(List::stream).toList();
        List<Type> oldResult = type;
        while(!newResult.equals(oldResult)){
            // fixme way simpler using recursion!
            oldResult = newResult;
            newResult = type.stream().map(this::unpackTypeHelper).flatMap(List::stream).toList();
        }
        return newResult;
    }
    public List<Type> unpackType(Type type){
        List<Type> list = List.of(type);
        return unpackTypes(list);
    }

    public Expression makeConstruct(Type type, List<? extends Expression> arguments) {
        return new ConstructExpr(type, arguments);
    }
    public Expression makeCompatibilityConstruct(Type type, List<? extends Expression> arguments) {
        assert ExpressionHelper.isAggregateLike(type);
        List<Type> types = unpackType(type);
        List<Expression> newArguments = new ArrayList<>();
        assert types.size() == arguments.size();
        for (int i = 0; i < types.size(); ++i) {
            newArguments.add(makeCast(arguments.get(i),types.get(i)));
        }
        return new ConstructExpr(type, newArguments);
    }

    public Expression makeArray(ArrayType type, List<Expression> items) {
        Preconditions.checkArgument(!type.hasKnownNumElements() || type.getNumElements() == items.size(),
                "The number of elements must match");
        if (!items.isEmpty()) {
            long distinctSubtypesCount = items.stream().map(Expression::getType).distinct().count();
            Preconditions.checkArgument(distinctSubtypesCount == 1,
                    "All elements in an array must have the same type.");
            Preconditions.checkArgument(isStaticTypeOf(items.get(0).getType(), type.getElementType()),
                    "Array elements must match expected type");
        }
        return new ConstructExpr(type, items);
    }

    public Expression makeExtract(Expression object, int index) {
        return makeExtract(object, List.of(index));
    }

    public Expression makeExtract(Expression object, Iterable<Integer> indices) {
        if (Iterables.isEmpty(indices)) {
            return object;
        }
        return new ExtractExpr(object, indices);
    }

    public Expression makeInsert(Expression aggregate, Expression value, int index) {
        return makeInsert(aggregate, value, List.of(index));
    }

    public Expression makeInsert(Expression aggregate, Expression value, Iterable<Integer> indices) {
        if (Iterables.isEmpty(indices)) {
            return aggregate;
        }
        return new InsertExpr(aggregate, indices, value);
    }

    public Expression makeAggregateCmp(Expression x, AggregateCmpOp op, Expression y) {
        return new AggregateCmpExpr(booleanType, x, op, y);
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Pointers

    public Expression makeGetElementPointer(Type indexingType, Expression base, List<Expression> offsets) {
        Preconditions.checkArgument(base.getType() instanceof  PointerType,
                "Applying offsets to non-pointer expression.");
        return new GEPExpr(indexingType, base, offsets,null);
    }

    public Expression makeGetElementPointer(Type indexingType, Expression base, List<Expression> offsets, Integer stride) {
        // TODO: Stride should be a property of the pointer, not of a GEPExpr.
        //  Refactor GEPExpr to only accept a (new) PointerType and a list of offsets.
        //  A PointerType should have the referred type and the stride in its attributes.
        Preconditions.checkArgument(base.getType() instanceof  PointerType,
                "Applying offsets to non-pointer expression.");
        Preconditions.checkArgument(stride == null || stride >= types.getMemorySizeInBytes(indexingType),
        "Stride cannot be smaller than indexing type");
        return new GEPExpr(indexingType, base, offsets, stride);
    }


    public ScopedPointer makeScopedPointer(String id, ScopedPointerType type, Expression value) {
        return new ScopedPointer(id, type, value);
    }

    public ScopedPointerVariable makeScopedPointerVariable(String id, ScopedPointerType type, MemoryObject memObj) {
        return new ScopedPointerVariable(id, type, memObj);
    }

    public Expression makePtrAdd(Expression base, Expression offset) {
        return new PtrAddExpr(base, offset);
    }

    public Expression makePtrCast(Expression base, PointerType type){
        if (base.getType() instanceof PointerType){
            if (base.getType().equals(type)) {
                return base;
            // pointers of different size than arch should not be used (store | load). Comparison is still possible in wmm.
            }else{
                // we use this because spirv has some weird casts between scoped pointers.
                // not the most elegant solution, maybe a dedicated ptr size/type cast?
                return makeIntToPtrCast(makePtrToIntCast(base, types.getIntegerType(type.bitWidth)), type);
        }}
        if (base.getType() instanceof IntegerType) {
            return makeIntToPtrCast(base, type);
        }
        if (base.getType() instanceof BooleanType) {
            return makePtrCast(makeIntegerCast(base, archType,false),type);
        }
        throw new UnsupportedOperationException(String.format("Cast %s into pointer unsupported.",base));
    }



    public Expression makePtrToIntCast(Expression pointer, IntegerType type) {
        return new PtrToIntCast(type, pointer);
    }


    public Expression makeIntToPtrCast(Expression integer, PointerType pointerType) {
        return new IntToPtrCast(pointerType, integer);
    }
    public Expression makeIntToPtrCast(Expression operand) {
        return makeIntToPtrCast(operand,pointerType);
    }



    public Expression makeNullLiteral(PointerType pointerType) {
        return new NullLiteral(pointerType);
    }

    public Expression makeNullLiteral() {
        return makeNullLiteral(pointerType);
    }

    public Expression makePtrCmp(Expression left, PtrCmpOp op, Expression right) {
        return new PtrCmpExpr(types.getBooleanType(), left, op, right);
    }

    public Expression makePtrExtract(Expression operand, int lowBit, int highBit) {
        return new PtrExtract(operand, lowBit, highBit);
    }

    public Expression makePtrConcat(List<? extends Expression> operands) {
        return new PtrConcat(operands);
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
            return makeArray(arrayType, zeroes);
        } else if (type instanceof AggregateType structType) {
            List<Expression> zeroes = new ArrayList<>(structType.getFields().size());
            for (TypeOffset typeOffset : structType.getFields()) {
                zeroes.add(makeGeneralZero(typeOffset.type()));
            }
            return makeConstruct(structType, zeroes);
        } else if (type instanceof IntegerType intType) {
            return makeZero(intType);
        } else if (type instanceof BooleanType) {
            return makeFalse();
        } else if (type instanceof FloatType floatType) {
            return makeZero(floatType);
        } else if (type instanceof PointerType pointerType) {
            return makeNullLiteral(pointerType);
        }else{
            throw new UnsupportedOperationException("Cannot create zero of type " + type);
        }
    }

    public Expression makeCast(Expression expression, Type type, boolean signed) {
        if (expression.getType().equals(type)) {return expression;}
        if (type instanceof BooleanType) {return makeBooleanCast(expression);}
        else if (type instanceof IntegerType integerType) {
            return makeIntegerCast(expression, integerType, signed);
        } else if (type instanceof FloatType floatType) {
            return makeFloatCast(expression, floatType, signed);
        }else if (type instanceof PointerType) {
            return makePtrCast(expression, (PointerType) type); // todo fix for tearing(mixed test), maybe a teared pointer tracker.
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
        } if (type instanceof PointerType) {
            return makePtrCmp(leftOperand, PtrCmpOp.EQ, rightOperand);
        } else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.OEQ, rightOperand);
        } else if (ExpressionHelper.isAggregateLike(type)) {
            return makeAggregateCmp(leftOperand, AggregateCmpOp.EQ, rightOperand);
        }
        throw new UnsupportedOperationException("Equality not supported on type: " + type);
    }

    public Expression makeBinaryEQ(Expression leftOperand, Expression rightOperand) {

        if (leftOperand.getType() instanceof PointerType){
            return makeBinaryEQ(makePtrToIntCast(leftOperand, archType), rightOperand);
        }
        if (rightOperand.getType() instanceof PointerType){
            return makeBinaryEQ(leftOperand, makePtrToIntCast(rightOperand, archType));
        }
        return makeEQ(leftOperand, rightOperand);
    }

    public Expression makeNEQ(Expression leftOperand, Expression rightOperand) {
        final Type type = leftOperand.getType();
        if (type instanceof BooleanType) {
            return makeNot(makeBoolBinary(leftOperand, BoolBinaryOp.IFF, rightOperand));
        } else if (type instanceof IntegerType) {
            return makeIntCmp(leftOperand, IntCmpOp.NEQ, rightOperand);
        } if (type instanceof PointerType) {
            return makePtrCmp(leftOperand, PtrCmpOp.NEQ, rightOperand);
        }else if (type instanceof FloatType) {
            // TODO: Decide on a default semantics for float equality?
            return makeFloatCmp(leftOperand, FloatCmpOp.ONEQ, rightOperand);
        } else if (type instanceof AggregateType) {
            return makeAggregateCmp(leftOperand, AggregateCmpOp.NEQ, rightOperand);
        }
        throw new UnsupportedOperationException("Disequality not supported on type: " + type);
    }


    public Expression makeBinaryNEQ(Expression leftOperand, Expression rightOperand) {
        //cast both operands to archtype and compare them
        if (leftOperand.getType() instanceof PointerType){
            return makeBinaryNEQ(makePtrToIntCast(leftOperand, archType), rightOperand);
        }
        if (rightOperand.getType() instanceof PointerType){
            return makeBinaryNEQ(leftOperand, makePtrToIntCast(rightOperand, archType));
        }
        return makeNEQ(leftOperand, rightOperand);
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
        }else if (op instanceof PtrCmpOp cmpOp) {
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
        }else if (cmpOp instanceof PtrCmpOp ptrCmpOp) {
            return makePtrCmp(x, ptrCmpOp, y);
        }
        throw new UnsupportedOperationException(String.format("Expression kind %s is no comparison operator.", cmpOp));
    }


}