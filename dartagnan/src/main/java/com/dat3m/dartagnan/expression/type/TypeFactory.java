package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.utils.Normalizer;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();

    private final VoidType voidType = new VoidType();
    private final BooleanType booleanType = new BooleanType();
    private final IntegerType pointerDifferenceType;

    private final Normalizer typeNormalizer = new Normalizer();

    private TypeFactory() {
        pointerDifferenceType = getIntegerType(64);//TODO insert proper pointer and difference types
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
        return TypeLayout.of(type).totalSizeInBytes();
    }

    public int getMemorySizeInBits(Type type) {
        return getMemorySizeInBytes(type) * 8;
    }

    public int getOffsetInBytes(Type type, int index) {
        return TypeOffset.of(type, index).offset();
    }

    public Map<Integer, Type> decomposeIntoPrimitives(Type type) {
        final Map<Integer, Type> decomposition = new LinkedHashMap<>();
        if (type instanceof ArrayType arrayType) {
            final Map<Integer, Type> innerDecomposition = decomposeIntoPrimitives(arrayType.getElementType());
            if (!arrayType.hasKnownNumElements() || innerDecomposition == null) {
                return null;
            }

            final int size = getMemorySizeInBytes(arrayType.getElementType());
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                final int offset = i * size;
                for (Map.Entry<Integer, Type> entry : innerDecomposition.entrySet()) {
                    decomposition.put(entry.getKey() + offset, entry.getValue());
                }
            }
        } else if (type instanceof AggregateType aggregateType) {
            final List<Type> fields = aggregateType.getDirectFields();
            for (int i = 0; i < fields.size(); i++) {
                final int offset = getOffsetInBytes(aggregateType, i);
                final Map<Integer, Type> innerDecomposition = decomposeIntoPrimitives(fields.get(i));
                if (innerDecomposition == null) {
                    return null;
                }

                for (Map.Entry<Integer, Type> entry : innerDecomposition.entrySet()) {
                    decomposition.put(entry.getKey() + offset, entry.getValue());
                }
            }
        } else {
            // Primitive type
            decomposition.put(0, type);
        }

        return decomposition;
    }
}
