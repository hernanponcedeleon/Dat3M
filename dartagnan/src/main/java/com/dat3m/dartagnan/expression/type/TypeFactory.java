package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.utils.Normalizer;
import com.google.common.math.IntMath;

import java.math.RoundingMode;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();

    private final VoidType voidType = new VoidType();
    private final BooleanType booleanType = new BooleanType();
    private final IntegerType pointerDifferenceType;

    private final Normalizer typeNormalizer = new Normalizer();

    private TypeFactory() {
        //TODO insert proper pointer and difference types
        pointerDifferenceType = new IntegerType(64);
    }

    //TODO make this part of the program.
    public static TypeFactory getInstance() {
        return instance;
    }

    public BooleanType getBooleanType() {
        return booleanType;
    }

    public VoidType getVoidType() { return voidType; }

    public Type getPointerType() {
        return pointerDifferenceType;
    }

    public boolean isPointerType(Type type) {
        return pointerDifferenceType == type;
    }

    public IntegerType getIntegerType(int bitWidth) {
        checkArgument(bitWidth > 0, "Non-positive bit width %s.", bitWidth);
        return typeNormalizer.normalize(new IntegerType(bitWidth));
    }

    public FloatType getFloatType(int mantissaBits, int exponentBits) {
        checkArgument(mantissaBits > 0 && exponentBits > 0,
                "Cannot construct floating-point type with mantissa %s and exponent %s",
                mantissaBits, exponentBits);
        return typeNormalizer.normalize(new FloatType(mantissaBits, exponentBits));
    }

    public FunctionType getFunctionType(Type returnType, List<? extends Type> parameterTypes) {
        return getFunctionType(returnType, parameterTypes, false);
    }

    public FunctionType getFunctionType(Type returnType, List<? extends Type> parameterTypes, boolean isVarArg) {
        checkNotNull(returnType);
        checkNotNull(parameterTypes);
        checkArgument(parameterTypes.stream().noneMatch(t -> t == voidType), "Void parameters are not allowed");
        return typeNormalizer.normalize(new FunctionType(returnType, parameterTypes.toArray(new Type[0]), isVarArg));
    }

    public AggregateType getAggregateType(List<Type> fields) {
        checkNotNull(fields);
        checkArgument(fields.stream().noneMatch(t -> t == voidType), "Void fields are not allowed");
        return typeNormalizer.normalize(new AggregateType(fields));
    }

    public ArrayType getArrayType(Type element) {
        return typeNormalizer.normalize(new ArrayType(element, -1));
    }

    public ArrayType getArrayType(Type element, int size) {
        checkArgument(0 <= size, "Negative element count in array.");
        return typeNormalizer.normalize(new ArrayType(element, size));
    }

    public IntegerType getArchType() {
        return pointerDifferenceType;
    }

    public IntegerType getByteType() {
        return getIntegerType(8);
    }

    public int getMemorySizeInBytes(Type type) {
        final int sizeInBytes;
        if (type instanceof ArrayType arrayType) {
            sizeInBytes = arrayType.getNumElements() * getMemorySizeInBytes(arrayType.getElementType());
        } else if (type instanceof AggregateType aggregateType) {
            int aggregateSize = 0;
            for (Type fieldType : aggregateType.getDirectFields()) {
                int size = getMemorySizeInBytes(fieldType);
                //FIXME: We assume for now that a small type's (<= 8 byte) alignment coincides with its size.
                // For all larger types, we assume 8 byte alignment
                int alignment = Math.min(size, 8);
                if (size != 0) {
                    int padding = (-aggregateSize) % alignment;
                    padding = padding < 0 ? padding + alignment : padding;
                    aggregateSize += size + padding;
                }
            }
            sizeInBytes = aggregateSize;
        } else if (type instanceof IntegerType integerType) {
            sizeInBytes = IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
        } else if (type instanceof FloatType floatType) {
            sizeInBytes = IntMath.divide(floatType.getBitWidth(), 8, RoundingMode.CEILING);
        } else if (type instanceof BooleanType) {
            // TODO: We assume 1 byte alignment
            return 1;
        } else {
            throw new UnsupportedOperationException("Cannot compute the size of " + type);
        }
        return sizeInBytes;
    }
}
