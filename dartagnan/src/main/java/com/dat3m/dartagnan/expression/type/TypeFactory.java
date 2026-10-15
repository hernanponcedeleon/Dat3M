package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.utils.Normalizer;
import com.google.common.math.IntMath;

import java.math.RoundingMode;
import java.util.List;
import java.util.stream.IntStream;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();

    //TODO make this part of the program.
    public static TypeFactory getInstance() {
        return instance;
    }

    private final Normalizer typeNormalizer = new Normalizer();

    private final VoidType voidType = new VoidType();
    private final Type unitType = getAggregateType(List.of(), List.of(), 1, 0);
    private final BooleanType booleanType = new BooleanType();

    private TypeFactory() {
    }

    // ==================================================================================================
    // Basic types

    public VoidType getVoidType() { return voidType; }

    public Type getUnitType() { return unitType; }

    public BooleanType getBooleanType() {
        return booleanType;
    }

    public IntegerType getIntegerType(int bitWidth) {
        checkArgument(bitWidth > 0, "Non-positive bit width %s.", bitWidth);
        return typeNormalizer.normalize(new IntegerType(bitWidth));
    }

    public IntegerType getByteType() {
        return getIntegerType(8);
    }

    public MemoryType getMemoryType(int bitWidth) {
        checkArgument(bitWidth > 0, "Non-positive bit width %s.", bitWidth);
        return typeNormalizer.normalize(new MemoryType(bitWidth));
    }

    public MemoryType getMemoryTypeFor(Type other) {
        if (other instanceof MemoryType memType) {
            return memType;
        }
        return getMemoryType(getMemorySizeInBits(other));
    }

    public FloatType getFloatType(int mantissaBits, int exponentBits) {
        checkArgument(mantissaBits > 0 && exponentBits > 0,
                "Cannot construct floating-point type with mantissa %s and exponent %s",
                mantissaBits, exponentBits);
        return typeNormalizer.normalize(new FloatType(mantissaBits, exponentBits));
    }

    public FloatType getIEEEHalfType() { return getFloatType(10, 5); }
    public FloatType getIEEESingleType() { return getFloatType(23, 8); }
    public FloatType getIEEEDoubleType() { return getFloatType(52, 11); }

    public ScopedPointerType getScopedPointerType(String scopeId, Type pointedType, Integer stride) {
        checkNotNull(scopeId);
        checkNotNull(pointedType);
        if (stride != null) {
            checkArgument(stride > 0, "Stride must be positive");
            checkArgument(stride >= getMemorySizeInBytes(pointedType),
                    "Stride cannot be smaller than element size");
        }
        return typeNormalizer.normalize(new ScopedPointerType(scopeId, pointedType, stride));
    }

    // ==================================================================================================
    // Derived types

    public FunctionType getFunctionType(Type returnType, List<? extends Type> parameterTypes) {
        return getFunctionType(returnType, parameterTypes, false);
    }

    public FunctionType getFunctionType(Type returnType, List<? extends Type> parameterTypes, boolean isVarArg) {
        checkNotNull(returnType);
        checkNotNull(parameterTypes);
        checkArgument(parameterTypes.stream().noneMatch(t -> t == voidType), "Void parameters are not allowed");
        return typeNormalizer.normalize(new FunctionType(returnType, parameterTypes, isVarArg));
    }

    /** Creates a group of register values without assigning a memory layout. */
    public TupleType getTupleType(List<? extends Type> fields) {
        checkNotNull(fields);
        checkArgument(fields.stream().noneMatch(t -> t == voidType), "Void fields are not allowed");
        return typeNormalizer.normalize(new TupleType(fields));
    }

    /** Creates a memory aggregate with an explicitly computed layout. */
    public AggregateType getAggregateType(List<Type> fields, List<Integer> offsets, int alignment, int size) {
        checkAggregateLayout(fields, offsets, alignment);
        checkArgument(size == -1 || size >= 0 && (fields.isEmpty()
                || size >= offsets.get(offsets.size() - 1) + Math.max(0, getMemorySizeInBytes(fields.get(fields.size() - 1)))),
                "Aggregate size is too small");
        return typeNormalizer.normalize(new AggregateType(fields, offsets, alignment, size));
    }

    void checkAggregateLayout(List<Type> fields, List<Integer> offsets, int alignment) {
        checkNotNull(fields);
        checkNotNull(offsets);
        checkArgument(alignment > 0, "Alignment must be positive");
        checkArgument(fields.stream().noneMatch(t -> t == voidType), "Void fields are not allowed");
        checkArgument(fields.stream().noneMatch(t -> t instanceof TupleType), "Tuples have no memory layout");
        checkArgument(fields.size() == offsets.size(), "Offsets number does not match the fields number");
        checkArgument(offsets.stream().noneMatch(o -> o < 0), "Offset cannot be negative");
        checkArgument(offsets.isEmpty() || offsets.get(0) == 0, "The first offset must be zero");
        checkArgument(IntStream.range(1, offsets.size()).allMatch(
                i -> offsets.get(i) >= offsets.get(i - 1) + Integer.max(0, getMemorySizeInBytes(fields.get(i - 1), false))),
                "Offset is too small");
        checkArgument(IntStream.range(0, fields.size() - 1).allMatch(
                i -> hasKnownSize(fields.get(i))),
                "Non-last element with unknown size");
    }

    public ArrayType getArrayType(Type element) {
        return getArrayType(element, -1, null, null);
    }

    public ArrayType getArrayType(Type element, int size) {
        checkArgument(0 <= size, "Negative element count in array.");
        return getArrayType(element, size, null, null);
    }

    public ArrayType getArrayType(Type element, int size, Integer stride) {
        return getArrayType(element, size, stride, null);
    }

    public ArrayType getArrayType(Type element, int size, Integer stride, Integer alignment) {
        checkArgument(!(element instanceof TupleType), "Tuples have no memory layout");
        checkArgument(stride == null || alignment == null,
                "Stride and alignment cannot be used simultaneously");
        if (stride != null) {
            checkArgument(stride > 0, "Stride must be positive");
            checkArgument(stride >= getMemorySizeInBytes(element),
                    "Stride cannot be smaller than element size");
        }
        if (alignment != null) {
            checkArgument(alignment > 0, "Alignment must be positive");
        }
        return typeNormalizer.normalize(new ArrayType(element, size, stride, alignment));
    }

    // ==================================================================================================
    // Type layout utility

    public boolean hasKnownSize(Type type) { return getMemorySizeInBytes(type) >= 0; }

    public int getMemorySizeInBits(Type type) {
        return getMemorySizeInBytes(type) * 8;
    }

    /**
     * Returns scalar storage size or the layout recorded in a composite memory type.
     * Scalar ABI allocation padding must be supplied by the frontend through allocation types and strides.
     * Tuples have no memory representation.
     */
    public int getMemorySizeInBytes(Type type) {
        return getMemorySizeInBytes(type, true);
    }

    private int getMemorySizeInBytes(Type type, boolean padded) {
        if (type instanceof BooleanType) {
            return 1;
        } else if (type instanceof MemoryType memType) {
            return IntMath.divide(memType.getBitWidth(), 8, RoundingMode.CEILING);
        } else if (type instanceof IntegerType integerType) {
            return IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
        } else if (type instanceof FloatType floatType) {
            return IntMath.divide(floatType.getBitWidth(), 8, RoundingMode.CEILING);
        } else if (type instanceof ArrayType arrayType) {
            if (!arrayType.hasKnownNumElements()) {
                return -1;
            }
            Integer stride = arrayType.getStride();
            if (stride != null) {
                return stride * arrayType.getNumElements();
            }
            int elSize = getMemorySizeInBytes(arrayType.getElementType());
            if (elSize >= 0) {
                int size = elSize * arrayType.getNumElements();
                if (arrayType.getAlignment() != null) {
                    return paddedSize(size, arrayType.getAlignment());
                }
                return size;
            }
        } else if (type instanceof AggregateType aType) {
            if (padded) {
                return aType.getSize();
            }
            List<TypeOffset> typeOffsets = aType.getFields();
            if (aType.getFields().stream().anyMatch(o -> !hasKnownSize(o.type()))) {
                return -1;
            }
            if (typeOffsets.isEmpty()) {
                return 0;
            }
            TypeOffset lastTypeOffset = typeOffsets.get(typeOffsets.size() - 1);
            int baseSize = lastTypeOffset.offset() + getMemorySizeInBytes(lastTypeOffset.type());
            return baseSize;
        }
        throw new UnsupportedOperationException("Cannot compute memory layout of type " + type);
    }

    public int getOffsetInBytes(Type type, int index) {
        return TypeOffset.of(type, index).offset();
    }

    // ==================================================================================================
    // Other

    public boolean isStaticType(Type type) {
        if (type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType) {
            return true;
        }
        if (type instanceof ArrayType aType) {
            return aType.hasKnownNumElements() && isStaticType(aType.getElementType());
        }
        if (type instanceof AggregateType aType) {
            return aType.getFields().stream().allMatch(o -> isStaticType(o.type()));
        }
        if (type instanceof TupleType tupleType) {
            return tupleType.getFields().stream().allMatch(this::isStaticType);
        }
        throw new UnsupportedOperationException("Cannot compute if type '" + type + "' is static");
    }

    public boolean isStaticTypeOf(Type staticType, Type runtimeType) {
        if (staticType.equals(runtimeType)) {
            return true;
        }
        if (staticType instanceof AggregateType aStaticType && runtimeType instanceof AggregateType aRuntimeType) {
            int size = aStaticType.getFields().size();
            if (size != aRuntimeType.getFields().size()) {
                return false;
            }
            for (int i = 0; i < size; i++) {
                TypeOffset staticTypeOffset = aStaticType.getFields().get(i);
                TypeOffset runtimeTypeOffset = aRuntimeType.getFields().get(i);
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

    // ==================================================================================================
    // Static utility

    private static int paddedSize(int size, int alignment) {
        int mod = size % alignment;
        if (mod > 0) {
            return size + alignment - mod;
        }
        return size;
    }
}
