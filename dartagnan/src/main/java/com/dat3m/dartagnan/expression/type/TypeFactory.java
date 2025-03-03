package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.utils.Normalizer;
import com.google.common.math.IntMath;

import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.utils.Normalizer;
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

    public ScopedPointerType getScopedPointerType(String scopeId, Type pointedType) {
        checkNotNull(scopeId);
        checkNotNull(pointedType);
        return typeNormalizer.normalize(new ScopedPointerType(scopeId, pointedType));
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
        return getAggregateType(fields, computeDefaultOffsets(fields));
    }

    public AggregateType getAggregateType(List<Type> fields, List<Integer> offsets) {
        checkNotNull(fields);
        checkNotNull(offsets);
        checkArgument(fields.stream().noneMatch(t -> t == voidType), "Void fields are not allowed");
        checkArgument(fields.size() == offsets.size(), "Offsets number does not match the fields number");
        checkArgument(offsets.stream().noneMatch(o -> o < 0), "Offset cannot be negative");
        checkArgument(offsets.isEmpty() || offsets.get(0) == 0, "The first offset must be zero");
        checkArgument(IntStream.range(1, offsets.size()).allMatch(
                i -> offsets.get(i) >= offsets.get(i - 1) + Integer.max(0, getMemorySizeInBytes(fields.get(i - 1), false))),
                "Offset is too small");
        checkArgument(IntStream.range(0, fields.size() - 1).allMatch(
                i -> hasKnownSize(fields.get(i))),
                "Non-last element with unknown size");
        return typeNormalizer.normalize(new AggregateType(fields, offsets));
    }

    private List<Integer> computeDefaultOffsets(List<Type> fields) {
        List<Integer> offsets = new ArrayList<>();
        int offset = 0;
        if (!fields.isEmpty()) {
            offset = getMemorySizeInBytes(fields.get(0));
            offsets.add(0);
        }
        for (int i = 1; i < fields.size(); i++) {
            offset = paddedSize(offset, getAlignment(fields.get(i)));
            offsets.add(offset);
            offset += getMemorySizeInBytes(fields.get(i));
        }
        return offsets;
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
        return getMemorySizeInBytes(type, true);
    }

    public int getMemorySizeInBytes(Type type, boolean padded) {
        if (type instanceof BooleanType) {
            return 1;
        }
        if (type instanceof IntegerType integerType) {
            return IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
        }
        if (type instanceof FloatType floatType) {
            return IntMath.divide(floatType.getBitWidth(), 8, RoundingMode.CEILING);
        }
        if (type instanceof ArrayType arrayType) {
            if (arrayType.hasKnownNumElements()) {
                Type elType = arrayType.getElementType();
                return getMemorySizeInBytes(elType) * arrayType.getNumElements();
            }
            return -1;
        }
        if (type instanceof AggregateType aType) {
            List<TypeOffset> typeOffsets = aType.getTypeOffsets();
            if (aType.getTypeOffsets().stream().anyMatch(o -> !hasKnownSize(o.type()))) {
                return -1;
            }
            if (typeOffsets.isEmpty()) {
                return 0;
            }
            TypeOffset lastTypeOffset = typeOffsets.get(typeOffsets.size() - 1);
            int baseSize = lastTypeOffset.offset() + getMemorySizeInBytes(lastTypeOffset.type());
            if (padded) {
                return paddedSize(baseSize, getAlignment(type));
            }
            return baseSize;
        }
        throw new UnsupportedOperationException("Cannot compute memory layout of type " + type);
    }

    public int getAlignment(Type type) {
        if (type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType) {
            return getMemorySizeInBytes(type);
        }
        if (type instanceof ArrayType arrayType) {
            return getAlignment(arrayType.getElementType());
        }
        if (type instanceof AggregateType aType) {
            return aType.getTypeOffsets().stream().map(o -> getAlignment(o.type())).max(Integer::compare).orElse(1);
        }
        throw new UnsupportedOperationException("Cannot compute memory layout of type " + type);
    }

    public static int paddedSize(int size, int alignment) {
        int mod = size % alignment;
        if (mod > 0) {
            return size + alignment - mod;
        }
        return size;
    }

    public boolean hasKnownSize(Type type) { return getMemorySizeInBytes(type) >= 0; }

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
            for (TypeOffset typeOffset : aggregateType.getTypeOffsets()) {
                final Map<Integer, Type> innerDecomposition = decomposeIntoPrimitives(typeOffset.type());
                if (innerDecomposition == null) {
                    return null;
                }
                for (Map.Entry<Integer, Type> entry : innerDecomposition.entrySet()) {
                    decomposition.put(typeOffset.offset() + entry.getKey(), entry.getValue());
                }
            }
        } else {
            // Primitive type
            decomposition.put(0, type);
        }

        return decomposition;
    }

    public static boolean isStaticType(Type type) {
        if (type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType) {
            return true;
        }
        if (type instanceof ArrayType aType) {
            return aType.hasKnownNumElements() && isStaticType(aType.getElementType());
        }
        if (type instanceof AggregateType aType) {
            return aType.getTypeOffsets().stream().allMatch(o -> isStaticType(o.type()));
        }
        throw new UnsupportedOperationException("Cannot compute if type '" + type + "' is static");
    }

    public static boolean isStaticTypeOf(Type staticType, Type runtimeType) {
        if (staticType.equals(runtimeType)) {
            return true;
        }
        if (staticType instanceof AggregateType aStaticType && runtimeType instanceof AggregateType aRuntimeType) {
            int size = aStaticType.getTypeOffsets().size();
            if (size != aRuntimeType.getTypeOffsets().size()) {
                return false;
            }
            for (int i = 0; i < size; i++) {
                TypeOffset staticTypeOffset = aStaticType.getTypeOffsets().get(i);
                TypeOffset runtimeTypeOffset = aRuntimeType.getTypeOffsets().get(i);
                if (staticTypeOffset.offset() != runtimeTypeOffset.offset()
                        || !isStaticTypeOf(staticTypeOffset.type(), runtimeTypeOffset.type())) {
                    return false;
                }
            }
            return true;
        }
        if (staticType instanceof ArrayType aStaticType && runtimeType instanceof ArrayType aRuntimeType) {
            int countStatic = aStaticType.getNumElements();
            int countRuntime = aRuntimeType.getNumElements();
            if (countStatic != countRuntime && (countRuntime != -1 || countStatic <= 0)) {
                return false;
            }
            return isStaticTypeOf(aStaticType.getElementType(), aRuntimeType.getElementType());
        }
        if (staticType instanceof ScopedPointerType pStaticType && runtimeType instanceof ScopedPointerType pRuntimeType) {
            return isStaticTypeOf(pStaticType.getPointedType(), pRuntimeType.getPointedType());
        }
        return false;
    }
}
