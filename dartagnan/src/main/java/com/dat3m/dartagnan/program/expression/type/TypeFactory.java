package com.dat3m.dartagnan.program.expression.type;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

public final class TypeFactory {

    private static final TypeFactory instance = new TypeFactory();
    private final BooleanType booleanType = new BooleanType();
    private final NumberType numberType = new NumberType();
    private final PointerType pointerType = new PointerType();
    private final Map<Integer, IntegerType> integerTypeMap = new HashMap<>();
    private final Map<Type, Map<Integer, ArrayType>> arrayTypeMap = new HashMap<>();
    private final Map<List<Type>, AggregateType> aggregateTypeMap = new HashMap<>();

    private TypeFactory() {}

    public static TypeFactory getInstance() {
        return instance;
    }

    public BooleanType getBooleanType() {
        return booleanType;
    }

    public PointerType getPointerType() {
        return pointerType;
    }

    public NumberType getNumberType() {
        return numberType;
    }

    public IntegerType getIntegerType(int bitWidth) {
        return integerTypeMap.computeIfAbsent(bitWidth, IntegerType::new);
    }

    public ArrayType getArrayType(Type elementType, int elementCount) {
        checkArgument(elementCount >= 0);
        return arrayTypeMap.computeIfAbsent(elementType, k -> new HashMap<>())
                .computeIfAbsent(elementCount, k -> new ArrayType(elementType, k));
    }

    public ArrayType getArrayType(Type elementType) {
        return arrayTypeMap.computeIfAbsent(elementType, k -> new HashMap<>())
                .computeIfAbsent(-1, k -> new ArrayType(elementType, -1));
    }

    public AggregateType getAggregateType(List<Type> elementTypes) {
        return aggregateTypeMap.computeIfAbsent(elementTypes, AggregateType::new);
    }
}
