package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.utils.Normalizer;
import com.google.common.math.IntMath;

import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();

    private final VoidType voidType = new VoidType();
    private final BooleanType booleanType = new BooleanType();
    private final IntegerType pointerDifferenceType;
    private final IntegerType mathematicalIntegerType = new IntegerType(IntegerType.MATHEMATICAL);

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

    public IntegerType getIntegerType() {
        return mathematicalIntegerType;
    }

    public IntegerType getIntegerType(int bitWidth) {
        checkArgument(bitWidth > 0, "Non-positive bit width %s.", bitWidth);
        return typeNormalizer.normalize(new IntegerType(bitWidth));
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

    public record PrimitiveFieldInfo(Type type, List<Integer> elementOffsets) {}

    public List<Type> getPrimitiveFields(Type type) {
        if (type instanceof ArrayType array) {
            final List<Type> result = new ArrayList<>();
            final List<Type> elementFields = getPrimitiveFields(array.getElementType());
            for (int i = 0; i < array.getNumElements(); i++) {
                result.addAll(elementFields);
            }
            return result;
        }
        if (type instanceof AggregateType struct) {
            final List<Type> result = new ArrayList<>();
            for (final Type field : struct.getDirectFields()) {
                result.addAll(getPrimitiveFields(field));
            }
            return result;
        }
        return List.of(type);
    }

    /**
     * @param type Any type made from this.
     * @param offset Non-negative number of bytes the field is supposed to have.
     * @return Description of the most primitive field inside the boundaries of {@code type},
     * if it exists such that it is offset by {@code offset} bytes.
     */
    public Optional<PrimitiveFieldInfo> getPrimitiveField(Type type, int offset) {
        checkArgument(offset >= 0, "Field offset out of bounds");
        final int elementBytes = getMemorySizeInBytes(type);
        final List<Integer> elementPointer = new ArrayList<>();
        elementPointer.add(offset / elementBytes);
        Type currentType = type;
        int remainder = offset % elementBytes;
        while (currentType instanceof ArrayType || currentType instanceof AggregateType) {
            if (currentType instanceof ArrayType array) {
                final int bytes = getMemorySizeInBytes(array.getElementType());
                currentType = array.getElementType();
                elementPointer.add(remainder / bytes);
                remainder = remainder % bytes;
                continue;
            }
            int currentOffset = 0;
            for (final Type field : ((AggregateType) currentType).getDirectFields()) {
                final int bytes = getMemorySizeInBytes(field);
                if (remainder < bytes) {
                    currentType = field;
                    break;
                }
                remainder -= bytes;
                currentOffset++;
            }
            elementPointer.add(currentOffset);
        }
        return remainder == 0 ? Optional.of(new PrimitiveFieldInfo(currentType, elementPointer)) : Optional.empty();
    }

    /**
     * @param type Element type of the figurative array serving as a base.
     * @param offsets Non-empty list of type-dependent offsets, as given in a GEP instruction, starting with the index.
     */
    public int getByteOffset(Type type, List<? extends Number> offsets) {
        checkArgument(!offsets.isEmpty(), "Missing offsets");
        int result = getMemorySizeInBytes(type) * offsets.get(0).intValue();
        Type currentType = type;
        for (final Number offset : offsets.subList(1, offsets.size())) {
            if (currentType instanceof ArrayType array) {
                currentType = array.getElementType();
                result += offset.intValue() * getMemorySizeInBytes(currentType);
                continue;
            }
            checkArgument(currentType instanceof AggregateType,
                    "Unexpected primitive type in %s with offsets %s", type, offsets);
            final List<Type> fields = ((AggregateType) currentType).getDirectFields();
            final int index = offset.intValue();
            checkArgument(index >= 0 && index < fields.size(),
                    "Aggregate index out of bounds in %s with offsets %s", type, offsets);
            currentType = fields.get(index);
            for (final Type field : fields.subList(0, index)) {
                result += getMemorySizeInBytes(field);
            }
        }
        return result;
    }

    /**
     * @param type Datatype of the object pointed to.
     * @param constants Translated from a GEP expression, where non-constant expressions should be translated to 1.
     *                  Must be non-empty: type is treated as the element type of an array.
     * @return Numbers of bytes per constant.
     */
    public List<Integer> getByteCounts(Type type, List<Integer> constants) {
        checkArgument(!constants.isEmpty(), "Missing element pointer");
        final List<Integer> result = new ArrayList<>(constants.size());
        result.add(getMemorySizeInBytes(type) * constants.get(0));
        Type currentType = type;
        for (final Integer constant : constants.subList(1, constants.size())) {
            checkArgument(currentType instanceof ArrayType || currentType instanceof AggregateType,
                    "Insufficient container type %s in GEP %s", type, constants);
            if (currentType instanceof ArrayType array) {
                currentType = array.getElementType();
                result.add(constant * getMemorySizeInBytes(currentType));
            } else {
                final List<Type> fields = ((AggregateType) currentType).getDirectFields();
                result.add(constant * fields.subList(0, constant).stream().mapToInt(this::getMemorySizeInBytes).sum());
                currentType = fields.get(constant);
            }
        }
        return result;
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
            if (integerType.isMathematical()) {
                // FIXME: We cannot give proper sizes for mathematical integers.
                sizeInBytes = 8;
            } else {
                sizeInBytes = IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
            }
        } else if (type instanceof BooleanType) {
            sizeInBytes = 1;
        } else {
            throw new UnsupportedOperationException("Cannot compute the size of " + type);
        }
        return sizeInBytes;
    }
}
